//
//  HomeTimelineVC.h
//  TwitterClient
//
//  Created by Felix Santiago on 10/19/13.
//  Copyright (c) 2013 Felix Santiago. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTimelineVC : UITableViewController <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>

- (void)loadInitialTweets;

@end
