//
//  VideoRelayController.h
//  Volga
//
//  Created by Joël Gähwiler on 05.10.14.
//  Copyright (c) 2014 shiftr.io. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AVFoundation/AVFoundation.h>

@class AppDelegate;

@interface VideoRelayConfigurationController : NSViewController

@property (weak) IBOutlet NSPopUpButton *source;

- (IBAction)start:(id)sender;

@property (weak) AppDelegate *appDelegate;
@property (strong) NSMutableArray *createdRelays;

@end
