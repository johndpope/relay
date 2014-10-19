//
//  MidiRelayController.m
//  Relay
//
//  Created by Joël Gähwiler on 05.10.14.
//  Copyright (c) 2014 shiftr.io. All rights reserved.
//

#import "MidiConfigurationController.h"

#import "AppDelegate.h"
#import "MidiRelayController.h"

@implementation MidiConfigurationController

- (void)loadView
{
  [super loadView];
  
  self.createdRelays = [NSMutableArray array];
  
  [self.source removeAllItems];
  [self.destination removeAllItems];

  for (MIKMIDISourceEndpoint *source in [[MIKMIDIDeviceManager sharedDeviceManager] virtualSources]) {
    [self.source addItemWithTitle:source.name];
  }
  
  [self.source addItemWithTitle:@"skip"];

  for (MIKMIDIDestinationEndpoint *destination in [[MIKMIDIDeviceManager sharedDeviceManager] virtualDestinations]) {
    [self.destination addItemWithTitle:destination.name];
  }
  
  [self.destination addItemWithTitle:@"skip"];
}

- (IBAction)start:(id)sender
{
  MIKMIDISourceEndpoint *source;
  MIKMIDIDestinationEndpoint *destination;
  
  if(![self.source.selectedItem.title isEqualToString:@"skip"]) {
    source = [[[MIKMIDIDeviceManager sharedDeviceManager] virtualSources] objectAtIndex:self.source.indexOfSelectedItem];
  }
  
  if(![self.destination.selectedItem.title isEqualToString:@"skip"]) {
    destination = [[[MIKMIDIDeviceManager sharedDeviceManager] virtualDestinations] objectAtIndex:self.destination.indexOfSelectedItem];
  }
  
  if(!source && !destination) {
    [[NSAlert alertWithMessageText:@"Couldn't start Relay!" defaultButton:@"OK" alternateButton:@"" otherButton:@"" informativeTextWithFormat:@"Either a source or destination device is needed."] runModal];
  } else {
    CommonClient *client = [[CommonClient alloc] init];
    client.uri = [NSURL URLWithString:self.appDelegate.namespaceURI];
    client.baseTopic = self.baseTopic.stringValue.copy;
  
    MidiRelayController* controller = [[MidiRelayController alloc] initWithWindowNibName:@"MidiRelay"];
    controller.client = client;
    controller.source = source;
    controller.destination = destination;
    [controller showWindow:self];
  
    [self.createdRelays addObject:controller];
  }
}

@end
