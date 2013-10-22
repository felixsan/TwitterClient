//
//  SignupViewController.m
//  TwitterClient
//
//  Created by Felix Santiago on 10/20/13.
//  Copyright (c) 2013 Felix Santiago. All rights reserved.
//

#import "SignupViewController.h"
#import "AFOAuth1Client.h"
#import "TwitterNetworkClient.h"
#import "User.h"


@interface SignupViewController ()

- (IBAction)authenticate:(id)sender;

@end

@implementation SignupViewController

# pragma mark - View Life Cycle Functions

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}


#pragma mark - Private methods

- (IBAction)authenticate:(id)sender {
    [[TwitterNetworkClient client] finishSetup:[NSURL URLWithString:@"fxo-twitter://success"]
                                       success:^(AFOAuth1Token *accessToken, id responseObject) {
        [[TwitterNetworkClient client] verifyLogin:^(AFHTTPRequestOperation *operation, id response) {
//            NSLog(@"response: %@", response);
            [User setCurrentUser:[[User alloc] initWithDictionary:response]];
        }
                                           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self onError];
        }];
        NSLog(@"Success!");
    } failure:^(NSError *error) {
        NSLog(@"could not login error %@", error);
        [self onError];
    }];
}

- (void)onError {
    [[[UIAlertView alloc] initWithTitle:@"Woops!" message:@"There was a problem loggin in with Twitter, please try again!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}


@end
