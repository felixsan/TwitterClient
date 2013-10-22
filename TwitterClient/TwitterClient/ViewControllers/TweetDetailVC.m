//
//  TweetDetailVC.m
//  TwitterClient
//
//  Created by Felix Santiago on 10/20/13.
//  Copyright (c) 2013 Felix Santiago. All rights reserved.
//

#import "TweetDetailVC.h"

@interface TweetDetailVC ()

- (IBAction)returnToHomeTimeline:(id)sender;
@end

@implementation TweetDetailVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)returnToHomeTimeline:(id)sender {
    NSLog(@"POP THE VIEW");
    [self.navigationController popViewControllerAnimated:YES];
}

@end
