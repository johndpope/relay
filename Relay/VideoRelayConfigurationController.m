//
//  VideoRelayController.m
//  Relay
//
//  Created by Joël Gähwiler on 05.10.14.
//  Copyright (c) 2014 shiftr.io. All rights reserved.
//

#import "VideoRelayConfigurationController.h"

#import "AppDelegate.h"
#import "CommonClient.h"
#import "VideoRelayStatusController.h"
#import "VideoRelayTestStatusController.h"

@implementation VideoRelayConfigurationController

- (void)loadView
{
  [super loadView];
  
  self.createdControllers = [NSMutableArray array];
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
  
  VideoRelayStatusController* controller = [[VideoRelayStatusController alloc] initWithWindowNibName:@"VideoRelayStatus"];
  
  CommonClient *client = [[CommonClient alloc] init];
  client.uri = [NSURL URLWithString:self.appDelegate.namespaceURI];
  client.baseTopic = self.topic.stringValue.copy;

  controller.device = device;
  controller.client = client;
  controller.framerate = self.framerate.copy;
  controller.quality = self.quality.copy;
  [controller showWindow:self];
  
  [self.createdControllers addObject:controller];
}

- (IBAction)test:(id)sender
{
  VideoRelayTestStatusController* controller = [[VideoRelayTestStatusController alloc] initWithWindowNibName:@"VideoRelayTest"];
  
    CommonClient *client = [[CommonClient alloc] init];
  client.uri = [NSURL URLWithString:self.appDelegate.namespaceURI];
  client.baseTopic = self.topic.stringValue.copy;
  
  controller.client = client;
  [controller showWindow:self];
  
  [self.createdControllers addObject:controller];
}

@end
