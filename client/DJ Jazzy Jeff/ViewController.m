//
//  ViewController.m
//  DJ Jazzy Jeff
//
//  Created by Joe Longstreet on 11/3/14.
//  Copyright (c) 2014 Joe Longstreet. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import "ViewController.h"
#import "INBeaconService.h"

@interface ViewController () <INBeaconServiceDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[INBeaconService singleton] addDelegate:self];
    [[INBeaconService singleton] startBroadcasting];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
