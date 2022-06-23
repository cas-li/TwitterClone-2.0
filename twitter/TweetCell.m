//
//  TweetCell.m
//  twitter
//
//  Created by Christina Li on 6/22/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "APIManager.h"
#import "DateTools.h"

@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setTweet:(Tweet *)tweet{
    _tweet = tweet;

    [self refreshData];

}

- (IBAction)didTapFavorite:(id)sender {

//    NSLog(@"%d", self.tweet.favorited);
    if (self.tweet.favorited == NO) {
        self.tweet.favorited = YES;
//        NSLog(@"%d", self.tweet.favorited);
        self.tweet.favoriteCount += 1;
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
            }
        }];
    }
    else {
        self.tweet.favorited = NO;
        self.tweet.favoriteCount -= 1;
        [[APIManager shared] unfavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error unfavoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully unfavorited the following Tweet: %@", tweet.text);
            }
        }];
    }
    [self refreshData];
}

- (IBAction)didTapRetweet:(id)sender {
//    NSLog(@"%d", self.tweet.retweeted);
    if (self.tweet.retweeted == NO) {
        self.tweet.retweeted = YES;
//        NSLog(@"%d", self.tweet.favorited);
        self.tweet.retweetCount += 1;
        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully retweeted the following Tweet: %@", tweet.text);
            }
        }];
    }
    else {
        self.tweet.retweeted = NO;
//        NSLog(@"%d", self.tweet.retweeted);
        self.tweet.retweetCount -= 1;
        [[APIManager shared] unretweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error unretweeting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully unretweeted the following Tweet: %@", tweet.text);
            }
        }];
    }
    [self refreshData];
}


-(void)refreshData {
    
    self.name.text = self.tweet.user.name;
    
    NSString *at = @"@";
    self.username.text = [NSString stringWithFormat:@"%@%@", at, self.tweet.user.screenName];

    self.date.text = self.tweet.createdAtDate.shortTimeAgoSinceNow;
    
    self.tweetContent.text = self.tweet.text;
    
    self.profilePicture.image = nil;
    NSString *URLString = self.tweet.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    self.profilePicture.image = [UIImage imageWithData: urlData];
    
    [self.retweetButton setTitle:[NSString stringWithFormat:@"%d",self.tweet.retweetCount] forState:UIControlStateNormal];

    [self.likesButton setTitle:[NSString stringWithFormat:@"%d",self.tweet.favoriteCount] forState:UIControlStateNormal];
    
    if (self.tweet.favorited == YES) {
        [self.likesButton setImage:[UIImage imageNamed:@"favor-icon-red.png"] forState:UIControlStateNormal];
    }
    else {
        [self.likesButton setImage:[UIImage imageNamed:@"favor-icon.png"] forState:UIControlStateNormal];
    }
    
    if (self.tweet.retweeted == YES) {
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon-green.png"] forState:UIControlStateNormal];
    }
    else {
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon.png"] forState:UIControlStateNormal];
    }
}

@end
