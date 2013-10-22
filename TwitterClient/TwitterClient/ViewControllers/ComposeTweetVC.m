//
//  ComposeTweetVC.m
//  TwitterClient
//
//  Created by Felix Santiago on 10/21/13.
//  Copyright (c) 2013 Felix Santiago. All rights reserved.
//

#import "ComposeTweetVC.h"
#import "TwitterNetworkClient.h"

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

- (IBAction)dismissView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)postUpdate:(id)sender {
    // Get text from text view
    Tweet *newStatus = [Tweet buildTweetFromStatus:self.statusText];
    if ([Tweet isValidTweet:newStatus]) {
        [[TwitterNetworkClient client] postUpdateWithStatus:newStatus.text
                                                    success:nil
                                                    failure:nil];
    } else {
        // Come up with an error stating that it is too long and the calculated length
        NSLog(@"Status is too long - %d", newStatus.characterCount);
    }


}
@end
