//
// Created by Felix Santiago on 10/20/13.
// Copyright (c) 2013 Felix Santiago. All rights reserved.
//


#import "AFOAuth1Client.h"
#import "Tweet.h"
#import "Profile.h"

@class AFHTTPRequestOperation;


@interface TwitterNetworkClient : AFOAuth1Client

+ (TwitterNetworkClient *)client;

- (id)initWithBaseURL:(NSURL *)url key:(NSString *)key secret:(NSString *)secret;
- (void)finishSetup:(NSURL *)callbackUrl success:(void (^)(AFOAuth1Token *accessToken, id responseObject))success failure:(void (^)(NSError *error))failure;
- (void)verifyLogin:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (void)getHomeTimelineTweetsWithCount:(int)count sinceId:(NSString *)sinceId maxId:(NSString *)maxId trimUser:(BOOL)trimUser excludeReplies:(BOOL)exludeReplies contributorDetails:(BOOL)contributorDetails includeEntities:(BOOL)includeEntities success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (void)postUpdateWithStatus:(NSString *)text inReplyTo:(NSString *)tweetId success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (void)retweetStatusWithId:(NSString *)tweetId success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (void)setFavorite:(BOOL)newFavoriteStatus forTweetId:(NSString *)tweetId success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (void)getUserProfileFromId:(int)profileId success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (void)getUserProfileFromScreenName:(NSString *)screenName success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end