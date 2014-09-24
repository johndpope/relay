//
//  AppDelegate.h
//  Volga
//
//  Created by Joël Gähwiler on 24.09.14.
//  Copyright (c) 2014 shiftr.io. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (weak) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTextField *uriTextField;
@property (weak) IBOutlet NSTextField *statusLabel;

- (IBAction)startMidiRelay:(id)sender;

@end
