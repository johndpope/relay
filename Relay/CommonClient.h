//
//  CommonClient.h
//  Relay
//
//  Created by Joël Gähwiler on 06.10.14.
//  Copyright (c) 2014 shiftr.io. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MQTTKit.h>

@interface CommonMessage : NSObject

@property (strong) MQTTMessage *message;
@property (strong) NSString *topic;

- (NSData*)payloadData;
- (NSString*)payloadString;

@end

@protocol CommonClientDelegate <NSObject>

- (void)clientDidConnect;
- (void)didReceiveMessage:(CommonMessage*)message;

@end

@interface CommonClient : NSObject

@property (strong) id <CommonClientDelegate> delegate;
@property (strong) NSURL* uri;
@property (strong) NSString* baseTopic;

- (void)connect;
- (void)subscribe:(NSString*)topic;
- (void)publish:(NSString*)topic andPayload:(NSData*)payload;
- (void)publish:(NSString*)topic andStringPayload:(NSString*)payload;
- (void)disconnect;
- (NSString*)info;

@end
