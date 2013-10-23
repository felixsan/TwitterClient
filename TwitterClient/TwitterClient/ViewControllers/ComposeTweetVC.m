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
        self.statusText.delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.inReplyTo) {
        self.statusText.text = [[NSString alloc] initWithFormat:@"@%@ ", self.inReplyTo];
    }
    [self.statusText becomeFirstResponder];
    // Do any additional setup after loading the view.
}

- (IBAction)dismissView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)postUpdate:(id)sender {
    // Get text from text view
    Tweet *newStatus = [Tweet buildTweetFromStatus:self.statusText.text];
    if ([Tweet isValidTweet:newStatus]) {
        NSLog(@"Tweet was valid! - %d", newStatus.characterCount);        
        [[TwitterNetworkClient client] postUpdateWithStatus:newStatus.text
                                                  inReplyTo:self.replyTweetId
                                                    success:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"%@", response);
        [self.view endEditing:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
                                                    }
                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"ERROR - %@", error);
        [self onError];
                }];
    } else {
        // Come up with an error stating that it is too long and the calculated length
        NSLog(@"Status is too long - %d", newStatus.characterCount);
    }
}

- (void)onError {
    [[[UIAlertView alloc] initWithTitle:@"Woops!" message:@"There was a publishing your tweet, please try again!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

@end
