//
//  VideoRelay.m
//  Volga
//
//  Created by Joël Gähwiler on 02.10.14.
//  Copyright (c) 2014 shiftr.io. All rights reserved.
//

#import "VideoRelay.h"

@implementation VideoRelay

- (void)setup:(NSString*)url andSource:(AVCaptureDevice*)source andPreview:(NSView*)preview;
{
  NSError *error;
  
  AVCaptureDeviceInput *input = [[AVCaptureDeviceInput alloc] initWithDevice:source error:&error];
  
  self.captureSession = [[AVCaptureSession alloc] init];
  [self.captureSession addInput:input];
  
  AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
  previewLayer.frame = preview.bounds;
  [previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
  [preview.layer addSublayer:previewLayer];
  
  [[preview layer] setMasksToBounds:YES];
  
  AVCaptureStillImageOutput *stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
  NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
  [stillImageOutput setOutputSettings:outputSettings];
  
  [self.captureSession addOutput:stillImageOutput];
  
  NSLog(@"%@", error);
  
  [self.captureSession startRunning];
}

@end
