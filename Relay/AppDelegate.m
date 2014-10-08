//
//  AppDelegate.m
//  Relay
//
//  Created by Joël Gähwiler on 24.09.14.
//  Copyright (c) 2014 shiftr.io. All rights reserved.
//

#import "AppDelegate.h"

#import "MidiRelayConfigurationController.h"
#import "VideoRelayConfigurationController.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  self.midiRelayController = [[MidiRelayConfigurationController alloc]
                              initWithNibName:@"MidiRelayConfiguration" bundle:nil];
  self.midiRelayController.appDelegate = self;
  self.videoRelayController = [[VideoRelayConfigurationController alloc]
                               initWithNibName:@"VideoRelayConfiguration" bundle:nil];
  self.videoRelayController.appDelegate = self;
  
  [self.tabView addTabViewItem:[self createTab:@"MIDI" withController:self.midiRelayController]];
  [self.tabView addTabViewItem:[self createTab:@"Video" withController:self.videoRelayController]];
  
  // TODO: Get rid of that hack:
  [self.tabView selectLastTabViewItem:self];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {}

- (NSTabViewItem*)createTab:(NSString*)label withController:(NSViewController*)controller
{
  NSTabViewItem *item = [[NSTabViewItem alloc] initWithIdentifier:nil];
  [item setLabel:label];
  [item setView:controller.view];
  return item;
}

- (NSString *)namespaceURI
{
  return self.uriTextField.stringValue;
}

@end
