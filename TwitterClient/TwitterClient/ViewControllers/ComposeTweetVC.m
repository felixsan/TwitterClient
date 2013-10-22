//
//  ComposeTweetVC.m
//  TwitterClient
//
//  Created by Felix Santiago on 10/21/13.
//  Copyright (c) 2013 Felix Santiago. All rights reserved.
//

#import "ComposeTweetVC.h"

@interface ComposeTweetVC ()
- (IBAction)dismissView:(id)sender;

@end

@implementation ComposeTweetVC

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

- (IBAction)dismissView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
