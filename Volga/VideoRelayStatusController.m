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
@property (strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (strong) NSArray *observers;
@end

@implementation VideoRelayStatusController

- (void)windowDidLoad {
  [super windowDidLoad];
  
  self.status.stringValue = @"";

  self.window.title = [NSString stringWithFormat:@"Video Relay: %@", self.device.localizedName];
  
  NSError *error;
  
  AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:&error];
  
  self.captureSession = [[AVCaptureSession alloc] init];
  self.captureSession.sessionPreset = AVCaptureSessionPresetHigh;
  [self.captureSession addInput:input];
  
  self.preview.layer = [CALayer layer];
  self.preview.layer.frame = self.preview.bounds;
  self.preview.layer.backgroundColor = CGColorGetConstantColor(kCGColorBlack);
  self.preview.layer.borderColor = CGColorGetConstantColor(kCGColorBlack);
  self.preview.layer.borderWidth = 1;
  self.preview.wantsLayer = YES;
  
  self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
  self.previewLayer.frame = self.preview.bounds;
  [self.preview.layer addSublayer:self.previewLayer];
  
//  AVCaptureStillImageOutput *stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
//  NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
//  [stillImageOutput setOutputSettings:outputSettings];
//  
//  [self.captureSession addOutput:stillImageOutput];
  
  if(error) {
    [[NSAlert alertWithError:error] runModal];
  }
  
  [self.captureSession startRunning];
}

- (void)windowDidResize:(NSNotification *)notification
{
  self.preview.layer.frame = self.preview.bounds;
  self.previewLayer.frame = self.preview.bounds;
}

@end
