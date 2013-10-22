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

@interface TweetDetailVC ()

@property (weak, nonatomic) IBOutlet UILabel *authorName;
@property (weak, nonatomic) IBOutlet UILabel *authorHandle;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *tweetText;
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
    self.authorName.text = self.tweet.authorName;
    self.authorHandle.text = self.tweet.authorHandle;
    self.tweetText.text = self.tweet.text;
    [self.avatar setImageWithURL:[NSURL URLWithString:self.tweet.avatarURL] placeholderImage:[UIImage imageNamed:@"TwitterTitleDark"]];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Reply"]){
        ComposeTweetVC *replyVc = [segue destinationViewController];
        replyVc.inReplyTo = self.authorHandle;
    }
}

@end
