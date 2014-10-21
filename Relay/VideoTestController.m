//
//  VideoTestController.m
//  Relay
//
//  Created by Joël Gähwiler on 05.10.14.
//  Copyright (c) 2014 shiftr.io. All rights reserved.
//

#import "VideoTestController.h"

#import "CommonClient.h"

@implementation VideoTestController

- (void)windowDidLoad
{
  [super windowDidLoad];
  
  self.status.stringValue = self.client.info;
  
  self.client.delegate = self;
  [self.client connect];
  
  self.window.title = [NSString stringWithFormat:@"Video Test: %@", self.client.baseTopic];
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
  [self.client subscribe:@""];
}

- (void)didReceiveMessage:(CommonMessage *)message
{
  NSData *image = [[NSData alloc] initWithBase64EncodedData:message.payloadData options:0];
  self.preview.image = [[NSImage alloc] initWithData:image];
  self.status.stringValue = self.client.info;
}

@end
