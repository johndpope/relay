//
//  MidiConfigurationController.h
//  Relay
//
//  Created by Joël Gähwiler on 05.10.14.
//  Copyright (c) 2014 shiftr.io. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <MIKMIDI/MIKMIDI.h>

@class AppDelegate;

@interface MidiConfigurationController : NSViewController

@property (weak) IBOutlet NSPopUpButton *source;
@property (weak) IBOutlet NSPopUpButton *destination;
@property (weak) IBOutlet NSTextField *baseTopic;

- (IBAction)start:(id)sender;

@property (weak) AppDelegate *appDelegate;
@property (strong) NSMutableArray *createdRelays;

@end
