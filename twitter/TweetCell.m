//
//  TweetCell.m
//  twitter
//
//  Created by Christina Li on 6/22/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"

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
//    self.profilePicture.image = ;
    self.name.text = tweet.user.name;
    self.username.text = tweet.user.screenName;
    self.date.text = tweet.createdAtString;
    self.tweetContent.text = tweet.text;
    
    self.profilePicture.image = nil;
    NSString *URLString = tweet.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    self.profilePicture.image = [UIImage imageWithData: urlData];
    
//    self.replyButton.titleLabel.text =
    self.retweetButton.titleLabel.text = [NSString stringWithFormat:@"%d",tweet.retweetCount];
//
//    NSLog(self.retweetButton.titleLabel.text);
    self.likesButton.titleLabel.text = [NSString stringWithFormat:@"%d",tweet.favoriteCount];
    
    
    
    
    
}

@end
