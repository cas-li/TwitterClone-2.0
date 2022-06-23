//
//  ComposeViewController.m
//  twitter
//
//  Created by Christina Li on 6/23/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"
#import "APIManager.h"

@interface ComposeViewController ()
@property (weak, nonatomic) IBOutlet UITextView *composeTweet;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)didTweet:(id)sender {
    [[APIManager shared] postStatusWithText:self.composeTweet.text completion:^(Tweet *tweet, NSError *error) {
        if (tweet) {
            NSLog(@"Compose tweet success");
            [self.delegate didTweet:tweet];
            [self dismissViewControllerAnimated:true completion:nil];

        } else {
            NSLog(@"😫😫😫 Error posting tweet: %@", error.localizedDescription);
        }
    }];
}

- (IBAction)didClose:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

@end
