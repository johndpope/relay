//
//  VideoRelay.h
//  Volga
//
//  Created by Joël Gähwiler on 02.10.14.
//  Copyright (c) 2014 shiftr.io. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AVFoundation/AVFoundation.h>

@interface VideoRelay : NSObject

@property (strong) AVCaptureSession *captureSession;

- (void)setup:(NSString*)url andSource:(AVCaptureDevice*)source andPreview:(NSView*)preview;

@end
