//
//  VideoRelayStatusController.m
//  Volga
//
//  Created by Joël Gähwiler on 05.10.14.
//  Copyright (c) 2014 shiftr.io. All rights reserved.
//

#import "VideoRelayStatusController.h"

@interface VideoRelayStatusController ()
@property (strong) MQTTClient *client;
@property (strong) AVCaptureSession *captureSession;
@property (strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (strong) AVCaptureVideoDataOutput* output;
@property (strong) NSArray *observers;
@property (strong) NSByteCountFormatter *formatter;
@property uint64 framesWritten;
@property uint64 totalBytes;
@end

@implementation VideoRelayStatusController

- (void)windowDidLoad {
  [super windowDidLoad];
  
  [self createLayer];
  
  self.status.stringValue = @"";
  self.framesWritten = 0;
  self.totalBytes = 0;
  
  self.formatter = [[NSByteCountFormatter alloc] init];

  self.window.title = [NSString stringWithFormat:@"Video Relay: %@", self.device.localizedName];
  
  self.client = [[MQTTClient alloc] initWithClientId:@"volga/video"];
  self.client.username = self.uri.user;
  self.client.password = self.uri.password;
  
  self.status.stringValue = @"connecting...";
  
  [self.client connectToHost:self.uri.host completionHandler:^(MQTTConnectionReturnCode code) {
    if(code != ConnectionAccepted) {
      dispatch_sync(dispatch_get_main_queue(), ^{
        self.status.stringValue = @"connection failed!";
      });
    } else {
      dispatch_sync(dispatch_get_main_queue(), ^{
        self.status.stringValue = @"connected!";
        [self startCaptureSession];
      });
    }
  }];
}

- (void)createLayer
{
  self.preview.layer = [CALayer layer];
  self.preview.layer.frame = self.preview.bounds;
  self.preview.layer.backgroundColor = CGColorGetConstantColor(kCGColorBlack);
  self.preview.layer.borderColor = CGColorGetConstantColor(kCGColorBlack);
  self.preview.layer.borderWidth = 1;
  self.preview.wantsLayer = YES;
}

- (void)startCaptureSession
{
  NSError *error;
  
  [self.device lockForConfiguration:&error];
  
  self.device.activeVideoMinFrameDuration = CMTimeMake(1, (int)self.framerate);
  
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
  NSDictionary* videoSettings = @{
                                  AVVideoCodecKey: AVVideoCodecJPEG
                                  };
  [self.output setVideoSettings:videoSettings];
  [self.captureSession addOutput:self.output];
  
  if(error) {
    self.status.stringValue = @"capture failed!";
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
  [self.client disconnectWithCompletionHandler:nil];
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
  
  [self.client publishData:data toTopic:self.topic withQos:AtMostOnce retain:NO completionHandler:nil];
  
  self.framesWritten++;
  self.totalBytes += length;
  self.status.stringValue = [NSString stringWithFormat:@"Frame: %@, Total: %llu - %@", [self.formatter stringFromByteCount:length], self.framesWritten, [self.formatter stringFromByteCount:self.totalBytes]];
}

@end
