//
//  CoverCell.m
//  MovieFans
//
//  Created by Leo Gao on 15/10/20.
//  Copyright © 2015年 LeoCode. All rights reserved.
//

#import "CoverCell.h"

@implementation CoverCell

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        CGFloat width = frame.size.width;
        CGFloat height = frame.size.height;
        
        _coverImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.f, 0.f,width,height)];
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
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showDeleteView) name:NOTICE_COLLECTION_DATA_BEGIN_EDIT object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hideDeleteView) name:NOTICE_COLLECTION_DATA_END_EDIT object:nil];
        
    }
    return self;
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - Public
- (void)setCoverUrlPath:(NSString *)path showDelegateFlag:(BOOL)deleteFlag{

    [_coverImageView sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"poster_default"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    }];
    if(deleteFlag){
        [self showDeleteView];
    }else{
        [self hideDeleteView];
    }
}
#pragma mark - Private
- (void)deleteItem:(UITapGestureRecognizer *)tap{
    if([self.delegate respondsToSelector:@selector(coverCell: deleteViewTapped:)]){
        [self.delegate coverCell:self deleteViewTapped:tap];
    }
    [MobClick event:@"UMEVentDeleteCollection"];
}
- (void)showDeleteView{
    CGFloat deleteMargin = 10.f;
    [UIView animateWithDuration:.25 animations:^{
        _coverImageView.frame = CGRectMake(deleteMargin, deleteMargin, self.bounds.size.width-deleteMargin*2,self.bounds.size.height-deleteMargin*2);
        _deleteImageView.alpha = 1;
    }];
}
- (void)hideDeleteView{
    [UIView animateWithDuration:.25 animations:^{
        _coverImageView.frame = CGRectMake(0.f, 0.f, self.bounds.size.width,self.bounds.size.height);
        _deleteImageView.alpha = 0;
    }];
}
@end
