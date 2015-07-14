//
//  AppDelegate.h
//  Relay
//
//  Created by Joël Gähwiler on 24.09.14.
//  Copyright (c) 2014 shiftr.io. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MidiConfigurationController;
@class OscConfigurationController;

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (weak) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTextField *uriTextField;
@property (weak) IBOutlet NSTabView *tabView;

@property (strong) MidiConfigurationController *midiConfigurationController;
@property (strong) OscConfigurationController *oscConfigurationController;

- (NSString*)namespaceURI;

@end
