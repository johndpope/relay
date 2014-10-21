//
//  OscRelayStatusController.h
//  Relay
//
//  Created by Joël Gähwiler on 05.10.14.
//  Copyright (c) 2014 shiftr.io. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <OSCKit/OSCKit.h>

#import "CommonClient.h"

@interface OscRelayController : NSWindowController <CommonClientDelegate, OSCServerDelegate>

@property (weak) IBOutlet NSTextField *status;
@property (weak) IBOutlet NSTextField *lastOut;
@property (weak) IBOutlet NSTextField *lastIn;

@property (strong) CommonClient* client;
@property NSInteger input;
@property NSInteger output;

@end
