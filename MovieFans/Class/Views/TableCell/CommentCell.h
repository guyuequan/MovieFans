//
//  CommentCell.h
//  MovieFans
//
//  Created by Leo Gao on 15/9/11.
//  Copyright (c) 2015年 LeoCode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comment.h"
#import "EDStarRating.h"

@interface CommentCell : UITableViewCell
@property (nonatomic,strong) Comment *comment;

@property (nonatomic,strong) UIImageView *avatar;
@property (nonatomic,strong) TLabel *authorLbl;
@property (nonatomic,strong) EDStarRating *starRatingView;
@property (nonatomic,strong) TLabel *commentLbl;
@property (nonatomic,strong) TButton *usefulBtn;

+ (CGFloat)heightWithContent:(NSString *)content;
@end
