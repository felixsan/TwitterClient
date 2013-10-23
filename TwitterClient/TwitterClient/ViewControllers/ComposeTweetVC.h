//
//  ComposeTweetVC.h
//  TwitterClient
//
//  Created by Felix Santiago on 10/21/13.
//  Copyright (c) 2013 Felix Santiago. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ComposeTweetVC : UIViewController <UITextViewDelegate>

@property(nonatomic, strong) NSString *inReplyTo;
@property(nonatomic, copy) NSString *replyTweetId;
@property(nonatomic, weak) IBOutlet UITextView *statusText;

- (IBAction)postUpdate:(id)sender;

@end
