//
//  ViewController.m
//  DJ Jazzy Jeff
//
//  Created by Joe Longstreet on 11/3/14.
//  Copyright (c) 2014 Joe Longstreet. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>
#import "ViewController.h"
#import "INBeaconService.h"

@interface ViewController () <INBeaconServiceDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *userNameView;
@property (weak, nonatomic) IBOutlet UIPickerView *songSelector;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property NSString *userName;
@property NSMutableDictionary *songs;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self fetchSongs];

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

- (int) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSArray *songIds = [_songs objectForKey:@"ids"];
    return songIds[row];
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [[_songs objectForKey:@"ids"] count];
}

- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSArray *songNames = [_songs objectForKey:@"names"];
    return songNames[row];
}

- (void) showUserName {
    NSMutableString *userNameText = [NSMutableString string];
    [userNameText appendString:@"username: "];
    [userNameText appendString:_userName];
    _userNameView.text = userNameText;
}

- (void)registerUser:(NSString *)userName {
    NSString *postString = [NSString stringWithFormat:@"username=%@", userName];
    NSData *postData = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://localhost:3000/user/create"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

-(void)fetchSongs {
    NSURL *url = [NSURL URLWithString:@"http://localhost:3000/songs"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *songData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:songData options:NSJSONReadingMutableContainers error:&error];

    NSMutableArray *songNames = [[NSMutableArray alloc] initWithCapacity:jsonArray.count];
    NSMutableArray *songIds = [[NSMutableArray alloc] initWithCapacity:jsonArray.count];
    _songs = [[NSMutableDictionary alloc] initWithCapacity:jsonArray.count];
    
    for(NSDictionary *item in jsonArray) {
        [songNames addObject: [item objectForKey:@"title"]];
        [songIds addObject: [item objectForKey:@"id"]];
    }
    
    [_songs setObject:songNames forKey:@"names"];
    [_songs setObject:songIds forKey:@"ids"];
}

@end
