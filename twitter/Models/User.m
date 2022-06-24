//
//  User.m
//  twitter
//
//  Created by Christina Li on 6/22/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "User.h"

@implementation User
- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];

    if (self) {
        self.name = dictionary[@"name"];
        self.screenName = dictionary[@"screen_name"];
        self.profilePicture = dictionary[@"profile_image_url_https"];

        self.followerCount = [dictionary[@"followers_count"] stringValue];
        self.followingCount = [dictionary[@"friends_count"] stringValue];
        
        self.userId = dictionary[@"id"];

    // Initialize any other properties
    }
    return self;
}
@end
