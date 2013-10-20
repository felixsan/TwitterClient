//
//  TCHomeViewController.m
//  TwitterClient
//
//  Created by Felix Santiago on 10/19/13.
//  Copyright (c) 2013 Felix Santiago. All rights reserved.
//

#import "TCHomeViewController.h"
#import "SignupViewController.h"

@interface TCHomeViewController ()

@end

@implementation TCHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"Before NSUserDefaults");
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"signedup"]) {
        NSLog(@"No signedup NSUserDefaults");
        BOOL addedCredentials = NO;
        // Show the signup view since we don't have credentials yet
        SignupViewController *svc = [[SignupViewController alloc] init];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:svc];

        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self presentViewController:navController animated:YES completion:^{

            if (addedCredentials) {
                // Save the fact we now have credentials on the app
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"signedup"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }


            }];
        });


    } else {
        NSLog(@"Yes signedup NSUserDefaults");
    }

	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
