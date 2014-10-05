//
//  VideoRelayController.m
//  Volga
//
//  Created by Joël Gähwiler on 05.10.14.
//  Copyright (c) 2014 shiftr.io. All rights reserved.
//

#import "VideoRelayConfigurationController.h"

#import "AppDelegate.h"
#import "VideoRelayStatusController.h"
#import "VideoRelayTestController.h"

@implementation VideoRelayConfigurationController

- (void)loadView
{
  [super loadView];
  
  self.createdControllers = [NSMutableArray array];
  
  [self.source removeAllItems];
  
  for (AVCaptureDevice *device in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
    [self.source addItemWithTitle:device.localizedName];
  }
}

- (IBAction)start:(id)sender
{
  AVCaptureDevice *device = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] objectAtIndex:self.source.indexOfSelectedItem];
  
  VideoRelayStatusController* controller = [[VideoRelayStatusController alloc] initWithWindowNibName:@"VideoRelayStatus"];

  controller.device = device;
  controller.uri = [NSURL URLWithString:self.appDelegate.namespaceURI];
  controller.topic = self.topic.stringValue.copy;
  [controller showWindow:self];
  
  [self.createdControllers addObject:controller];
}

- (IBAction)test:(id)sender
{
  VideoRelayTestController* controller = [[VideoRelayTestController alloc] initWithWindowNibName:@"VideoRelayTest"];
  
  controller.uri = [NSURL URLWithString:self.appDelegate.namespaceURI];
  controller.topic = self.topic.stringValue.copy;
  [controller showWindow:self];
  
  [self.createdControllers addObject:controller];
}

@end
