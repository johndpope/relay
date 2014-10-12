//
//  VideoRelayStatusController.h
//  Relay
//
//  Created by Joël Gähwiler on 05.10.14.
//  Copyright (c) 2014 shiftr.io. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AVFoundation/AVFoundation.h>

#import "CommonClient.h"

@interface VideoRelayController : NSWindowController <NSWindowDelegate, AVCaptureVideoDataOutputSampleBufferDelegate, CommonClientDelegate>

@property (weak) IBOutlet NSView *preview;
@property (weak) IBOutlet NSTextField *status;

@property (strong) CommonClient* client;
@property (strong) AVCaptureDevice* device;
@property (strong) NSNumber* framerate;
@property (strong) NSNumber* quality;

@end
