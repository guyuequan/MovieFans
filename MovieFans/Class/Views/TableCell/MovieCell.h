//
//  MovieCell.h
//  MovieFans
//
//  Created by Leo Gao on 15/9/7.
//  Copyright (c) 2015年 LeoCode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieSimple.h"

@interface MovieCell : UITableViewCell

@property (nonatomic,strong) UIImageView *coverIV;
@property (nonatomic,strong) TLabel *nameLbl;
@property (nonatomic,strong) TLabel *categoryLbl;
@property (nonatomic,strong) TLabel *yearLbl;
@property (nonatomic,strong) TLabel *ratingValueLbl;

+ (CGFloat)HeightOfCell;
- (void)setDataModel:(MovieSimple*)model;
@end
