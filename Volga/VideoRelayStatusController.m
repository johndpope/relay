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
@property size_t framesWritten;
@end

@implementation VideoRelayStatusController

- (void)windowDidLoad {
  [super windowDidLoad];
  
  [self createLayer];
  
  self.status.stringValue = @"";

  self.window.title = [NSString stringWithFormat:@"Video Relay: %@", self.device.localizedName];
  
  self.client = [[MQTTClient alloc] initWithClientId:@"volga/video"];
  self.client.username = self.uri.user;
  self.client.password = self.uri.password;
  
  self.status.stringValue = @"connecting...";
  
  [self.client connectToHost:self.uri.host completionHandler:^(MQTTConnectionReturnCode code) {
    if(code != ConnectionAccepted) {
      dispatch_sync(dispatch_get_main_queue(), ^{
        self.status.stringValue = @"connection failed!";
        [NSAlert alertWithMessageText:@"connection failed!" defaultButton:@"Close" alternateButton:nil otherButton:nil informativeTextWithFormat:nil];
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
    [[NSAlert alertWithError:error] runModal];
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
  
  NSData *data = [NSData dataWithBytes:ptr length:length];
  
  [self.client publishData:data toTopic:self.topic withQos:AtMostOnce retain:NO completionHandler:nil];
  
  self.framesWritten++;
  [self updateStatus];
}

- (void)updateStatus
{
  self.status.stringValue = [NSString stringWithFormat:@"Frames sent: %lu", self.framesWritten];
}

@end
