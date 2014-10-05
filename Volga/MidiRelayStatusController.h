//
//  MidiRelayStatusController.h
//  Volga
//
//  Created by Joël Gähwiler on 05.10.14.
//  Copyright (c) 2014 shiftr.io. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <MIKMIDI/MIKMIDI.h>

@interface MidiRelayStatusController : NSWindowController

- (void)runWithSource:(MIKMIDISourceEndpoint*)source andDestination:(MIKMIDIDestinationEndpoint*)destination andNamespaceURI:(NSString*)uri;

@end
