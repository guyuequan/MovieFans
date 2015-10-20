//
//  ReviewCell.h
//  MovieFans
//
//  Created by Leo Gao on 15/9/13.
//  Copyright (c) 2015年 LeoCode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Review.h"

@interface ReviewCell : UITableViewCell

@property (nonatomic,strong) Review *review;

@property (nonatomic,strong) TLabel *titleLabel;
@property (nonatomic,strong) TLabel *abstractLabel;

+ (CGFloat)heightWithTitle:(NSString *)title;
@end
