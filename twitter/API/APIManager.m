//
//  APIManager.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "APIManager.h"
#import "Tweet.h"

static NSString * const baseURLString = @"https://api.twitter.com";

@interface APIManager()

@end

@implementation APIManager

+ (instancetype)shared {
    static APIManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (instancetype)init {
    
    NSURL *baseURL = [NSURL URLWithString:baseURLString];
    
    // TODO: fix code below to pull API Keys from your new Keys.plist file
    
    NSString *path = [[NSBundle mainBundle] pathForResource: @"Keys" ofType: @"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];

    NSString *key = [dict objectForKey: @"consumer_Key"];
    NSString *secret = [dict objectForKey: @"consumer_Secret"];
    
    // Check for launch arguments override
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-key"]) {
        key = [[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-key"];
    }
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-secret"]) {
        secret = [[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-secret"];
    }
    
    self = [super initWithBaseURL:baseURL consumerKey:key consumerSecret:secret];
    if (self) {
        
    }
    return self;
}

- (void)getUserTimelineWithCompletion:(void(^)(NSArray *tweets, NSError *error))completion userId:(NSString *)userId {
    NSMutableDictionary *parameters = @{@"tweet_mode":@"extended", @"user_id":userId}.mutableCopy;
    
    [self GET:@"1.1/statuses/user_timeline.json"
       parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSArray *  _Nullable tweetDictionaries) {
           // Success
           NSMutableArray *tweets = [Tweet tweetsWithArray:tweetDictionaries];
           completion(tweets, nil);
       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           // There was a problem
           completion(nil, error);
    }];
}

- (void)getHomeTimelineWithCompletion:(void(^)(NSArray *tweets, NSError *error))completion maxId:(NSString *_Nullable)maxId {
    NSMutableDictionary *parameters = @{@"tweet_mode":@"extended"}.mutableCopy;
    
    if (maxId) {
        parameters[@"max_id"] = maxId;
    }
    
    [self GET:@"1.1/statuses/home_timeline.json"
       parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSArray *  _Nullable tweetDictionaries) {
           // Success
           NSMutableArray *tweets = [Tweet tweetsWithArray:tweetDictionaries];
           completion(tweets, nil);
       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           // There was a problem
           completion(nil, error);
    }];
}

- (void)makePostRequestWithUrlString:(NSString *)urlString parameters:(NSDictionary *)parameters completion:(void (^)(Tweet *, NSError *))completion {
    [self POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionary) {
        Tweet *tweet = [[Tweet alloc]initWithDictionary:tweetDictionary];
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

- (void)postStatusWithText:(NSString *)text completion:(void (^)(Tweet *, NSError *))completion {
    NSString *urlString = @"1.1/statuses/update.json";
    NSDictionary *parameters = @{@"status": text};
    [self makePostRequestWithUrlString:urlString parameters:parameters completion:completion];
}

- (void)favorite:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion {

    NSString *urlString = @"1.1/favorites/create.json";
    NSDictionary *parameters = @{@"id": tweet.idStr};
    [self makePostRequestWithUrlString:urlString parameters:parameters completion:completion];
}

- (void)unfavorite:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion {

    NSString *urlString = @"1.1/favorites/destroy.json";
    NSDictionary *parameters = @{@"id": tweet.idStr};
    [self makePostRequestWithUrlString:urlString parameters:parameters completion:completion];
}

- (void)retweet:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion {

    NSString *urlWithoutID = @"1.1/statuses/retweet/";
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@", urlWithoutID, tweet.idStr, @".json"];
    NSLog(@"%@", urlString);
    NSDictionary *parameters = @{@"id": tweet.idStr};
    [self makePostRequestWithUrlString:urlString parameters:parameters completion:completion];
}

- (void)unretweet:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion {

    NSString *urlWithoutID = @"1.1/statuses/unretweet/";
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@", urlWithoutID, tweet.idStr, @".json"];
    NSDictionary *parameters = @{@"id": tweet.idStr};
    [self makePostRequestWithUrlString:urlString parameters:parameters completion:completion];
}

@end
