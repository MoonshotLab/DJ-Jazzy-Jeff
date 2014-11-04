//
//  ViewController.m
//  DJ Jazzy Jeff
//
//  Created by Joe Longstreet on 11/3/14.
//  Copyright (c) 2014 Joe Longstreet. All rights reserved.
//

#import <MessageUI/MessageUI.h>
#import <CoreGraphics/CoreGraphics.h>
#import "ViewController.h"
#import "INBeaconService.h"

@interface ViewController () <INBeaconServiceDelegate, MFMailComposeViewControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    INBeaconService *beaconService = [[INBeaconService alloc] initWithIdentifier:@"CB284D88-5317-4FB4-9621-C5A3A49E6155"];
    NSString *userName = [[NSUUID UUID] UUIDString];
    [beaconService setUserName:userName];
    [beaconService addDelegate:self];
    [beaconService startBroadcasting];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
