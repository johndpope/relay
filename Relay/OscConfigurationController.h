//
//  OscConfigurationController.h
//  Relay
//
//  Created by Joël Gähwiler on 19.10.14.
//  Copyright (c) 2014 shiftr.io. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "AppDelegate.h"

@interface OscConfigurationController : NSViewController

@property (weak) IBOutlet NSTextField *input;
@property (weak) IBOutlet NSTextField *output;
@property (weak) IBOutlet NSTextField *baseTopic;

- (IBAction)start:(id)sender;

@property (weak) AppDelegate *appDelegate;
@property (strong) NSMutableArray *createdRelays;

@end
