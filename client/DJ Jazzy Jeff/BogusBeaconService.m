//
//  BogusBeaconService.m
//  DJ Jazzy Jeff
//
//  Created by Joe Longstreet on 11/6/14.
//  Copyright (c) 2014 Joe Longstreet. All rights reserved.
//

#import "BogusBeaconService.h"
#import <CoreBluetooth/CoreBluetooth.h>

static BOOL DEBUG = NO;


@interface BogusBeaconService() <CBCentralManagerDelegate>
@end


@implementation BogusBeaconService
{
    CBCentralManager *manager;
    NSTimer *timer;
}


- (id)init:(NSString *)channel {
    _channel = [CBUUID UUIDWithString:channel];
    return self;
}


- (void) startDetecting{
    _isDetecting = YES;

    if(!manager){
        manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(reportUpdates) userInfo:nil repeats:YES];
        NSLog(@"manager created");
    }
}


- (void) stopDetecting{
    manager = nil;
    *_isDetecting = NO;
    
    [timer invalidate];
}


- (void) reportUpdates{}


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

    if (DEBUG)
        NSLog(@"Beacon %@ at Proximity %@ Distance %@", uuid, proximityString, RSSI);
}


- (void) centralManagerDidUpdateState:(CBCentralManager *)central{
    if (central.state == CBCentralManagerStatePoweredOn)
        [manager scanForPeripheralsWithServices:@[_channel] options:@{CBCentralManagerScanOptionAllowDuplicatesKey:@(YES)}];
}


@end