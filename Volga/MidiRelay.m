//
//  MidiRelay.m
//  Volga
//
//  Created by Joël Gähwiler on 24.09.14.
//  Copyright (c) 2014 shiftr.io. All rights reserved.
//

#import "MidiRelay.h"

@implementation MidiRelay

- (void)setup:(NSString*)uri andSource:(MIKMIDISourceEndpoint*)source andDestination:(MIKMIDIDestinationEndpoint*)destination {
  self.namespaceUri = [[NSURL alloc] initWithString:uri];
  
  self.client = [[MQTTClient alloc] initWithClientId:@"volga/1"];
  
  self.client.username = self.namespaceUri.user;
  self.client.password = self.namespaceUri.password;
  
  MidiRelay * this = self;
  
  [self.client setMessageHandler:^(MQTTMessage *message) {
    [this handleIncommingMessage:message];
  }];

  [self.client connectToHost:self.namespaceUri.host completionHandler:^(NSUInteger code) {
    if (code == ConnectionAccepted) {
      NSLog(@"connected!");
      [self.client subscribe:@"/midi/out/control" withCompletionHandler:nil];
      [self.client subscribe:@"/midi/out/note/*" withCompletionHandler:nil];
    } else {
      NSLog(@"[MQTT] error: %lu", (unsigned long)code);
    }
  }];
  
  [[MIKMIDIDeviceManager sharedDeviceManager] connectInput:source error:nil eventHandler:^(MIKMIDISourceEndpoint *source, NSArray *commands) {
    for (MIKMIDICommand *command in commands) {
      if(command.commandType == MIKMIDICommandTypeControlChange) {
        MIKMIDIControlChangeCommand *cc = (MIKMIDIControlChangeCommand*)command;
        [self sendPairedMessageToTopic:@"/midi/in/control" andNumbers:@[[NSNumber numberWithUnsignedLong:cc.channel], [NSNumber numberWithUnsignedLong:cc.controllerNumber], [NSNumber numberWithUnsignedLong:cc.controllerValue]]];
      } else if(command.commandType == MIKMIDICommandTypeNoteOn) {
        MIKMIDINoteOnCommand *noc = (MIKMIDINoteOnCommand*)command;
        [self sendPairedMessageToTopic:@"/midi/in/note/on" andNumbers:@[[NSNumber numberWithUnsignedLong:noc.channel], [NSNumber numberWithUnsignedLong:noc.note], [NSNumber numberWithUnsignedLong:noc.velocity]]];
      } else if(command.commandType == MIKMIDICommandTypeNoteOff) {
        MIKMIDINoteOffCommand *noc = (MIKMIDINoteOffCommand*)command;
        [self sendPairedMessageToTopic:@"/midi/in/note/off" andNumbers:@[[NSNumber numberWithUnsignedLong:noc.channel], [NSNumber numberWithUnsignedLong:noc.note], [NSNumber numberWithUnsignedLong:noc.velocity]]];
      } else {
        NSLog(@"unrecognized midi command %lu", command.commandType);
      }
    }
  }];
}

- (void)sendPairedMessageToTopic:(NSString*)topic andNumbers:(NSArray*)numbers
{
  NSString *payload = [NSString stringWithFormat:@"%lu:%lu:%lu", ((NSNumber*)numbers[0]).integerValue, ((NSNumber*)numbers[1]).integerValue, ((NSNumber*)numbers[2]).integerValue];
  [self.client publishString:payload toTopic:topic withQos:AtMostOnce retain:NO completionHandler:nil];
}

- (NSArray*)parsePairedPayload:(NSString*)payload
{
  return [payload componentsSeparatedByString:@":"];
}

- (void)handleIncommingMessage:(MQTTMessage*)message
{
  NSArray* values = [self parsePairedPayload:message.payloadString];
  NSMutableArray *commands = [NSMutableArray arrayWithCapacity:1];
  
  if([message.topic isEqualToString:@"/midi/out/control"]) {
    MIKMutableMIDIControlChangeCommand *cc = [[MIKMutableMIDIControlChangeCommand alloc] init];
    cc.channel = [values[0] integerValue];
    cc.controllerNumber = [values[1] integerValue];
    cc.controllerValue = [values[2] integerValue];
    [commands addObject:cc];
  } else if([message.topic isEqualToString:@"/midi/out/note/on"]) {
    MIKMutableMIDINoteOnCommand * noc = [[MIKMutableMIDINoteOnCommand alloc] init];
    noc.channel = [values[0] integerValue];
    noc.note = [values[1] integerValue];
    noc.velocity = [values[2] integerValue];
    [commands addObject:noc];
  } else if([message.topic isEqualToString:@"/midi/out/note/off"]) {
    MIKMutableMIDINoteOffCommand * noc = [[MIKMutableMIDINoteOffCommand alloc] init];
    noc.channel = [values[0] integerValue];
    noc.note = [values[1] integerValue];
    noc.velocity = [values[2] integerValue];
    [commands addObject:noc];
  }
  
  [[MIKMIDIDeviceManager sharedDeviceManager] sendCommands:commands toEndpoint:self.destination error:nil];
}

@end
