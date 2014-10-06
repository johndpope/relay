//
//  VideoRelayStatusController.h
//  Volga
//
//  Created by Joël Gähwiler on 05.10.14.
//  Copyright (c) 2014 shiftr.io. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AVFoundation/AVFoundation.h>
#import <MQTTKit/MQTTKit.h>

@interface VideoRelayStatusController : NSWindowController <NSWindowDelegate, AVCaptureVideoDataOutputSampleBufferDelegate>

@property (weak) IBOutlet NSTextField *status;
@property (weak) IBOutlet NSView *preview;

@property (strong) AVCaptureDevice* device;
@property (strong) NSURL* uri;
@property (strong) NSString* topic;
@property (strong) NSNumber* framerate;
@property (strong) NSNumber* quality;

@end
