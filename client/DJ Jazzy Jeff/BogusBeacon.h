//
//  BogusBeacon.h
//  DJ Jazzy Jeff
//
//  Created by Joe Longstreet on 11/6/14.
//  Copyright (c) 2014 Joe Longstreet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface BogusBeacon : NSObject

- (id)init:(NSString *)channel :(NSString *)username;
- (void) startBroadcasting;
- (void) stopBroadcasting;

@property(readonly) CBUUID* channel;
@property(readonly) CBUUID* username;
@property(readonly) BOOL isBroadcasting;
@property(readonly) NSDictionary* advertisingData;

@end
