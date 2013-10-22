//
//  TCAppDelegate.m
//  TwitterClient
//
//  Created by Felix Santiago on 10/19/13.
//  Copyright (c) 2013 Felix Santiago. All rights reserved.
//

#import "AFOAuth1Client.h"
#import "SignupViewController.h"
#import "TCAppDelegate.h"
#import "User.h"
#import "HomeTimelineVC.h"
#import "UIColor+TwitterClient.h"

@interface TCAppDelegate ()

@property (nonatomic, strong) SignupViewController *signupView;

- (void)dismissSignupView;
@end

@implementation TCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissSignupView) name:UserDidLoginNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showSignupView) name:UserDidLogoutNotification object:nil];
    return  YES;

}

- (void)showSignupView {
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:self.signupView];
    [self.window.rootViewController presentViewController:navController animated:YES completion:nil];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    NSNotification *notification = [NSNotification notificationWithName:kAFApplicationLaunchedWithURLNotification
                                                                 object:nil
                                                               userInfo:@{kAFApplicationLaunchOptionsURLKey: url}];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    [self dismissSignupView];
    return YES;
}

- (SignupViewController *)signupView {
    if (!_signupView) {
        _signupView = [[SignupViewController alloc] init];
    }
    return _signupView;

}

- (void)dismissSignupView {
    NSLog(@"Dismissing signup view");
    [(UITabBarController *) self.window.rootViewController setSelectedIndex:0];
    UINavigationController *navController = (UINavigationController *)[(UITabBarController *) self.window.rootViewController selectedViewController];
    HomeTimelineVC *timeLineVC = (HomeTimelineVC *)[navController topViewController];
    [timeLineVC loadInitialTweets];
    [[(UITabBarController *) self.window.rootViewController selectedViewController] dismissViewControllerAnimated:YES completion:nil];


    // Change the Nav Bar color on both iOS 6 and 7
    SEL selector =  NSSelectorFromString(@"setBarTintColor:");
    navController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    if ([navController.navigationBar respondsToSelector:selector])
    {
        navController.navigationBar.barTintColor = [UIColor TwitterBlueColor];
    } else {
        navController.navigationBar.tintColor = [UIColor TwitterBlueColor];
    }

    timeLineVC.navigationItem.titleView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"TwitterTitleDark"]];

    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:timeLineVC action:@selector(getNewTweets) forControlEvents:UIControlEventValueChanged];
    timeLineVC.refreshControl = refreshControl;


}

@end
