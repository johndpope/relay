//
//  AppDelegate.m
//  Volga
//
//  Created by Joël Gähwiler on 24.09.14.
//  Copyright (c) 2014 shiftr.io. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {}

- (void)applicationWillTerminate:(NSNotification *)aNotification {}

- (void)awakeFromNib {
  self.deviceManager = [MIKMIDIDeviceManager sharedDeviceManager];
  
  self.statusLabel.stringValue = @"";
  
  [self.sourcesPopUp removeAllItems];
  [self.destinationsPopUp removeAllItems];
  
  for (MIKMIDISourceEndpoint *source in [self.deviceManager virtualSources]) {
    [self.sourcesPopUp addItemWithTitle:source.name];
  }
  
  for (MIKMIDIDestinationEndpoint *destination in [self.deviceManager virtualDestinations]) {
    [self.destinationsPopUp addItemWithTitle:destination.name];
  }
  
  [self.videoSourcePopUp removeAllItems];
  
  for (AVCaptureDevice *device in [AVCaptureDevice devices]) {
    [self.videoSourcePopUp addItemWithTitle:device.localizedName];
  }
}

- (IBAction)startMidiRelay:(id)sender {
  MIKMIDISourceEndpoint *source = [self.deviceManager.virtualSources objectAtIndex:self.sourcesPopUp.indexOfSelectedItem];
  MIKMIDIDestinationEndpoint *destination = [self.deviceManager.virtualDestinations objectAtIndex:self.destinationsPopUp.indexOfSelectedItem];
  
  self.currentMidiRelay = [MidiRelay alloc];
  [self.currentMidiRelay setup:self.uriTextField.stringValue andSource:source andDestination:destination];
}

- (IBAction)startVideoRelay:(id)sender {
  AVCaptureDevice *source = [[AVCaptureDevice devices] objectAtIndex:self.videoSourcePopUp.indexOfSelectedItem];
  
  self.currentVideoRelay = [VideoRelay alloc];
  [self.currentVideoRelay setup:self.uriTextField.stringValue andSource:source andPreview:self.videoPreview];
}

@end
