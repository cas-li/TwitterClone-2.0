//
//  TweetCell.m
//  twitter
//
//  Created by Christina Li on 6/22/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "APIManager.h"

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

//    self.name.text = tweet.user.name;
//
//    NSString *at = @"@";
//    self.username.text = [NSString stringWithFormat:@"%@%@", at, tweet.user.screenName];
//    self.date.text = tweet.createdAtString;
//    self.tweetContent.text = tweet.text;
//
//    self.profilePicture.image = nil;
//    NSString *URLString = tweet.user.profilePicture;
//    NSURL *url = [NSURL URLWithString:URLString];
//    NSData *urlData = [NSData dataWithContentsOfURL:url];
//    self.profilePicture.image = [UIImage imageWithData: urlData];
//
//    self.retweetButton.titleLabel.text = [NSString stringWithFormat:@"%d",tweet.retweetCount];
//
//    self.likesButton.titleLabel.text = [NSString stringWithFormat:@"%d",tweet.favoriteCount];
}

- (IBAction)didTapFavorite:(id)sender {

    NSLog(@"%d", self.tweet.favorited);
    if (self.tweet.favorited == NO) {
        self.tweet.favorited = YES;
        NSLog(@"%d", self.tweet.favorited);
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

-(void)refreshData{
    
    self.name.text = self.tweet.user.name;
    
    NSString *at = @"@";
    self.username.text = [NSString stringWithFormat:@"%@%@", at, self.tweet.user.screenName];
    self.date.text = self.tweet.createdAtString;
    self.tweetContent.text = self.tweet.text;
    
    self.profilePicture.image = nil;
    NSString *URLString = self.tweet.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    self.profilePicture.image = [UIImage imageWithData: urlData];
    
    self.retweetButton.titleLabel.text = [NSString stringWithFormat:@"%d",self.tweet.retweetCount];

    self.likesButton.titleLabel.text = [NSString stringWithFormat:@"%d",self.tweet.favoriteCount];
    
    if (self.tweet.favorited == YES) {
        [self.likesButton setImage:[UIImage imageNamed:@"favor-icon-red.png"] forState:UIControlStateNormal];
    }
    else {
        [self.likesButton setImage:[UIImage imageNamed:@"favor-icon.png"] forState:UIControlStateNormal];
    }
}

@end
