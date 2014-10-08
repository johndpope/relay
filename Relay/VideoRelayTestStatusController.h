//
//  VideoRelaytest.h
//  Relay
//
//  Created by Joël Gähwiler on 05.10.14.
//  Copyright (c) 2014 shiftr.io. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "CommonClient.h"

@interface VideoRelayTestStatusController : NSWindowController <NSWindowDelegate, CommonClientDelegate>

@property (weak) IBOutlet NSImageView *preview;
@property (weak) IBOutlet NSTextField *status;

@property (strong) CommonClient* client;

@end
