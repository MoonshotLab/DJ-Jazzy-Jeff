//
//  BogusBeacon.m
//  DJ Jazzy Jeff
//
//  Created by Joe Longstreet on 11/6/14.
//  Copyright (c) 2014 Joe Longstreet. All rights reserved.
//

#import "BogusBeacon.h"
#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

static BOOL DEBUG = YES;


@interface BogusBeacon() <CBPeripheralManagerDelegate>
@end


@implementation BogusBeacon
{
    CBPeripheralManager *peripheralManager;
}


- (id)init:(NSString *)channel :(NSString *)username {
    _channel  = [CBUUID UUIDWithString:channel];
    _username = [CBUUID UUIDWithString:username];
    _advertisingData = @{CBAdvertisementDataServiceUUIDsKey:@[_username, _channel]};

    return self;
}


- (BOOL)canBroadcast{
    CBPeripheralManagerAuthorizationStatus status = [CBPeripheralManager authorizationStatus];
    
    BOOL enabled = (status == CBPeripheralManagerAuthorizationStatusAuthorized ||
                    status == CBPeripheralManagerAuthorizationStatusNotDetermined);
    
    // keeps the simlulator from crashing
    UIDevice *currentDevice = [UIDevice currentDevice];
    if([currentDevice.model containsString:@"Simulator"])
        enabled = NO;

    if(DEBUG && !(enabled))
        NSLog(@"bluetooth not authorized or does not exist");
    
    return enabled;
}


- (void)startBroadcasting{
    if([self canBroadcast] && !peripheralManager)
        peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
}


- (void)stopBroadcasting{
    _isBroadcasting = YES;
    [peripheralManager stopAdvertising];
    peripheralManager = nil;
}


-(void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error{
    if (DEBUG)
        NSLog(@"advertising peripheral...");
}


- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral{
    if(peripheral.state == CBPeripheralManagerStatePoweredOn){
        [peripheralManager startAdvertising:_advertisingData];
        _isBroadcasting = YES;
    }
}

@end