//
//  BogusBeaconService.h
//  DJ Jazzy Jeff
//
//  Created by Joe Longstreet on 11/6/14.
//  Copyright (c) 2014 Joe Longstreet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

typedef enum {
    MSDetectorRangeUnknown,
    MSDetectorRangeFar,
    MSDetectorRangeNear,
    MSDetectorRangeImmediate
} MSDetectorRange;

@interface BogusBeaconService : NSObject

- (id)init:(NSString *)channel;
- (void) startDetecting;
- (void) stopDetecting;

@property(readonly) CBUUID* channel;
@property (readonly) BOOL isDetecting;
@property (readonly) NSMutableDictionary* trackedBeacons;

@end
