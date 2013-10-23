//
// Created by Felix Santiago on 10/19/13.
// Copyright (c) 2013 Felix Santiago. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "RestObject.h"


@interface Tweet : RestObject

@property (nonatomic, strong, readonly) NSString *text;
@property (nonatomic, strong, readonly) NSString *avatarURL;
@property (nonatomic, strong, readonly) NSString *authorName;
@property (nonatomic, strong, readonly) NSString *authorHandle;
@property (nonatomic, strong, readonly) NSDate *tweetTime;
@property (nonatomic, strong, readonly) NSString *tweetRelativeTime;
@property (nonatomic, strong, readonly) NSString *tweetId;
@property (nonatomic, readonly) int numRetweets;
@property (nonatomic, readonly) int numFavorites;
@property (nonatomic, readonly, getter=isFavorite) BOOL favorited;
@property (nonatomic, readonly, getter=isRetweeted) BOOL retweeted;
@property (nonatomic) int characterCount;
+ (NSMutableArray *)tweetsFromArray:(NSArray *)array;

- (BOOL)favorited;

+ (BOOL)isValidTweet:(Tweet *)tweet;

+ (Tweet *)buildTweetFromStatus:(NSString *)statusText;

+ (Tweet *)buildTweetFromResponse:(NSDictionary *)statusText;
@end