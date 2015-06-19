//
//  AppDelegate.m
//  Relay
//
//  Created by Joël Gähwiler on 24.09.14.
//  Copyright (c) 2014 shiftr.io. All rights reserved.
//

#import "AppDelegate.h"

#import "MidiConfigurationController.h"
#import "VideoConfigurationController.h"
#import "OscConfigurationController.h"
#import "BleConfigurationController.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
  self.midiConfigurationController = [[MidiConfigurationController alloc] initWithNibName:@"MidiConfiguration" bundle:nil];
  self.midiConfigurationController.appDelegate = self;
  self.videoConfigurationController = [[VideoConfigurationController alloc] initWithNibName:@"VideoConfiguration" bundle:nil];
  self.videoConfigurationController.appDelegate = self;
  self.oscConfigurationController = [[OscConfigurationController alloc] initWithNibName:@"OscConfiguration" bundle:nil];
  self.oscConfigurationController.appDelegate = self;
  self.bleConfigurationController = [[BleConfigurationController alloc] initWithNibName:@"BleConfiguration" bundle:nil];
  self.bleConfigurationController.appDelegate = self;
  
  [self.tabView addTabViewItem:[self createTab:@"MIDI" withController:self.midiConfigurationController]];
  [self.tabView addTabViewItem:[self createTab:@"Video" withController:self.videoConfigurationController]];
  [self.tabView addTabViewItem:[self createTab:@"OSC" withController:self.oscConfigurationController]];
  [self.tabView addTabViewItem:[self createTab:@"BLE" withController:self.bleConfigurationController]];
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
