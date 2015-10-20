//
//  CelebrityViewController.h
//  MovieFans
//
//  Created by Leo Gao on 15/9/18.
//  Copyright © 2015年 LeoCode. All rights reserved.
//

#import "BaseViewController.h"
@class Celebrity;

@interface CelebrityViewController : BaseViewController

- (instancetype)initWithCelebrity:(Celebrity*)celebrity;

@property (nonatomic,copy) NSString *celebrityId;
@property (nonatomic,weak) UINavigationController *fatherNavController;
@end
