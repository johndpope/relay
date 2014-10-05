//
//  VideoRelayStatusController.h
//  Volga
//
//  Created by Joël Gähwiler on 05.10.14.
//  Copyright (c) 2014 shiftr.io. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AVFoundation/AVFoundation.h>

@interface VideoRelayStatusController : NSWindowController <NSWindowDelegate>

@property (weak) IBOutlet NSTextField *status;
@property (weak) IBOutlet NSView *preview;

@property (strong) AVCaptureDevice* device;
@property (strong) NSString* uri;

@end
