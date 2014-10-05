//
//  VideoRelaytest.h
//  Volga
//
//  Created by Joël Gähwiler on 05.10.14.
//  Copyright (c) 2014 shiftr.io. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <MQTTKit/MQTTKit.h>

@interface VideoRelayTestController : NSWindowController <NSWindowDelegate>

@property (weak) IBOutlet NSTextField *status;
@property (weak) IBOutlet NSImageView *preview;

@property (strong) NSURL* uri;
@property (strong) NSString* topic;

@end
