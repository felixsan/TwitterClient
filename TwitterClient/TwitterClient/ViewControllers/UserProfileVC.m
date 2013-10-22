//
//  UserProfileVC.m
//  TwitterClient
//
//  Created by Felix Santiago on 10/19/13.
//  Copyright (c) 2013 Felix Santiago. All rights reserved.
//

#import "UserProfileVC.h"
#import "UIColor+TwitterClient.h"

@interface UserProfileVC ()

@end

@implementation UserProfileVC

- (void)viewDidLoad
{
    [super viewDidLoad];


    // Change the Nav Bar color on both iOS 6 and 7
    SEL selector =  NSSelectorFromString(@"setBarTintColor:");
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    if ([self.navigationController.navigationBar respondsToSelector:selector])
    {
        self.navigationController.navigationBar.barTintColor = [UIColor TwitterBlueColor];
    } else {
        self.navigationController.navigationBar.tintColor = [UIColor TwitterBlueColor];
    }

//    self.navigationItem.titleView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"TwitterTitleDark"]];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
