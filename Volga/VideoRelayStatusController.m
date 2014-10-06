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
@property (strong) AVCaptureVideoDataOutput* output;
@end

@implementation VideoRelayStatusController

- (void)windowDidLoad {
  [super windowDidLoad];
  
  self.status.stringValue = self.client.info;
  
  self.client.delegate = self;
  [self.client connect];
  
  self.preview.layer = [CALayer layer];
  self.preview.layer.frame = self.preview.bounds;
  self.preview.layer.backgroundColor = CGColorGetConstantColor(kCGColorBlack);
  self.preview.layer.borderColor = CGColorGetConstantColor(kCGColorBlack);
  self.preview.layer.borderWidth = 1;
  self.preview.wantsLayer = YES;
  
  self.window.title = [NSString stringWithFormat:@"Video Relay: %@", self.device.localizedName];
}

- (void)startCaptureSession
{
  NSError *error;
  
  [self.device lockForConfiguration:&error];
  
  self.device.activeVideoMinFrameDuration = CMTimeMake(1, (int)self.framerate.integerValue);
  
  AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:&error];
  
  self.captureSession = [[AVCaptureSession alloc] init];
  self.captureSession.sessionPreset = AVCaptureSessionPresetHigh;
  [self.captureSession addInput:input];
  
  self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
  self.previewLayer.frame = self.preview.bounds;
  [self.preview.layer addSublayer:self.previewLayer];
  
  self.output = [[AVCaptureVideoDataOutput alloc] init];
  self.output.alwaysDiscardsLateVideoFrames = YES;
  [self.output setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
  [self.output setVideoSettings:@{
    AVVideoCodecKey: AVVideoCodecJPEG,
    AVVideoCompressionPropertiesKey: @{
      AVVideoQualityKey: self.quality
    }
  }];
  [self.captureSession addOutput:self.output];
  
  if(error) {
    NSLog(@"%@", error);
  } else {
    [self.captureSession startRunning];
  }
}

#pragma mark NSWindowDelegate

- (void)windowDidResize:(NSNotification *)notification
{
  self.preview.layer.frame = self.preview.bounds;
  self.previewLayer.frame = self.preview.bounds;
}

- (void)windowWillClose:(NSNotification *)notification
{
  [self.captureSession stopRunning];
  [self.client disconnect];
}

#pragma mark AVCaptureVideoDataOutputSampleBufferDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
  if (CMSampleBufferGetNumSamples(sampleBuffer) != 1) return;
  if (!CMSampleBufferIsValid(sampleBuffer)) return;
  if (!CMSampleBufferDataIsReady(sampleBuffer)) return;
  
  CMBlockBufferRef dataBuffer = CMSampleBufferGetDataBuffer(sampleBuffer);
  
  char * ptr;
  size_t length = CMBlockBufferGetDataLength(dataBuffer);
  CMBlockBufferGetDataPointer(dataBuffer, 0, 0, &length, &ptr);
  
  NSData *data = [[NSData dataWithBytes:ptr length:length] base64EncodedDataWithOptions:0];
  
  [self.client publish:@"" andPayload:data];
  
  self.status.stringValue = self.client.info;
}

#pragma mark CommonClientDelegate

- (void)clientDidConnect
{
  [self startCaptureSession];
}

- (void)didReceiveMessage:(MQTTMessage *)message {}

@end
