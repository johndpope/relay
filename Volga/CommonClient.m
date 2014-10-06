//
//  Client.m
//  Volga
//
//  Created by Joël Gähwiler on 06.10.14.
//  Copyright (c) 2014 shiftr.io. All rights reserved.
//

#import "CommonClient.h"

@interface CommonClient ()
@property (strong) MQTTClient *client;
@property (strong) NSByteCountFormatter *formatter;
@property (strong) NSTimer *timer;
@property NSInteger transferedMessages;
@property NSInteger transferedBytes;
@property NSInteger lastMessageSize;
@property (strong) NSString *state;
@property NSMutableArray *messageSizes;
@property NSInteger averageTransfer;
@end

@implementation CommonClient

- (id)init
{
  if(self = [super init]) {
    self.formatter = [[NSByteCountFormatter alloc] init];
    self.transferedMessages = 0;
    self.transferedBytes = 0;
    self.lastMessageSize = 0;
    self.state = @"Disconnected";
    self.messageSizes = [NSMutableArray array];
  }
  return self;
}

- (NSString*)clientID
{
  return [NSString stringWithFormat:@"Volga/%@", [[NSUUID UUID] UUIDString]];
}

- (void)connect
{
  self.state = @"Connecting";

  self.client = [[MQTTClient alloc] initWithClientId:self.clientID];
  self.client.username = self.uri.user;
  self.client.password = self.uri.password;
  
  __weak typeof(self) _self = self;

  [self.client setMessageHandler:^(MQTTMessage *message) {
    dispatch_sync(dispatch_get_main_queue(), ^{
      _self.transferedMessages++;
      _self.transferedBytes += message.payload.length;
      _self.lastMessageSize = message.payload.length;
      [_self.messageSizes addObject:[NSNumber numberWithInteger:message.payload.length]];
      [_self.delegate didReceiveMessage:message];
    });
  }];
  
  [self.client connectToHost:self.uri.host completionHandler:^(MQTTConnectionReturnCode code) {
    if(code != ConnectionAccepted) {
      NSLog(@"connection refused");
      dispatch_sync(dispatch_get_main_queue(), ^{
        _self.state = @"Failed";
      });
    } else {
      NSLog(@"connection accepted");
      dispatch_sync(dispatch_get_main_queue(), ^{
        _self.state = @"Connected";
        [_self.delegate clientDidConnect];
      });
    }
  }];

  self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(calculate) userInfo:nil repeats:YES];
}

- (void)calculate
{
  if(self.messageSizes.count > 0) {
    NSInteger total = 0;

    for (NSNumber *num in self.messageSizes) {
      total += num.integerValue;
    }
  
    self.averageTransfer = total / self.messageSizes.count;
    
    self.messageSizes = [NSMutableArray array];
  } else {
    self.averageTransfer = 0;
  }
}

- (void)publish:(NSString *)topic andPayload:(NSData *)payload
{
  self.transferedMessages++;
  self.transferedBytes += payload.length;
  self.lastMessageSize = payload.length;
  [self.messageSizes addObject:[NSNumber numberWithInteger:payload.length]];
  
  [self.client publishData:payload toTopic:[NSString stringWithFormat:@"%@/%@", self.baseTopic, topic] withQos:AtMostOnce retain:NO completionHandler:nil];
}

- (void)subscribe:(NSString *)topic
{
  [self.client subscribe:[NSString stringWithFormat:@"%@/%@", self.baseTopic, topic] withCompletionHandler:nil];
}

- (void)disconnect
{
  [self.client disconnectWithCompletionHandler:nil];
}

- (NSString *)info
{
  return [NSString stringWithFormat:@"[%@] LM: %@ - TM: %ld - TB: %@ - AS: %@/s",
    self.state,
    [self.formatter stringFromByteCount:self.lastMessageSize],
    self.transferedMessages,
    [self.formatter stringFromByteCount:self.transferedBytes],
    [self.formatter stringFromByteCount:self.averageTransfer]
  ];
}

@end
