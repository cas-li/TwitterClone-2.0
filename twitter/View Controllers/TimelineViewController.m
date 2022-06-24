//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TimelineViewController.h"
#import "APIManager.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "Tweet.h"
#import "TweetCell.h"
#import "ComposeViewController.h"
#import "DetailsViewController.h"
#import "ProfileViewController.h"
#import "User.h"

@interface TimelineViewController () <ComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)didTapLogout:(id)sender;
@property (strong, nonatomic) NSMutableArray<Tweet *> *arrayOfTweets;
@property (nonatomic) BOOL isRefreshing;
- (IBAction)didTapCompose:(id)sender;

@property (assign, nonatomic) BOOL isMoreDataLoading;

@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    // Get timeline
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
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
    } maxId:nil];
    
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:refreshControl atIndex:0];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
     // Handle scroll behavior here
    if(!self.isMoreDataLoading){
        // Calculate the position of one screen length before the bottom of the results
        int scrollViewContentHeight = self.tableView.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.tableView.bounds.size.height;
        
        // When the user has scrolled past the threshold, start requesting
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.tableView.isDragging) {
            self.isMoreDataLoading = true;
            
            [self loadMoreData];
            
//            [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
//            [self.tableView insertSubview:refreshControl atIndex:-1];
        }
    }
}

// Makes a network request to get updated data
// Updates the tableView with the new data
// Hides the RefreshControl
- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            for (Tweet *tweet in tweets) {
                NSString *text = tweet.text;
                NSLog(@"%@", text);
            }
            self.arrayOfTweets = (NSMutableArray *)tweets;
            
            self.isMoreDataLoading = false;

            [self.tableView reloadData];
            
            [refreshControl endRefreshing];
            
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
    } maxId:nil];
}

- (void)loadMoreData {
    
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            for (Tweet *tweet in tweets) {
                NSString *text = tweet.text;
                NSLog(@"%@", text);
            }
            if (!self.arrayOfTweets) {
                self.arrayOfTweets = (NSMutableArray *)tweets.mutableCopy;
            } else {
                [self.arrayOfTweets addObjectsFromArray:tweets];
            }
            
            self.isMoreDataLoading = false;

            [self.tableView reloadData];
            
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
    } maxId:self.arrayOfTweets.lastObject.idStr];
  

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"composeSegue"]) {
        UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
        composeController.delegate = self;
    } else if ([segue.identifier isEqualToString:@"detailsSegue"]) {
        TweetCell *cell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        Tweet *dataToPass = self.arrayOfTweets[indexPath.row];
        
        DetailsViewController *detailsVC = [segue destinationViewController];
        detailsVC.tweet = dataToPass;
    } else if ([segue.identifier isEqualToString:@"profileSegue"]) {
        TweetCell *cell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        Tweet *passTweet = self.arrayOfTweets[indexPath.row];
        User *dataToPass = passTweet.user;
        
        ProfileViewController *profileVC = [segue destinationViewController];
        profileVC.user = dataToPass;
        
    }
    
}



- (IBAction)didTapLogout:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    [[APIManager shared] logout];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrayOfTweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath];

    cell.tweet = self.arrayOfTweets[indexPath.row];
    cell.delegate = self;

    return cell;
}

- (IBAction)didTapCompose:(id)sender {

}

- (void)didTweet:(Tweet *)tweet {
    [self.arrayOfTweets insertObject:tweet atIndex:0];
    [self.tableView reloadData];
}

- (void)tweetCell:(TweetCell *)tweetCell didTap:(User *)user{
    
    [self performSegueWithIdentifier:@"profileSegue" sender:user];
}

@end
