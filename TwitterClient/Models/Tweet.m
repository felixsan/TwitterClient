//
// Created by Felix Santiago on 10/19/13.
// Copyright (c) 2013 Felix Santiago. All rights reserved.
//


#import "Tweet.h"
#import "NSDictionary+CPAdditions.h"


@implementation Tweet

+ (NSMutableArray *)tweetsFromArray:(NSArray *)array {
    NSMutableArray *tweets = [[NSMutableArray alloc] initWithCapacity:array.count];
    for (NSDictionary *params in array) {
        [tweets addObject:[[Tweet alloc] initWithDictionary:params]];
    }
    return tweets;
}

- (NSString *)text {
    return [self.data valueOrNilForKeyPath:@"text"];
}


- (NSString *)tweetId {
    return ([self valueOrNilForKeyPath:@"id_str"]) ? [self valueOrNilForKeyPath:@"id_str"] : @"";
}

- (NSString *)authorHandle {
    return ([self valueOrNilForKeyPath:@"user.screen_name"]) ? [self valueOrNilForKeyPath:@"user.screen_name"] : @"";
}

- (NSString *)authorName {
    return ([self valueOrNilForKeyPath:@"user.name"]) ? [self valueOrNilForKeyPath:@"user.name"] : @"";
}

- (NSString *)avatarURL {
    return ([self valueOrNilForKeyPath:@"user.profile_image_url"]) ? [self valueOrNilForKeyPath:@"user.profile_image_url"] : @"";
}

- (NSString *)tweetTime {
    return ([self valueOrNilForKeyPath:@"created_at"]) ? [self valueOrNilForKeyPath:@"created_at"] : @"";
}

- (NSString *)tweetRelativeTime {
    return [Tweet returnRelativeTime:self.tweetTime];
}

- (int) characterCount {
    //TODO Calculate the links in the character count
    return [self.text length];
}

+(NSString *)returnRelativeTime:(NSString *)dateString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"eee MMM dd HH:mm:ss ZZZZ yyyy"];
    NSDate *date = [formatter dateFromString:dateString];
    int timeSince = [date timeIntervalSinceNow] * -1;

    int days    = (timeSince / (3600 * 24));
    int hours   = (timeSince / 3600)- (days *24);
    int minutes = (timeSince % 3600) / 60;
    int seconds = (timeSince % 60);

    if (days > 0) {
        return [NSString stringWithFormat:@"%01dd",days];
    }
    else if (hours == 0) {
        if (minutes > 0) {
            return [NSString stringWithFormat:@"%01dm", minutes];
        } else{
            return [NSString stringWithFormat:@"%01ds", seconds];
        }
    }
    else {
        return [NSString stringWithFormat:@"%01dh", hours];
    }

}

+ (BOOL)isValidTweet:(Tweet *)tweet {
    return tweet.characterCount <= 140;
}

+ (Tweet *)buildTweetFromStatus:(NSString *)statusText{
    return [[Tweet alloc] initWithDictionary:@{@"text": statusText}];
}



@end