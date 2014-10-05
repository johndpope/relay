//
//  MidiRelayStatusController.m
//  Volga
//
//  Created by Joël Gähwiler on 05.10.14.
//  Copyright (c) 2014 shiftr.io. All rights reserved.
//

#import "MidiRelayStatusController.h"

@implementation MidiRelayStatusController

- (void)windowDidLoad {
  [super windowDidLoad];
}

- (void)runWithSource:(MIKMIDISourceEndpoint *)source andDestination:(MIKMIDIDestinationEndpoint *)destination andNamespaceURI:(NSString *)uri
{
//  self.currentMidiRelay = [MidiRelay alloc];
//  [self.currentMidiRelay setup:self.uriTextField.stringValue andSource:source andDestination:destination];
}

@end
