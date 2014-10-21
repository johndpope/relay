//
//  VideoConfigurationController.h
//  Relay
//
//  Created by Joël Gähwiler on 05.10.14.
//  Copyright (c) 2014 shiftr.io. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AVFoundation/AVFoundation.h>

@class AppDelegate;

@interface VideoConfigurationController : NSViewController

@property (weak) IBOutlet NSPopUpButton *source;
@property (weak) IBOutlet NSTextField *baseTopic;

- (IBAction)start:(id)sender;
- (IBAction)test:(id)sender;

@property (weak) AppDelegate *appDelegate;
@property (strong) NSMutableArray *createdRelays;
@property NSNumber *framerate;
@property NSNumber *quality;

@end
