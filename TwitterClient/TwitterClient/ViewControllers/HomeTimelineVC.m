//
//  HomeTimelineVC.m
//  TwitterClient
//
//  Created by Felix Santiago on 10/19/13.
//  Copyright (c) 2013 Felix Santiago. All rights reserved.
//

#import "HomeTimelineVC.h"
#import "SignupViewController.h"
#import "UIColor+TwitterClient.h"
#import "TwitterNetworkClient.h"
#import "UIImageView+AFNetworking.h"
#import "TweetCell.h"
#import "User.h"

@interface HomeTimelineVC ()

@property (strong, nonatomic) NSMutableArray *tweets;

- (void)getNewTweets;
- (void)getOlderTweets;
- (IBAction)logout:(id)sender;

@end

@implementation HomeTimelineVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"Before NSUserDefaults");
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"signedup"]) {
        NSLog(@"No signedup NSUserDefaults");

        // Show the signup view since we don't have credentials yet
        SignupViewController *svc = [[SignupViewController alloc] init];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:svc];

        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self presentViewController:navController animated:YES completion:nil];
        });
    } else {
        NSLog(@"Yes signedup NSUserDefaults");

        // Change the Nav Bar color on both iOS 6 and 7
        SEL selector =  NSSelectorFromString(@"setBarTintColor:");
        self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
        if ([self.navigationController.navigationBar respondsToSelector:selector])
        {
            self.navigationController.navigationBar.barTintColor = [UIColor TwitterBlueColor];
        } else {
            self.navigationController.navigationBar.tintColor = [UIColor TwitterBlueColor];
        }

        self.navigationItem.titleView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"TwitterTitleDark"]];

        UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
        [refreshControl addTarget:self action:@selector(getNewTweets) forControlEvents:UIControlEventValueChanged];
        self.refreshControl = refreshControl;

        [self loadInitialTweets];
    }

	// Do any additional setup after loading the view, typically from a nib.
}


- (void)composeTweet {

}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.tweets count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath];

    // Configure the cell...
    Tweet *tweet = self.tweets[indexPath.row];

    cell.tweetText.text = tweet.text;
    cell.authorName.text = tweet.authorName;
    cell.authorHandle.text = [NSString stringWithFormat:@"@%@", tweet.authorHandle];
    NSLog(@"Tweet Time- %@", tweet.tweetTime);
    NSLog(@"Tweet Relative Time- %@", tweet.tweetRelativeTime);
    cell.tweetTime.text = tweet.tweetRelativeTime;
    [cell.avatar setImageWithURL:[NSURL URLWithString:tweet.avatarURL] placeholderImage:[UIImage imageNamed:@"TwitterTitleDark"]];

    // Set rounded corners
    CALayer * l = [cell.avatar layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:3.0];

    NSLog(@"Tweet - %@", cell.tweetText.text);
    NSLog(@"Author - %@", cell.authorName.text);
//    NSLog(@"Tweet - %@", tweet);
    return cell;
}

//heightforrow

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    CGPoint offset = aScrollView.contentOffset;
    CGRect bounds = aScrollView.bounds;
    CGSize size = aScrollView.contentSize;
    UIEdgeInsets inset = aScrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    // NSLog(@"offset: %f", offset.y);
    // NSLog(@"content.height: %f", size.height);
    // NSLog(@"bounds.height: %f", bounds.size.height);
    // NSLog(@"inset.top: %f", inset.top);
    // NSLog(@"inset.bottom: %f", inset.bottom);
    // NSLog(@"pos: %f of %f", y, h);

    float reload_distance = 10;
    if(y > h + reload_distance) {
        if ([self.tweets count] > 0) {
//            [self getOlderTweets];
            NSLog(@"Reached Bottom");
        }
    }
}


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


- (void)getNewTweets {
    NSString *sinceID = [self.tweets count] > 0 ? [[self.tweets objectAtIndex:0] tweetId] : @"0";
    [[TwitterNetworkClient client] getHomeTimelineTweetsWithCount:20
                                                          sinceId:sinceID
                                                            maxId:@"0"
                                                         trimUser:NO
                                                   excludeReplies:NO
                                               contributorDetails:NO
                                                  includeEntities:NO
            success:^(AFHTTPRequestOperation *operation, id response) {
//        NSLog(@"%@", response);
        NSMutableArray *newTweets = [Tweet tweetsFromArray:response];
        [newTweets addObjectsFromArray:self.tweets];
        self.tweets = newTweets;
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
    }                                                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"ERROR - %@", error);
    }];
}

- (void)getOlderTweets {
    NSString *maxID = [self.tweets count] > 0 ? [[self.tweets lastObject] tweetId] : @"0";
    [[TwitterNetworkClient client] getHomeTimelineTweetsWithCount:20
                                                          sinceId:@"0"
                                                            maxId:maxID
                                                         trimUser:NO
                                                   excludeReplies:NO
                                               contributorDetails:NO
                                                  includeEntities:NO
                                                          success:^(AFHTTPRequestOperation *operation, id response) {
//        NSLog(@"%@", response);
        NSMutableArray *oldTweets = [Tweet tweetsFromArray:response];
        [self.tweets addObjectsFromArray:oldTweets];
        [self.tableView reloadData];
        }
                                                          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"ERROR - %@", error);
    }];
}


- (void)loadInitialTweets {
    NSLog(@"LOADING INITIAL TWEETS" );
    [[TwitterNetworkClient client] getHomeTimelineTweetsWithCount:20
                                                          sinceId:@"0"
                                                            maxId:@"0"
                                                         trimUser:NO
                                                   excludeReplies:NO
                                               contributorDetails:NO
                                                  includeEntities:NO
                                                          success:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"%@", response);
        self.tweets = [Tweet tweetsFromArray:response];
        [self.tableView reloadData];
        NSLog(@"%d", [self.tweets count]);
          NSLog(@"Scrolls to top - %d", self.tableView.scrollsToTop);
    }                                                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"ERROR - %@", error);
    }];
}

- (IBAction)logout:(id)sender {
    NSLog(@"Hit logout");
    [User setCurrentUser:nil];
    SignupViewController *svc = [[SignupViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:svc];
    [self presentViewController:navController animated:YES completion:nil];

}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 0;
//    sizeWithFont forWidth
//    return height plus a static offset
//}

@end
