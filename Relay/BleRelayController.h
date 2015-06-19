//
//  BleRelayController.h
//  Relay
//
//  Created by Joël Gähwiler on 19.06.15.
//  Copyright (c) 2015 shiftr.io. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <LGBluetooth/LGBluetooth.h>
#import <CoreBluetooth/CoreBluetooth.h>

#import "CommonClient.h"

@interface BleRelayController : NSWindowController <CommonClientDelegate>

@property (weak) IBOutlet NSTextField *status;

@property (strong) LGPeripheral* peripheral;
@property (strong) CommonClient* client;

@end
