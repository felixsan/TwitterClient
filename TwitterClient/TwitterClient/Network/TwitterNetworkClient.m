//
// Created by Felix Santiago on 10/20/13.
// Copyright (c) 2013 Felix Santiago. All rights reserved.
//


#import "TwitterNetworkClient.h"
#import "AFNetworking.h"
#import "AFHTTPRequestOperation.h"

#define TWITTER_BASE_URL [NSURL URLWithString:@"https://api.twitter.com/"]
#define TWITTER_CONSUMER_KEY @"yi8Fw3QXXJf5ftT5WTuLww"
#define TWITTER_CONSUMER_SECRET @"jk4xd1Afq5X2E7jjuZ7qeBwoJUfSnFmoPjuJvABp5dg"
#define TWITTER_REQUEST_TOKEN_PATH @"oauth/request_token"
#define TWITTER_AUTHORIZE_PATH @"oauth/authorize"
#define TWITTER_ACCESS_TOKEN_PATH @"oauth/access_token"
#define TWITTER_VERIFY_CREDENTIALS_PATH @"1.1/account/verify_credentials.json"


static NSString * const TWAccessTokenKey = @"TWAccessToken";

@interface TwitterNetworkClient ()

- (void)setAccessToken:(AFOAuth1Token *)accessToken;

@end

@implementation TwitterNetworkClient


+ (TwitterNetworkClient *)client {
    static dispatch_once_t once;
    static TwitterNetworkClient *client;

    dispatch_once(&once, ^{
        client = [[TwitterNetworkClient alloc] initWithBaseURL:TWITTER_BASE_URL
                                                           key:TWITTER_CONSUMER_KEY
                                                        secret:TWITTER_CONSUMER_SECRET];
    });

    return client;
}

- (id)initWithBaseURL:(NSURL *)url key:(NSString *)key secret:(NSString *)secret {
    self = [super initWithBaseURL:TWITTER_BASE_URL key:TWITTER_CONSUMER_KEY secret:TWITTER_CONSUMER_SECRET];
    if (self != nil) {
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];

        NSData *data = [[NSUserDefaults standardUserDefaults] dataForKey:TWAccessTokenKey];
        if (data) {
            self.accessToken = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"signedup"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    NSLog(@"Access Token %@", self.accessToken);
    return self;
}


#pragma mark - Token Related Methods

- (void)finishSetup:(NSURL *)callbackUrl success:(void (^)(AFOAuth1Token *accessToken, id responseObject))success failure:(void (^)(NSError *error))failure {
    self.accessToken = nil;
    [super authorizeUsingOAuthWithRequestTokenPath:TWITTER_REQUEST_TOKEN_PATH
                             userAuthorizationPath:TWITTER_AUTHORIZE_PATH
                                       callbackURL:callbackUrl
                                   accessTokenPath:TWITTER_ACCESS_TOKEN_PATH
                                      accessMethod:@"POST"
                                             scope:nil
                                           success:success
                                           failure:failure];
}

- (void)verifyLogin:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    [self getPath:TWITTER_VERIFY_CREDENTIALS_PATH parameters:nil success:success failure:failure];
}

#pragma mark - Twitter Calls

- (void)getHomeTimelineTweetsWithCount:(int)count sinceId:(NSString *)sinceId maxId:(NSString *)maxId trimUser:(BOOL)trimUser excludeReplies:(BOOL)exludeReplies contributorDetails:(BOOL)contributorDetails includeEntities:(BOOL)includeEntities success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"count": @(count)}];
    if (![sinceId isEqualToString: @"0"]) {
        [params setObject:sinceId forKey:@"since_id"];
    }
    if (![maxId isEqualToString: @"0"]) {
        [params setObject:maxId forKey:@"max_id"];
    }
    [self getPath:@"1.1/statuses/home_timeline.json" parameters:params success:success failure:failure];
}

- (void)postUpdateWithStatus:(NSString *)text inReplyTo:(NSString *)tweetId success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"status": text}];
    if (tweetId != nil) {
        [params setObject:tweetId forKey:@"in_reply_to_status_id"];
    }
    [self postPath:@"1.1/statuses/update.json" parameters:params success:success failure:failure];
}

- (void)retweetStatusWithId:(NSString *)tweetId success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSString *retweetUrl = [NSString stringWithFormat:@"1.1/statuses/retweet/%@.json", tweetId];
    [self postPath:retweetUrl parameters:nil success:success failure:failure];
}

- (void)getUserProfileFromId:(int)profileId success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"user_id": [NSNumber numberWithInt:profileId]}];
    [self getPath:@"1.1/users/show.json" parameters:params success:success failure:failure];

}

- (void)getUserProfileFromScreenName:(NSString *)screenName success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"screen_name": screenName}];
    [self getPath:@"1.1/users/show.json" parameters:params success:success failure:failure];

}

- (void)setFavorite:(BOOL)newFavoriteStatus forTweetId:(NSString *)tweetId success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"id": tweetId}];
    NSString *path = newFavoriteStatus ? @"1.1/favorites/create.json" : @"1.1/favorites/destroy.json";
    [self postPath:path parameters:params success:success failure:failure];

}



#pragma mark - Private methods

- (void)setAccessToken:(AFOAuth1Token *)accessToken {
    [super setAccessToken:accessToken];

    if (accessToken) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:accessToken];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:TWAccessTokenKey];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:TWAccessTokenKey];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end