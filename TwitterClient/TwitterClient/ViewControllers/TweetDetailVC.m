//
//  TweetDetailVC.m
//  TwitterClient
//
//  Created by Felix Santiago on 10/20/13.
//  Copyright (c) 2013 Felix Santiago. All rights reserved.
//

#import "TweetDetailVC.h"
#import "UIImageView+AFNetworking.h"
#import "ComposeTweetVC.h"
#import "TwitterNetworkClient.h"

@interface TweetDetailVC ()

@property (weak, nonatomic) IBOutlet UILabel *authorName;
@property (weak, nonatomic) IBOutlet UILabel *authorHandle;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *tweetText;
@property (weak, nonatomic) IBOutlet UILabel *tweetDate;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UILabel *retweets;
@property (weak, nonatomic) IBOutlet UILabel *favorites;



- (IBAction)returnToHomeTimeline:(id)sender;
- (IBAction)retweet:(id)sender;
- (IBAction)favorite:(id)sender;

- (void)updateUIElements;
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
    [self updateUIElements];
}

- (IBAction)returnToHomeTimeline:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Reply"]){
        ComposeTweetVC *replyVc = [segue destinationViewController];
        replyVc.inReplyTo = self.tweet.authorHandle;
        replyVc.replyTweetId = self.tweet.tweetId;
    }
}

- (IBAction)retweet:(id)sender {
    [[TwitterNetworkClient client] retweetStatusWithId:self.tweet.tweetId
                                               success:^(AFHTTPRequestOperation *operation, id response) {
       NSLog(@"Response - %@", response);
       self.tweet = [Tweet buildTweetFromResponse:response];
       [self updateUIElements];
                                               }
                                               failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       NSLog(@"ERROR - %@", error);
       // TODO Actually parse the error message and display it to the user.
       [self errorWithMessage: @"There was an error retweeting this Tweet"];

                                               }];
}

- (IBAction)favorite:(id)sender {
    [[TwitterNetworkClient client] setFavorite:!self.tweet.isFavorite
                                    forTweetId:self.tweet.tweetId
                                       success:^(AFHTTPRequestOperation *operation, id response) {
       self.tweet = [Tweet buildTweetFromResponse:response];
       [self updateUIElements];
                                       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"ERROR - %@", error);
        // TODO Actually parse the error message and display it to the user.
        [self errorWithMessage: @"There was an error favoriting/unfavoriting this Tweet"];
    }];
}

- (void)errorWithMessage:(NSString *)errorMessage {
    [[[UIAlertView alloc] initWithTitle:@"Woops!" message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

- (void)updateUIElements {
    self.authorName.text = self.tweet.authorName;
    self.authorHandle.text = [NSString stringWithFormat:@"@%@", self.tweet.authorHandle];
    self.tweetText.text = self.tweet.text;
//    self.favorites.text = [NSString stringWithFormat:@"%d", self.tweet.numFavorites];
//    self.retweets.text = [NSString stringWithFormat:@"%d", self.tweet.numRetweets];

    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    self.tweetDate.text = [formatter stringFromDate:self.tweet.tweetTime];

    [self.avatar setImageWithURL:[NSURL URLWithString:self.tweet.avatarURL] placeholderImage:[UIImage imageNamed:@"TwitterTitleDark"]];

    NSString *buttonText = self.tweet.isFavorite ? @"☆ Unfavorite" : @"★ Favorite";
    [self.favoriteButton setTitle:buttonText forState:UIControlStateNormal];
    buttonText = self.tweet.isRetweeted ? @"Retweeted" : @"Retweet";
    [self.retweetButton setTitle:buttonText forState:UIControlStateNormal];
    // Set rounded corners
    CALayer * l = [self.avatar layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:3.0];
}

@end
