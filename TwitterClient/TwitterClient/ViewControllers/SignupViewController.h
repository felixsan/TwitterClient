//
//  SignupViewController.h
//  TwitterClient
//
//  Created by Felix Santiago on 10/20/13.
//  Copyright (c) 2013 Felix Santiago. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignupViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;

@end
