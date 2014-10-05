//
//  MidiRelayController.m
//  Volga
//
//  Created by Joël Gähwiler on 05.10.14.
//  Copyright (c) 2014 shiftr.io. All rights reserved.
//

#import "MidiRelayConfigurationController.h"

#import "AppDelegate.h"
#import "MidiRelayStatusController.h"

@implementation MidiRelayConfigurationController

- (void)loadView
{
  [super loadView];
  
  self.createdRelays = [NSMutableArray array];
  
  [self.source removeAllItems];
  [self.destination removeAllItems];

  for (MIKMIDISourceEndpoint *source in [[MIKMIDIDeviceManager sharedDeviceManager] virtualSources]) {
    [self.source addItemWithTitle:source.name];
  }

  for (MIKMIDIDestinationEndpoint *destination in [[MIKMIDIDeviceManager sharedDeviceManager] virtualDestinations]) {
    [self.destination addItemWithTitle:destination.name];
  }
}

- (IBAction)start:(id)sender
{
  MidiRelayStatusController* controller = [[MidiRelayStatusController alloc] initWithWindowNibName:@"MidiRelayStatus"];
  
  [controller showWindow:self];
  
  MIKMIDISourceEndpoint *source = [[[MIKMIDIDeviceManager sharedDeviceManager] virtualSources] objectAtIndex:self.source.indexOfSelectedItem];
  MIKMIDIDestinationEndpoint *destination = [[[MIKMIDIDeviceManager sharedDeviceManager] virtualDestinations] objectAtIndex:self.destination.indexOfSelectedItem];
  
  [controller runWithSource:source andDestination:destination andNamespaceURI:self.appDelegate.namespaceURI];
  
  [self.createdRelays addObject:controller];
}

@end
