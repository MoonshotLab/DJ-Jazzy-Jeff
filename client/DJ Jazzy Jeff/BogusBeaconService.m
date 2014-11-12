//
//  BogusBeaconService.m
//  DJ Jazzy Jeff
//
//  Created by Joe Longstreet on 11/6/14.
//  Copyright (c) 2014 Joe Longstreet. All rights reserved.
//

#import "BogusBeaconService.h"
#import <CoreBluetooth/CoreBluetooth.h>

static BOOL DEBUG = YES;


@interface BogusBeaconService() <CBCentralManagerDelegate>
@end


@implementation BogusBeaconService
{
    CBCentralManager *manager;
}


- (id)init:(NSString *)channel {
    _trackedBeacons = [[NSMutableDictionary alloc] init];
    _channel = [CBUUID UUIDWithString:channel];
    return self;
}


- (void) startDetecting{
    _isDetecting = YES;

    if(!manager){
        manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
        if(DEBUG)
            NSLog(@"manager created");
    }
}


- (void) stopDetecting{
    manager = nil;
    _isDetecting = NO;
}


- (void) heartBeat{}


- (MSDetectorRange)convertRSSItoINProximity:(float)proximity
{
    if (proximity < -70)
        return MSDetectorRangeFar;
    if (proximity < -55)
        return MSDetectorRangeNear;
    if (proximity < 0)
        return MSDetectorRangeImmediate;
    
    return MSDetectorRangeUnknown;
}


-(NSString*)getProximityString:(MSDetectorRange)range
{
    NSString *proximityString;
    
    switch (range) {
        case MSDetectorRangeFar:
            proximityString = @"far";
            break;
        case MSDetectorRangeImmediate:
            proximityString = @"immediate";
            break;
        case MSDetectorRangeNear:
            proximityString = @"near";
            break;
        case MSDetectorRangeUnknown:
            proximityString = @"unknown";
            break;
        default:
            break;
    }

    return proximityString;
}


- (void) centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    MSDetectorRange proximity = [self convertRSSItoINProximity:[RSSI floatValue]];
    NSString *proximityString = [self getProximityString:proximity];
    
    CBUUID *uuid = [advertisementData[CBAdvertisementDataServiceUUIDsKey] firstObject];
    
    if(uuid){
        NSString *key = uuid.UUIDString;
        NSMutableDictionary *beacon = [_trackedBeacons objectForKey:key];
        
        if(DEBUG)
            NSLog(@"Tracking || %@ || %@ || %@", key, proximityString, RSSI);
        
        if(!beacon){
            NSMutableDictionary *beacon = [NSMutableDictionary new];
            [beacon setObject:[NSNumber numberWithInt:proximity] forKey:@"lastProximity"];
            [_trackedBeacons setObject:beacon forKey:key];
        }
    }
}


- (void) centralManagerDidUpdateState:(CBCentralManager *)central{
    if (central.state == CBCentralManagerStatePoweredOn)
        [manager scanForPeripheralsWithServices:@[_channel] options:@{CBCentralManagerScanOptionAllowDuplicatesKey:@(YES)}];
}


@end