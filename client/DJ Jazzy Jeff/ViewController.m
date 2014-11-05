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

@interface ViewController () <INBeaconServiceDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *userNameView;
@property (weak, nonatomic) IBOutlet UIPickerView *songSelector;
@property NSString *userName;
@property NSArray *songNames;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _songNames = [NSArray arrayWithObjects: @"Total Eclipse of the Heart", @"I believe in a thing called love", @"Never gonna give you up", nil];

    NSUserDefaults *userData = [NSUserDefaults standardUserDefaults];
    NSString *storedUserName = [userData objectForKey:@"userName"];
    
    if(![storedUserName length]){
        _userName = [[NSUUID UUID] UUIDString];
        [userData setValue:_userName forKey:@"userName"];
        [userData synchronize];
        
        [self registerUser:_userName];
    } else {
        _userName = storedUserName;
        [self showUserName];
    }
    
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

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
	return _songNames.count;
}

- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return _songNames[row];
}

- (void) showUserName {
    NSMutableString *userNameText = [NSMutableString string];
    [userNameText appendString:@"username: "];
    [userNameText appendString:_userName];
    _userNameView.text = userNameText;
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
