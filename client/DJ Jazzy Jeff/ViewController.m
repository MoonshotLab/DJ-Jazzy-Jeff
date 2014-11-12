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
#import "BogusBeacon.h"
#import "BogusBeaconService.h"

static NSString *WEB_SERVICE_URL = @"https://infinite-waters-6799.herokuapp.com";
//static NSString *WEB_SERVICE_URL = @"http://localhost:3000";

@interface ViewController () <UIPickerViewDataSource, UIPickerViewDelegate>
- (IBAction)saveButton:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *userNameView;
@property (weak, nonatomic) IBOutlet UIPickerView *songSelector;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIImageView *background;
@property NSString *userName;
@property NSString *selectedSongId;
@property NSString *webServiceURL;
@property NSMutableDictionary *songs;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchSongs];

    NSUserDefaults *userData = [NSUserDefaults standardUserDefaults];
    NSString *storedUserName = [userData objectForKey:@"userName"];

    if(![storedUserName length]){
        self.userName = [[NSUUID UUID] UUIDString];
        [userData setValue:self.userName forKey:@"userName"];
        [userData synchronize];
        [self registerUser:self.userName];
    } else {
        self.userName = storedUserName;
        [self showUserName];
    }
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIDeviceOrientationPortrait){
        self.beacon = [[BogusBeacon alloc] init:@"CB284D88-5317-4FB4-9621-C5A3A49E6155" : self.userName];
        [self.beacon startBroadcasting];
    } else {
        self.beaconService = [[BogusBeaconService alloc] init:@"CB284D88-5317-4FB4-9621-C5A3A49E6155"];
        [self.beaconService startDetecting];

        self.songSelector.hidden = YES;
        self.saveButton.hidden = YES;
        self.background.contentMode = UIViewContentModeScaleAspectFill;
    }
}

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSArray *songIds = [self.songs objectForKey:@"ids"];
    self.selectedSongId = songIds[row];
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [[self.songs objectForKey:@"ids"] count];
}

- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSArray *songNames = [self.songs objectForKey:@"names"];
    return songNames[row];
}

- (IBAction)saveButton:(id)sender {
    NSString *postString = [NSString stringWithFormat:@"username=%@&songId=%@", self.userName, self.selectedSongId];
    NSData *postData = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/user/update", WEB_SERVICE_URL]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    long statusCode = [response statusCode];
    
    NSString *userMessage = @"Could not save :(";

    if(statusCode == 200)
        userMessage = @"Saved!";

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:userMessage message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

- (void) showUserName {
    NSMutableString *userNameText = [NSMutableString string];
    [userNameText appendString:@"username: "];
    [userNameText appendString:self.userName];
    self.userNameView.text = userNameText;
}

- (void)registerUser:(NSString *)userName {
    NSString *postString = [NSString stringWithFormat:@"username=%@", userName];
    NSData *postData = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/user/create", WEB_SERVICE_URL]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    [self showUserName];
}

-(void)fetchSongs {
    NSString *route = [NSString stringWithFormat:@"%@/songs", WEB_SERVICE_URL];
    NSURL *url = [NSURL URLWithString:route];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *songData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:songData options:NSJSONReadingMutableContainers error:&error];

    NSMutableArray *songNames = [[NSMutableArray alloc] initWithCapacity:jsonArray.count];
    NSMutableArray *songIds = [[NSMutableArray alloc] initWithCapacity:jsonArray.count];
    self.songs = [[NSMutableDictionary alloc] initWithCapacity:jsonArray.count];
    
    for(NSDictionary *item in jsonArray) {
        [songNames addObject: [item objectForKey:@"title"]];
        [songIds addObject: [item objectForKey:@"id"]];
    }
    
    [self.songs setObject:songNames forKey:@"names"];
    [self.songs setObject:songIds forKey:@"ids"];
}

@end
