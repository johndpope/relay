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

@implementation VideoRelayConfigurationController

- (void)loadView
{
  [super loadView];
  
  self.createdRelays = [NSMutableArray array];
  
  [self.source removeAllItems];
  
  for (AVCaptureDevice *device in [AVCaptureDevice devices]) {
    [self.source addItemWithTitle:device.localizedName];
  }
}

- (IBAction)start:(id)sender
{
  VideoRelayStatusController* controller = [[VideoRelayStatusController alloc] initWithWindowNibName:@"VideoRelayStatus"];
  
  AVCaptureDevice *device = [[AVCaptureDevice devices] objectAtIndex:self.source.indexOfSelectedItem];
  
  [controller showWindow:self];
  [controller runWithDevice:device andNamespaceURI:self.appDelegate.namespaceURI];
  
  [self.createdRelays addObject:controller];
}

@end
