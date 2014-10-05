//
//  VideoRelayStatusController.m
//  Volga
//
//  Created by Joël Gähwiler on 05.10.14.
//  Copyright (c) 2014 shiftr.io. All rights reserved.
//

#import "VideoRelayStatusController.h"

@interface VideoRelayStatusController ()
@property (strong) AVCaptureSession *captureSession;
@end

@implementation VideoRelayStatusController

- (void)windowDidLoad {
  [super windowDidLoad];
  
  self.status.stringValue = @"";
}

- (void)runWithDevice:(AVCaptureDevice *)device andNamespaceURI:(NSString *)uri
{
  self.window.title = [NSString stringWithFormat:@"Video Relay: %@", device.localizedName];
  
  NSError *error;
  
  AVCaptureDeviceInput *input = [[AVCaptureDeviceInput alloc] initWithDevice:device error:&error];
  
  self.captureSession = [[AVCaptureSession alloc] init];
  [self.captureSession addInput:input];
  
  AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
  previewLayer.frame = self.preview.bounds;
  [previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
  [self.preview.layer addSublayer:previewLayer];
  
  [[self.preview layer] setMasksToBounds:YES];
  
  AVCaptureStillImageOutput *stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
  NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
  [stillImageOutput setOutputSettings:outputSettings];
  
  [self.captureSession addOutput:stillImageOutput];
  
  if(error) {
    [[NSAlert alertWithError:error] runModal];
  }
  
  [self.captureSession startRunning];
}

@end
