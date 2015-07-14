//
//  AppDelegate.m
//  Relay
//
//  Created by Joël Gähwiler on 24.09.14.
//  Copyright (c) 2014 shiftr.io. All rights reserved.
//

#import "AppDelegate.h"

#import "MidiConfigurationController.h"
#import "OscConfigurationController.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
  self.midiConfigurationController = [[MidiConfigurationController alloc] initWithNibName:@"MidiConfiguration" bundle:nil];
  self.midiConfigurationController.appDelegate = self;
  self.oscConfigurationController = [[OscConfigurationController alloc] initWithNibName:@"OscConfiguration" bundle:nil];
  self.oscConfigurationController.appDelegate = self;
  
  [self.tabView addTabViewItem:[self createTab:@"MIDI" withController:self.midiConfigurationController]];
  [self.tabView addTabViewItem:[self createTab:@"OSC" withController:self.oscConfigurationController]];
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
