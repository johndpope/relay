//
//  MidiRelayStatusController.h
//  Relay
//
//  Created by Joël Gähwiler on 05.10.14.
//  Copyright (c) 2014 shiftr.io. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <MIKMIDI/MIKMIDI.h>

#import "CommonClient.h"

@interface MidiRelayController : NSWindowController <CommonClientDelegate>

@property (weak) IBOutlet NSTextField *status;
@property (weak) IBOutlet NSTextField *lastOut;
@property (weak) IBOutlet NSTextField *lastIn;

@property (strong) CommonClient* client;
@property (strong) MIKMIDISourceEndpoint *source;
@property (strong) MIKMIDIDestinationEndpoint *destination;

@end
