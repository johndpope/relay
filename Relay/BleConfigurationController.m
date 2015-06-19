//
//  BleConfigurationController.m
//  Relay
//
//  Created by Joël Gähwiler on 19.06.15.
//  Copyright (c) 2015 shiftr.io. All rights reserved.
//

#import "BleConfigurationController.h"

#import "AppDelegate.h"
#import "BleRelayController.h"

@implementation BleConfigurationController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.createdRelays = [NSMutableArray array];
  self.foundPeripherals = [NSMutableArray array];
  
  [self.source removeAllItems];
  
  [[LGCentralManager sharedInstance] scanForPeripheralsByInterval:4 completion:^(NSArray *peripherals) {
    if (peripherals.count > 0) {
      for(LGPeripheral* p in peripherals) {
        [self.source addItemWithTitle:p.name];
        [self.foundPeripherals addObject:p];
      }
    }
  }];
}

- (IBAction)start:(id)sender
{
  LGPeripheral *source;

  if(self.source.selectedItem) {
    source = [self.foundPeripherals objectAtIndex:self.source.indexOfSelectedItem];
  }

  BleRelayController *controller = [[BleRelayController alloc] initWithWindowNibName:@"BleRelay"];
  
  CommonClient *client = [[CommonClient alloc] init];
  client.uri = [NSURL URLWithString:self.appDelegate.namespaceURI];
  client.baseTopic = self.baseTopic.stringValue.copy;

  controller.peripheral = source;
  controller.client = client;
  [controller showWindow:self];
  
  [self.createdRelays addObject:controller];
}

@end
