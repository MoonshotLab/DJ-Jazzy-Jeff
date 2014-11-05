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
@property NSString *userName;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSUserDefaults *userData = [NSUserDefaults standardUserDefaults];
    NSString *storedUserName = [userData objectForKey:@"userName"];
    
    if(![storedUserName length]){
        _userName = [[NSUUID UUID] UUIDString];
        [userData setValue:_userName forKey:@"userName"];
        [userData synchronize];
        
        [self registerUser:_userName];
    } else
        [self showUserName];
    
    INBeaconService *beaconService = [[INBeaconService alloc] initWithIdentifier:@"CB284D88-5317-4FB4-9621-C5A3A49E6155"];

    [beaconService setUserName:_userName];
    [beaconService addDelegate:self];
    [beaconService startBroadcasting];
}

- (void)connection:(NSURLConnection *) connection didReceiveData:(NSData *)data{
    [self showUserName];
}

- (void)connection:(NSURLConnection *) connection didFailWithError:(NSError *)error{
    NSLog(error);
}

- (void) showUserName {
    NSMutableString *userNameText = [NSMutableString string];
    [userNameText appendString:@"username :"];
    [userNameText appendString:_userName];
}

- (BOOL)registerUser:(NSString *)userName {
    
    NSString *postString = [NSString stringWithFormat:@"username=%@", @"username"];
    NSData *postData = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *request = [NSMutableURLRequest alloc];

    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://localhost:3000/user/create"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if(urlConnection)
        NSLog(@"Connection Made");
    else
        NSLog(@"Connection failed");
    
    return true;
}

@end
