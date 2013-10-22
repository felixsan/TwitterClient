//
// Created by Felix Santiago on 10/20/13.
// Copyright (c) 2013 Felix Santiago. All rights reserved.
//


#import "User.h"
#import "TwitterNetworkClient.h"

NSString * const UserDidLoginNotification = @"UserDidLoginNotification";
NSString * const UserDidLogoutNotification = @"UserDidLogoutNotification";
NSString * const kCurrentUserKey = @"kCurrentUserKey";

@implementation User

static User *_currentUser;

+ (User *)currentUser {
    if (!_currentUser) {
        NSData *userData = [[NSUserDefaults standardUserDefaults] dataForKey:kCurrentUserKey];
        if (userData) {
            NSDictionary *userDictionary = [NSJSONSerialization JSONObjectWithData:userData options:NSJSONReadingMutableContainers error:nil];
            _currentUser = [[User alloc] initWithDictionary:userDictionary];
        }
    }
    
    return _currentUser;
}

+ (void)setCurrentUser:(User *)currentUser {
    NSLog(@"Setting user");
    if (currentUser) {
        NSData *userData = [NSJSONSerialization dataWithJSONObject:currentUser.data options:NSJSONWritingPrettyPrinted error:nil];
        [[NSUserDefaults standardUserDefaults] setObject:userData forKey:kCurrentUserKey];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"signedup"];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kCurrentUserKey];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"signedup"];
        [TwitterNetworkClient client].accessToken = nil;
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"_currentUser - %@", _currentUser);
    NSLog(@"currentUser - %@", currentUser);
    if (!_currentUser && currentUser) {
        _currentUser = currentUser; // Needs to be set before firing the notification
        NSLog(@"Firing UserDidLoginNotification");
        [[NSNotificationCenter defaultCenter] postNotificationName:UserDidLoginNotification object:nil];
    } else if (_currentUser && !currentUser) {
        _currentUser = currentUser; // Needs to be set before firing the notification
        NSLog(@"Firing UserDidLogoutNotification");
        [[NSNotificationCenter defaultCenter] postNotificationName:UserDidLogoutNotification object:nil];
    }
}

@end
