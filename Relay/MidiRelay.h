//
//  MidiRelay.h
//  Relay
//
//  Created by Joël Gähwiler on 24.09.14.
//  Copyright (c) 2014 shiftr.io. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MQTTKit.h>
#import <MIKMIDI.h>

@interface MidiRelay : NSObject

@property (strong) NSURL *namespaceUri;
@property (strong) MQTTClient *client;
@property (strong) MIKMIDISourceEndpoint *source;
@property (strong) MIKMIDIDestinationEndpoint *destination;

- (void)setup:(NSString*)namespaceURI andSource:(MIKMIDISourceEndpoint*)source andDestination:(MIKMIDIDestinationEndpoint*)destination;

@end
