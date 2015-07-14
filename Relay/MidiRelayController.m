//
//  MidiRelayController.m
//  Relay
//
//  Created by Joël Gähwiler on 05.10.14.
//  Copyright (c) 2014 shiftr.io. All rights reserved.
//

#import <Regexer/Regexer.h>

#import "MidiRelayController.h"

@implementation MidiRelayController

- (void)windowDidLoad {
  [super windowDidLoad];
  
  self.status.stringValue = self.client.info;
  self.lastOut.stringValue = @"nothing outgoing";
  self.lastIn.stringValue = @"nothing incoming";
  
  self.client.delegate = self;
  [self.client connect];

  if(self.source) {
    [[MIKMIDIDeviceManager sharedDeviceManager] connectInput:self.source error:nil eventHandler:^(MIKMIDISourceEndpoint *source, NSArray *commands) {
    for (MIKMIDICommand *command in commands) {
      [self sendMidiCommand:command];
      self.status.stringValue = self.client.info;
    }
  }];
  }
}

- (void)sendMidiCommand:(MIKMIDICommand*)command
{
  if(command.commandType == MIKMIDICommandTypeControlChange) {
    MIKMIDIControlChangeCommand *cc = (MIKMIDIControlChangeCommand*)command;
    NSString *topic = [NSString stringWithFormat:@"out/channel/%hhu/control/%lu", cc.channel, cc.controllerNumber];
    self.lastOut.stringValue = [NSString stringWithFormat:@"CC %hhu/%lu: %lu", cc.channel, cc.controllerNumber, cc.controllerValue];
    [self.client publish:topic andStringPayload:[NSString stringWithFormat:@"%lu", cc.controllerValue]];
  } else if(command.commandType == MIKMIDICommandTypeNoteOn) {
    MIKMIDINoteOnCommand *noc = (MIKMIDINoteOnCommand*)command;
    NSString *topic = [NSString stringWithFormat:@"out/channel/%hhu/note/%lu/on", noc.channel, noc.note];
    self.lastOut.stringValue = [NSString stringWithFormat:@"N+ %hhu/%lu: %lu", noc.channel, noc.note, noc.velocity];
    [self.client publish:topic andStringPayload:[NSString stringWithFormat:@"%lu", noc.velocity]];
  } else if(command.commandType == MIKMIDICommandTypeNoteOff) {
    MIKMIDINoteOffCommand *noc = (MIKMIDINoteOffCommand*)command;
    NSString *topic = [NSString stringWithFormat:@"out/channel/%hhu/note/%lu/off", noc.channel, noc.note];
    self.lastOut.stringValue = [NSString stringWithFormat:@"N- %hhu/%lu: %lu", noc.channel, noc.note, noc.velocity];
    [self.client publish:topic andStringPayload:[NSString stringWithFormat:@"%lu", noc.velocity]];
  } else {
    NSLog(@"unrecognized midi command %lu", command.commandType);
  }
}

- (void)handleIncommingMessage:(CommonMessage*)message
{
  NSMutableArray *commands = [NSMutableArray arrayWithCapacity:1];

  NSArray *matches1 = [message.topic rx_matchesWithPattern:@"in/channel/(\\d+)/control/(\\d+)"];
  if(matches1.count == 1) {
    UInt8 channel = [[matches1[0][1] text] integerValue];
    NSUInteger controller = [[matches1[0][2] text] integerValue];
    NSUInteger value = [message.payloadString integerValue];
    
    self.lastIn.stringValue = [NSString stringWithFormat:@"CC %hhu/%lu: %lu", channel, controller, value];
    
    MIKMutableMIDIControlChangeCommand *cc = [[MIKMutableMIDIControlChangeCommand alloc] init];
    cc.channel = channel;
    cc.controllerNumber = controller;
    cc.controllerValue = value;
    [commands addObject:cc];
  }
  
  NSArray *matches2 = [message.topic rx_matchesWithPattern:@"in/channel/(\\d+)/note/(\\d+)/on"];
  if(matches2.count == 1) {
    UInt8 channel = [[matches2[0][1] text] integerValue];
    NSUInteger note = [[matches2[0][2] text] integerValue];
    NSUInteger velocity = [message.payloadString integerValue];
    
    self.lastIn.stringValue = [NSString stringWithFormat:@"N+ %hhu/%lu: %lu", channel, note, velocity];
    
    MIKMutableMIDINoteOnCommand * noc = [[MIKMutableMIDINoteOnCommand alloc] init];
    noc.channel = channel;
    noc.note = note;
    noc.velocity = velocity;
    [commands addObject:noc];
  }
  
  NSArray *matches3 = [message.topic rx_matchesWithPattern:@"in/channel/(\\d+)/note/(\\d+)/off"];
  if(matches3.count == 1) {
    UInt8 channel = [[matches3[0][1] text] integerValue];
    NSUInteger note = [[matches3[0][2] text] integerValue];
    NSUInteger velocity = [message.payloadString integerValue];
    
    self.lastIn.stringValue = [NSString stringWithFormat:@"N- %hhu/%lu: %lu", channel, note, velocity];
    
    MIKMutableMIDINoteOffCommand * noc = [[MIKMutableMIDINoteOffCommand alloc] init];
    noc.channel = channel;
    noc.note = note;
    noc.velocity = velocity;
    [commands addObject:noc];
  }
  
  NSError *error;
  [[MIKMIDIDeviceManager sharedDeviceManager] sendCommands:commands toEndpoint:self.destination error:&error];
  if(error) {
    [[NSAlert alertWithError:error] runModal];
  }
}

#pragma mark NSWindowDelegate

- (void)windowWillClose:(NSNotification *)notification
{
  [self.client disconnect];
}

#pragma mark CommonClientDelegate

- (void)clientDidConnect
{
  self.status.stringValue = self.client.info;
  [self.client subscribe:@"in/channel/+/control/+"];
  [self.client subscribe:@"in/channel/+/note/+/on"];
  [self.client subscribe:@"in/channel/+/note/+/off"];
}

- (void)didReceiveMessage:(CommonMessage *)message
{
  [self handleIncommingMessage:message];
  self.status.stringValue = self.client.info;
}

@end
