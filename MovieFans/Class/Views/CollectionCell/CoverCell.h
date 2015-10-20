//
//  CoverCell.h
//  MovieFans
//
//  Created by Leo Gao on 15/10/20.
//  Copyright © 2015年 LeoCode. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CoverCell;
@protocol CoverCellDelegate<NSObject>

- (void)CoverCell:(CoverCell *)cell deleteViewTapped:(UITapGestureRecognizer *)tap;

@end

@interface CoverCell : UICollectionViewCell

@property (nonatomic,strong) UIImageView *coverImageView;
@property (nonatomic,strong) UIImageView *deleteImageView;
@property (nonatomic,weak) id<CoverCellDelegate> delegate;

- (void)setCoverUrlPath:(NSString *)path showDelegateFlag:(BOOL)show;

@end
