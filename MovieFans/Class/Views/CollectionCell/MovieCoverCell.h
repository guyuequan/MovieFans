//
//  MovieCoverCell.h
//  MovieFans
//
//  Created by Leo Gao on 15/10/25.
//  Copyright © 2015年 LeoCode. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MovieCoverCell;

@protocol MovieCoverCellDelegate<NSObject>

- (void)movieCoverCell:(MovieCoverCell *)cell deleteViewTapped:(UITapGestureRecognizer *)tap;

@end

@interface MovieCoverCell : UICollectionViewCell

@property (nonatomic,strong) UIImageView *coverImageView;
@property (nonatomic,strong) UIImageView *deleteImageView;
@property (nonatomic,strong) TLabel *titleLabel;
@property (nonatomic,strong) UILabel *scoreLabel;

@property (nonatomic,weak) id<MovieCoverCellDelegate> delegate;

- (void)setCoverUrlPath:(NSString *)path title:(NSString *)title score:(NSNumber *)score showDelegateFlag:(BOOL)deleteShow showTitleFlag:(BOOL)titleShow;

@end
