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
@property (weak, nonatomic) IBOutlet UILabel *userNameView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSUserDefaults *userData = [NSUserDefaults standardUserDefaults];
    NSString *userName = [userData objectForKey:@"userName"];
    
    if(![userName length]){
        userName = [[NSUUID UUID] UUIDString];
        [userData setValue:userName forKey:@"userName"];
        [userData synchronize];
    }
    
    NSMutableString *usernameText = [NSMutableString string];
    [usernameText appendString:@"username :"];
    [usernameText appendString:userName];
    self.userNameView.text = usernameText;
    
    INBeaconService *beaconService = [[INBeaconService alloc] initWithIdentifier:@"CB284D88-5317-4FB4-9621-C5A3A49E6155"];

    [beaconService setUserName:userName];
    [beaconService addDelegate:self];
    [beaconService startBroadcasting];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
