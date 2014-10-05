//
//  VideoRelaytest.m
//  Volga
//
//  Created by Joël Gähwiler on 05.10.14.
//  Copyright (c) 2014 shiftr.io. All rights reserved.
//

#import "VideoRelayTestController.h"

@interface VideoRelayTestController ()
@property (strong) MQTTClient *client;
@property (strong) NSByteCountFormatter *formatter;
@property uint64 framesReceived;
@property uint64 totalBytes;
@end

@implementation VideoRelayTestController

- (void)windowDidLoad
{
  [super windowDidLoad];
  
  self.formatter = [[NSByteCountFormatter alloc] init];
  
  self.window.title = [NSString stringWithFormat:@"Video Test: %@", self.topic];
  
  self.status.stringValue = @"";
  self.framesReceived = 0;
  self.totalBytes = 0;
  
  self.client = [[MQTTClient alloc] initWithClientId:@"volga/video-test"];
  self.client.username = self.uri.user;
  self.client.password = self.uri.password;
  
  self.status.stringValue = @"connecting...";
  
  [self.client connectToHost:self.uri.host completionHandler:^(MQTTConnectionReturnCode code) {
    if(code != ConnectionAccepted) {
      dispatch_async(dispatch_get_main_queue(), ^{
        self.status.stringValue = @"connection failed!";
        [NSAlert alertWithMessageText:@"connection failed!" defaultButton:@"Close" alternateButton:nil otherButton:nil informativeTextWithFormat:nil];
      });
    } else {
      [self.client subscribe:self.topic withCompletionHandler:nil];
      
      dispatch_async(dispatch_get_main_queue(), ^{
        self.status.stringValue = @"connected!";
      });
    }
  }];
  
  __weak VideoRelayTestController *_self = self;
  
  [self.client setMessageHandler:^(MQTTMessage *message) {
    _self.framesReceived++;
    _self.totalBytes += message.payload.length;
    _self.status.stringValue = [NSString stringWithFormat:@"Frame: %@, Total: %llu - %@", [_self.formatter stringFromByteCount:message.payload.length], _self.framesReceived, [_self.formatter stringFromByteCount:_self.totalBytes]];
    dispatch_async(dispatch_get_main_queue(), ^{
      _self.preview.image = [[NSImage alloc] initWithData:message.payload];
    });
  }];
}

#pragma mark NSWindowDelegate

- (void)windowWillClose:(NSNotification *)notification
{
  [self.client disconnectWithCompletionHandler:nil];
}

@end
