//
//  BleConfigurationController.m
//  Relay
//
//  Created by Joël Gähwiler on 19.06.15.
//  Copyright (c) 2015 shiftr.io. All rights reserved.
//

#import "BleConfigurationController.h"

#import "AppDelegate.h"

@implementation BleConfigurationController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.createdRelays = [NSMutableArray array];
  
  [self.source removeAllItems];
  
  [[LGCentralManager sharedInstance] scanForPeripheralsByInterval:4 completion:^(NSArray *peripherals) {
    if (peripherals.count > 0) {
      for(LGPeripheral* p in peripherals) {
        [self.source addItemWithTitle:p.name];
      }
    }
  }];
}

- (IBAction)start:(id)sender
{
  
}

@end
