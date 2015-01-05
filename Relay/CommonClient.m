//
//  CommonClient.m
//  Relay
//
//  Created by Joël Gähwiler on 06.10.14.
//  Copyright (c) 2014 shiftr.io. All rights reserved.
//

#import "CommonClient.h"

@implementation CommonMessage

- (NSString *)payloadString
{
  return self.message.payloadString;
}

- (NSData *)payloadData
{
  return self.message.payload;
}

@end

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
    self.formatter.allowedUnits = NSByteCountFormatterUseAll;
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
  return [NSString stringWithFormat:@"Relay/%@", [[NSUUID UUID] UUIDString]];
}

- (void)connect
{
  self.state = @"Connecting";

  self.client = [[MQTTClient alloc] initWithClientId:self.clientID];
  self.client.username = self.uri.user;
  self.client.password = self.uri.password;
  
  __weak typeof(self) _self = self;

  [self.client setMessageHandler:^(MQTTMessage *_message) {
    dispatch_sync(dispatch_get_main_queue(), ^{
      _self.transferedMessages++;
      _self.transferedBytes += _message.payload.length;
      _self.lastMessageSize = _message.payload.length;
      [_self.messageSizes addObject:[NSNumber numberWithInteger:_message.payload.length]];
      CommonMessage *message = [[CommonMessage alloc] init];
      message.message = _message;
      message.topic = [_message.topic stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@/", _self.baseTopic] withString:@""];
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

  self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(calculate) userInfo:nil repeats:YES];
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

- (void)publish:(NSString *)topic andStringPayload:(NSString *)payload
{
  [self publish:topic andPayload:[payload dataUsingEncoding:NSUTF8StringEncoding]];
}

- (void)subscribe:(NSString *)topic
{
  NSString *_topic = [NSString stringWithFormat:@"%@/%@", self.baseTopic, topic];
  NSLog(@"sub: %@", _topic);
  [self.client subscribe:_topic withCompletionHandler:nil];
}

- (void)disconnect
{
  [self.client disconnectWithCompletionHandler:nil];
}

- (NSString *)info
{
  return [NSString stringWithFormat:@"[%@] Count: %ld - Last: %@ - All: %@ - Avg: %@/s",
    self.state,
    self.transferedMessages,
    [self.formatter stringFromByteCount:self.lastMessageSize],
    [self.formatter stringFromByteCount:self.transferedBytes],
    [self.formatter stringFromByteCount:self.averageTransfer]
  ];
}

@end
