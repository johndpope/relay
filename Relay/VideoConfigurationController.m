//
//  VideoConfigurationController.m
//  Relay
//
//  Created by Joël Gähwiler on 05.10.14.
//  Copyright (c) 2014 shiftr.io. All rights reserved.
//

#import "VideoConfigurationController.h"

#import "AppDelegate.h"
#import "CommonClient.h"
#import "VideoRelayController.h"
#import "VideoTestController.h"

@implementation VideoConfigurationController

- (void)loadView
{
  [super loadView];
  
  self.createdRelays = [NSMutableArray array];
  self.quality = @0.5;
  self.framerate = @10;
  
  [self.source removeAllItems];
  
  for (AVCaptureDevice *device in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
    [self.source addItemWithTitle:device.localizedName];
  }
}

- (IBAction)start:(id)sender
{
  AVCaptureDevice *device = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] objectAtIndex:self.source.indexOfSelectedItem];
  
  VideoRelayController* controller = [[VideoRelayController alloc] initWithWindowNibName:@"VideoRelay"];
  
  CommonClient *client = [[CommonClient alloc] init];
  client.uri = [NSURL URLWithString:self.appDelegate.namespaceURI];
  client.baseTopic = self.baseTopic.stringValue.copy;

  controller.device = device;
  controller.client = client;
  controller.framerate = self.framerate.copy;
  controller.quality = self.quality.copy;
  [controller showWindow:self];
  
  [self.createdRelays addObject:controller];
}

- (IBAction)test:(id)sender
{
  VideoTestController* controller = [[VideoTestController alloc] initWithWindowNibName:@"VideoTest"];
  
  CommonClient *client = [[CommonClient alloc] init];
  client.uri = [NSURL URLWithString:self.appDelegate.namespaceURI];
  client.baseTopic = self.baseTopic.stringValue.copy;
  
  controller.client = client;
  [controller showWindow:self];
  
  [self.createdRelays addObject:controller];
}

@end
