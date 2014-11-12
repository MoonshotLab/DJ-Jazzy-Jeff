//
//  ViewController.h
//  DJ Jazzy Jeff
//
//  Created by Joe Longstreet on 11/3/14.
//  Copyright (c) 2014 Joe Longstreet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BogusBeacon.h"
#import "BogusBeaconService.h"

@interface ViewController : UIViewController
@property BogusBeacon* beacon;
@property BogusBeaconService* beaconService;
@end

