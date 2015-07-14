//
//  OscRelayStatusController.m
//  Relay
//
//  Created by Joël Gähwiler on 05.10.14.
//  Copyright (c) 2014 shiftr.io. All rights reserved.
//

#import <Regexer/Regexer.h>

#import "OscRelayController.h"

@interface OscRelayController ()

@property (strong) OSCServer *server;
@property (strong) OSCClient *oscClient;
@property (strong) NSString *target;

@end

@implementation OscRelayController

- (void)windowDidLoad {
  [super windowDidLoad];
  
  self.status.stringValue = self.client.info;
  self.lastOut.stringValue = @"nothing outgoing";
  self.lastIn.stringValue = @"nothing incoming";
  
  self.client.delegate = self;
  [self.client connect];
  
  if(self.input > 0) {
    self.server = [[OSCServer alloc] init];
    self.server.delegate = self;
    [self.server listen:self.input];
  }
  
  if(self.output > 0) {
    self.oscClient = [[OSCClient alloc] init];
    self.target = [NSString stringWithFormat:@"udp://0.0.0.0:%li", (long)self.output];
  }
}

- (void)handleIncommingMessage:(CommonMessage*)message
{
  NSArray *matches = [message.topic rx_matchesWithPattern:@"^in(.*)"];
  if(matches.count == 1) {
    NSString* address = [matches[0][1] text];
    
    self.lastIn.stringValue = [NSString stringWithFormat:@"%@: %@", address, message.payloadString];
    
    NSError *error;
    NSArray *arguments = [NSJSONSerialization JSONObjectWithData:message.payloadData options:0 error:&error];
    if(error) {
      [[NSAlert alertWithError:error] runModal];
    }
    
    OSCMessage *message = [OSCMessage to:address with:arguments];
    [self.oscClient sendMessage:message to:self.target];
  }
}

#pragma mark OSCServerDelegate

- (void)handleMessage:(OSCMessage *)message
{
  NSString *topic = [NSString stringWithFormat:@"out%@", message.address];
  
  NSError *error;
  NSData *data = [NSJSONSerialization dataWithJSONObject:message.arguments options:0 error:&error];
  if(error) {
    [[NSAlert alertWithError:error] runModal];
    return;
  }
  
  self.lastOut.stringValue = [NSString stringWithFormat:@"%@: %@", message.address, [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
  [self.client publish:topic andPayload:data];
}

#pragma mark NSWindowDelegate

- (void)windowWillClose:(NSNotification *)notification
{
  [self.server stop];
  [self.client disconnect];
}

#pragma mark CommonClientDelegate

- (void)clientDidConnect
{
  self.status.stringValue = self.client.info;
  if(self.output ) {
    [self.client subscribe:@"in/#"];
  }
}

- (void)didReceiveMessage:(CommonMessage *)message
{
  [self handleIncommingMessage:message];
  self.status.stringValue = self.client.info;
}

@end
