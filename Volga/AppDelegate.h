//
//  AppDelegate.h
//  Volga
//
//  Created by Joël Gähwiler on 24.09.14.
//  Copyright (c) 2014 shiftr.io. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <MIKMIDI.h>
#import <AVKit/AVKit.h>

#import "MidiRelay.h"
#include "VideoRelay.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (weak) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTextField *uriTextField;


@property (weak) IBOutlet NSPopUpButton *sourcesPopUp;
@property (weak) IBOutlet NSPopUpButton *destinationsPopUp;
@property (weak) IBOutlet NSTextField *statusLabel;

@property (weak) IBOutlet NSPopUpButton *videoSourcePopUp;
@property (weak) IBOutlet NSView *videoPreview;

@property (strong) MIKMIDIDeviceManager *deviceManager;
@property (strong) MidiRelay* currentMidiRelay;
@property (strong) VideoRelay* currentVideoRelay;
  
- (IBAction)startMidiRelay:(id)sender;
- (IBAction)startVideoRelay:(id)sender;

@end
