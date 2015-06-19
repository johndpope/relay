//
//  BleRelayController.m
//  Relay
//
//  Created by Joël Gähwiler on 19.06.15.
//  Copyright (c) 2015 shiftr.io. All rights reserved.
//

#import "BleRelayController.h"

@implementation BleRelayController

- (void)windowDidLoad
{
  [super windowDidLoad];
  
  self.status.stringValue = self.client.info;
  
  self.client.delegate = self;
  [self.client connect];
  
  BleRelayController *this = self;
  
  [self.peripheral connectWithCompletion:^(NSError *error) {
    [self.peripheral discoverServicesWithCompletion:^(NSArray *services, NSError *error) {
      for (LGService *service in services) {
        NSLog(@"service: %@", service.UUIDString);
      
        [service discoverCharacteristicsWithCompletion:^(NSArray *characteristics, NSError *error) {
          for (LGCharacteristic *charact in characteristics) {
          NSLog(@"characteristic: %@", charact.UUIDString);
          
          CBCharacteristic* c = charact.cbCharacteristic;
          
          if(c.properties & CBCharacteristicPropertyWrite) {
            NSLog(@"writable");
            [this.client subscribe:@"foo"];
          } else if(c.properties & CBCharacteristicPropertyRead) {
            NSLog(@"readable");
            [charact setNotifyValue:YES completion:^(NSError *error) {
              // complete
            } onUpdate:^(NSData *data, NSError *error) {
              [this.client publish:[NSString stringWithFormat:@"%@/%@", service.UUIDString, charact.UUIDString] andPayload:data];
            }];
          }
          }
        }];
      }
    }];
  }];
}

- (void)handleIncommingMessage:(CommonMessage*)message
{
//  NSArray *matches = [message.topic rx_matchesWithPattern:@"^in(.*)"];
//  if(matches.count == 1) {
//    NSString* address = [matches[0][1] text];
//    
//    self.lastIn.stringValue = [NSString stringWithFormat:@"%@: %@", address, message.payloadString];
//    
//    NSError *error;
//    NSArray *arguments = [NSJSONSerialization JSONObjectWithData:message.payloadData options:0 error:&error];
//    if(error) {
//      [[NSAlert alertWithError:error] runModal];
//    }
//    
//    OSCMessage *message = [OSCMessage to:address with:arguments];
//    [self.oscClient sendMessage:message to:self.target];
//  }
}

#pragma mark NSWindowDelegate

- (void)windowWillClose:(NSNotification *)notification
{
  [self.peripheral disconnectWithCompletion:^(NSError *error) {
    // complete
  }];
  [self.client disconnect];
}

#pragma mark CommonClientDelegate

- (void)clientDidConnect
{
  self.status.stringValue = self.client.info;
}

- (void)didReceiveMessage:(CommonMessage *)message
{
  [self handleIncommingMessage:message];
  self.status.stringValue = self.client.info;
}

@end
