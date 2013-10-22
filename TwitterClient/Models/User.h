//
// Created by Felix Santiago on 10/20/13.
// Copyright (c) 2013 Felix Santiago. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "RestObject.h"

extern NSString *const UserDidLoginNotification;
extern NSString *const UserDidLogoutNotification;

@interface User : RestObject

+ (User *)currentUser;
+ (void)setCurrentUser:(User *)currentUser;

@end
