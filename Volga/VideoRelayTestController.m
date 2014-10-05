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
@end

@implementation VideoRelayTestController

- (void)windowDidLoad
{
  [super windowDidLoad];
  
  self.window.title = [NSString stringWithFormat:@"Video Test: %@", self.topic];
  self.status.stringValue = @"";
  
  self.client = [[MQTTClient alloc] initWithClientId:@"volga/video-test"];
  self.client.username = self.uri.user;
  self.client.password = self.uri.password;
  
  self.status.stringValue = @"connecting...";
  
  [self.client connectToHost:self.uri.host completionHandler:^(MQTTConnectionReturnCode code) {
    if(code != ConnectionAccepted) {
      dispatch_sync(dispatch_get_main_queue(), ^{
        self.status.stringValue = @"connection failed!";
        [NSAlert alertWithMessageText:@"connection failed!" defaultButton:@"Close" alternateButton:nil otherButton:nil informativeTextWithFormat:nil];
      });
    } else {
      [self.client subscribe:self.topic withCompletionHandler:nil];
      
      dispatch_sync(dispatch_get_main_queue(), ^{
        self.status.stringValue = @"connected!";
      });
    }
  }];
  
  __weak VideoRelayTestController *_self = self;
  
  [self.client setMessageHandler:^(MQTTMessage *message) {
    _self.preview.image = [[NSImage alloc] initWithData:message.payload];
  }];
}

@end
