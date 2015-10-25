//
//  MovieCoverCell.m
//  MovieFans
//
//  Created by Leo Gao on 15/10/25.
//  Copyright © 2015年 LeoCode. All rights reserved.
//

#import "MovieCoverCell.h"

@implementation MovieCoverCell{
    CGFloat _titleLabelHeight;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        CGFloat width = frame.size.width;
        CGFloat height = frame.size.height;
        _titleLabelHeight = 20.f;
        
        _coverImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.f, 0.f,width,height-_titleLabelHeight)];
        _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        _coverImageView.clipsToBounds = YES;
        [self.contentView addSubview:_coverImageView];
        
        _deleteImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.f,0.f,30.f,30.f)];
        _deleteImageView.contentMode = UIViewContentModeScaleAspectFill;
        _deleteImageView.image = [UIImage imageNamed:@"delete"];
        [self.contentView addSubview:_deleteImageView];
        _deleteImageView.alpha = 0;
        _deleteImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(deleteItem:)];
        [_deleteImageView addGestureRecognizer:tap];
        
        _titleLabel = [[TLabel alloc]initWithFrame:CGRectMake(0.f,height-_titleLabelHeight,width,_titleLabelHeight)];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.themeTextColorKey = THEME_COLOR_CELL_TITLE;
        _titleLabel.alpha = 1;
        _titleLabel.numberOfLines = 0;
        [self.contentView addSubview:_titleLabel];
        
        CGFloat scoreWidth = 60.f;
        CGFloat scoreHeight = 18.f;
        _scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(width-scoreWidth,-scoreHeight-5,scoreWidth,scoreHeight)];
        _scoreLabel.font = [UIFont boldSystemFontOfSize:15.f];
        _scoreLabel.alpha = 1;
        _scoreLabel.textColor = [UIColor redColor];
        _scoreLabel.backgroundColor = [UIColor colorWithHexString:@"0x1892e5"];
//        _scoreLabel.backgroundColor = [UIColor orangeColor];
        _scoreLabel.transform = CGAffineTransformMakeRotation(M_PI_4);
        _scoreLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_scoreLabel];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showDeleteView) name:NOTICE_COLLECTION_DATA_BEGIN_EDIT object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hideDeleteView) name:NOTICE_COLLECTION_DATA_END_EDIT object:nil];
        
        self.contentView.clipsToBounds = YES;
    }
    return self;
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - Public
- (void)setCoverUrlPath:(NSString *)path title:(NSString *)title score:(NSNumber *)score showDelegateFlag:(BOOL)deleteShow showTitleFlag:(BOOL)titleShow{
    
    [_coverImageView sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"poster_default"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    }];
    _titleLabel.text = title;
    _scoreLabel.text = [NSString stringWithFormat:@"%.1f",[score floatValue]];
    [self refreshLayoutWithShowTitleFlag:titleShow showDeleteFlag:deleteShow];
}
#pragma mark - Private
- (void)refreshLayoutWithShowTitleFlag:(BOOL)titleFlag showDeleteFlag:(BOOL)deleteflag{
    
    _titleLabel.hidden = !titleFlag;
    _scoreLabel.hidden = !titleFlag;
    _titleLabelHeight = titleFlag?20.f:0.f;
    CGFloat deleteMargin = deleteflag?10.f:0.f;
    _coverImageView.frame = CGRectMake(deleteMargin, deleteMargin, self.bounds.size.width-deleteMargin*2,self.bounds.size.height-_titleLabelHeight-deleteMargin*2);
    _titleLabel.frame = CGRectMake(0.f,self.bounds.size.height-_titleLabelHeight,self.bounds.size.width,_titleLabelHeight);
    CGFloat scoreWidth = 60.f;
    CGFloat scoreHeight = 18.f;
    _scoreLabel.transform = CGAffineTransformIdentity;
    _scoreLabel.frame = CGRectMake(self.bounds.size.width-45,5,scoreWidth,scoreHeight);
    _scoreLabel.transform = CGAffineTransformMakeRotation(M_PI_4);

}
- (void)deleteItem:(UITapGestureRecognizer *)tap{
    if([self.delegate respondsToSelector:@selector(movieCoverCell: deleteViewTapped:)]){
        [self.delegate movieCoverCell:self deleteViewTapped:tap];
    }
    [MobClick event:@"UMEVentDeleteCollection"];
}
- (void)showDeleteView{
     CGFloat deleteMargin = 10.f;
    [UIView animateWithDuration:.25 animations:^{
        _coverImageView.frame = CGRectMake(deleteMargin, deleteMargin, self.bounds.size.width-deleteMargin*2,self.bounds.size.height-_titleLabelHeight-deleteMargin*2);
        _deleteImageView.alpha = 1;
        _titleLabel.alpha = 0;
        _scoreLabel.alpha = 0;
    }];
}
- (void)hideDeleteView{
    [UIView animateWithDuration:.25 animations:^{
        _coverImageView.frame = CGRectMake(0.f, 0.f, self.bounds.size.width,self.bounds.size.height-_titleLabelHeight);
        _deleteImageView.alpha = 0;
        _titleLabel.alpha = 1;
        _scoreLabel.alpha = 1;
    }];
}

@end
