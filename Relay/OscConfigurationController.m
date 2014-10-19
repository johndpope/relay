//
//  OscConfigurationController.m
//  Relay
//
//  Created by Joël Gähwiler on 19.10.14.
//  Copyright (c) 2014 shiftr.io. All rights reserved.
//

#import "OscConfigurationController.h"

#import "CommonClient.h"
#import "OscRelayController.h"

@implementation OscConfigurationController

- (void)loadView
{
  [super loadView];
  
  self.createdRelays = [NSMutableArray array];
}

- (IBAction)start:(id)sender
{
  NSInteger input = 0;
  NSInteger output = 0;

  if(![self.input.stringValue isEqualToString:@"skip"]) {
    input = self.input.integerValue;
  }
  
  if(![self.output.stringValue isEqualToString:@"skip"]) {
    output = self.output.integerValue;
  }
  
  if(input == 0 && output == 0) {
    [[NSAlert alertWithMessageText:@"Couldn't start Relay!" defaultButton:@"OK" alternateButton:@"" otherButton:@"" informativeTextWithFormat:@"Either a input or output port is needed."] runModal];
  } else {
    CommonClient *client = [[CommonClient alloc] init];
    client.uri = [NSURL URLWithString:self.appDelegate.namespaceURI];
    client.baseTopic = self.baseTopic.stringValue.copy;
    
    OscRelayController* controller = [[OscRelayController alloc] initWithWindowNibName:@"OscRelay"];
    controller.client = client;
    controller.input = input;
    controller.output = output;
    [controller showWindow:self];
    
    [self.createdRelays addObject:controller];
  }
}

@end
