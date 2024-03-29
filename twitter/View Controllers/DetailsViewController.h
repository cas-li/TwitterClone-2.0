//
//  DetailsViewController.h
//  twitter
//
//  Created by Christina Li on 6/23/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailsViewController : UIViewController
@property (strong, nonatomic) Tweet *tweet;
@end

NS_ASSUME_NONNULL_END
