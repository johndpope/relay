//
//  BleConfigurationController.h
//  Relay
//
//  Created by Joël Gähwiler on 19.06.15.
//  Copyright (c) 2015 shiftr.io. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <LGBluetooth/LGBluetooth.h>

@class AppDelegate;

@interface BleConfigurationController : NSViewController

@property (weak) IBOutlet NSPopUpButton *source;
@property (weak) IBOutlet NSTextField *baseTopic;

- (IBAction)start:(id)sender;

@property (strong) NSMutableArray *createdRelays;

@end
