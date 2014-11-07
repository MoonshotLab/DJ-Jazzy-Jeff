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

static BOOL DEBUG = NO;


@interface BogusBeacon() <CBPeripheralManagerDelegate>
@end


@implementation BogusBeacon
{
    CBPeripheralManager *peripheralManager;
}


- (id)init:(NSString *)channel :(NSString *)username {
    _channel = [CBUUID UUIDWithString:channel];
    _username = username;
    _advertisingData = @{CBAdvertisementDataLocalNameKey:username, CBAdvertisementDataServiceUUIDsKey:@[_channel]};
    
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(heartBeat) userInfo:nil repeats:YES];

    return self;
}

- (void) heartBeat{}


- (BOOL)canBroadcast{
    CBPeripheralManagerAuthorizationStatus status = [CBPeripheralManager authorizationStatus];
    
    BOOL enabled = (status == CBPeripheralManagerAuthorizationStatusAuthorized ||
                    status == CBPeripheralManagerAuthorizationStatusNotDetermined);
    
    // keeps the simlulator from crashing
    UIDevice *currentDevice = [UIDevice currentDevice];
    if([currentDevice.model containsString:@"Simulator"])
        enabled = NO;

    if(DEBUG && !(enabled))
        NSLog(@"bluetooth not authorized");
    
    return enabled;
}


- (void)startBroadcasting{
    if([self canBroadcast] && !peripheralManager){
        peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
        [peripheralManager startAdvertising:_advertisingData];
        
        NSString *log;
        switch (peripheralManager.state) {
            case CBPeripheralManagerStatePoweredOff:
                log = @"off";
                break;
            case CBPeripheralManagerStatePoweredOn:
                log = @"on";
                break;
            case CBPeripheralManagerStateResetting:
                log = @"resetting";
                break;
            case CBPeripheralManagerStateUnauthorized:
                log = @"unauthed";
                break;
            case CBPeripheralManagerStateUnknown:
                log = @"unknown";
                break;
            case CBPeripheralManagerStateUnsupported:
                log = @"unsupported";
                break;
            default:
                log = @"something else";
                break;
        }

        NSLog(@"%@", log);
    }
}


- (void)stopBroadcasting{
    *_isBroadcasting = YES;
    [peripheralManager stopAdvertising];
    peripheralManager = nil;
}


-(void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error{
    NSLog(@"has begun advertising");
}


- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral{
    if(DEBUG)
        NSLog(@"State changed: %ld", peripheral.state);
    
    if(peripheral.state == CBPeripheralManagerStatePoweredOn){
        [peripheralManager startAdvertising:_advertisingData];
        _isBroadcasting = YES;
    }
}

@end