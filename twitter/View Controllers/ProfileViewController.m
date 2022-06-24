//
//  ProfileViewController.m
//  twitter
//
//  Created by Christina Li on 6/24/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "ProfileViewController.h"
#import "TweetCell.h"
#import "Tweet.h"
#import "APIManager.h"
#import "User.h"

@interface ProfileViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *followingCount;
@property (weak, nonatomic) IBOutlet UILabel *followerCount;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray<Tweet *> *arrayOfTweets;
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [[APIManager shared] getUserTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            for (Tweet *tweet in tweets) {
                NSString *text = tweet.text;
                NSLog(@"%@", text);
            }
            self.arrayOfTweets = (NSMutableArray *)tweets;
//            self.tableView.rowHeight = UITableViewAutomaticDimension;
            [self.tableView reloadData];
            

        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
    } userId:self.user.userId];
    
    
    self.name.text = self.user.name;
    
    NSString *at = @"@";
    self.username.text = [NSString stringWithFormat:@"%@%@", at, self.user.screenName];
    
    self.profilePicture.image = nil;
    NSString *URLString = self.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    self.profilePicture.image = [UIImage imageWithData: urlData];
    
    self.followingCount.text = self.user.followingCount;
    self.followerCount.text = self.user.followerCount;
    
//    self.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrayOfTweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath];

    cell.tweet = self.arrayOfTweets[indexPath.row];
//    cell.delegate = self;

    return cell;
}

@end
