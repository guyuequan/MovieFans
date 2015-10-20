//
//  CommentCell.m
//  MovieFans
//
//  Created by Leo Gao on 15/9/11.
//  Copyright (c) 2015年 LeoCode. All rights reserved.
//

#import "CommentCell.h"
#define kCellMargin 10.f
@interface CommentCell()
@end

@implementation CommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        [self setupSubViews];
    }
    return  self;
}
- (void)setupSubViews{
    _avatar = [[UIImageView alloc]init];
    _avatar.contentMode = UIViewContentModeScaleAspectFit;
//    [self.contentView addSubview:_avatar];
    
    _authorLbl = [[TLabel alloc]init];
    _authorLbl.themeTextColorKey = THEME_COLOR_LABEL_LIGHT;
    _authorLbl.font = [UIFont systemFontOfSize:14.f];
    [self.contentView addSubview:_authorLbl];
    
    _starRatingView = [[EDStarRating alloc]init];
    _starRatingView.starImage = [[UIImage imageNamed:@"ratingstar"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _starRatingView.starHighlightedImage = [[UIImage imageNamed:@"ratingstar_activated"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _starRatingView.maxRating = 5.0;
    _starRatingView.horizontalMargin = 15.0;
    [_starRatingView setNeedsDisplay];
    _starRatingView.displayMode=EDStarRatingDisplayHalf;
    [self.contentView addSubview:_starRatingView];

    _commentLbl = [[TLabel alloc]init];
    _commentLbl.numberOfLines = 0;
    _commentLbl.font = [UIFont systemFontOfSize:14.f];
    _commentLbl.themeTextColorKey = THEME_COLOR_LABEL_LIGHT;
    [self.contentView addSubview:_commentLbl];
    
//    [_avatar mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.equalTo(self.contentView.mas_leading).offset(kCellMargin);
//        make.top.equalTo(self.contentView.mas_top).offset(5);
//        make.width.mas_equalTo(20.f);
//        make.height.mas_equalTo(20.f);
//    }];
//    
    [_authorLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView.mas_leading).offset(kCellMargin);
        make.top.equalTo(self.contentView.mas_top).offset(5);
        make.width.mas_lessThanOrEqualTo(150.f);
        make.height.mas_equalTo(20.f);
    }];
    [_starRatingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_authorLbl.mas_trailing);
        make.top.equalTo(_authorLbl.mas_top);
        make.width.mas_equalTo(100.f);
        make.height.equalTo(_authorLbl.mas_height);
    }];
    [_commentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_authorLbl.mas_leading);
        make.top.equalTo(_authorLbl.mas_bottom);
        make.trailing.equalTo(self.contentView.mas_trailing).offset(-kCellMargin);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-5);
    }];
    
    //pad自己写分割线
//    if (isPad){
    UILabel *line = [[UILabel alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"0xcccccc"];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView.mas_leading).offset(kCellMargin);
        make.trailing.equalTo(self.contentView.mas_trailing).offset(-kCellMargin);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.mas_equalTo(0.5f);
    }];
//    }

}
- (void)setComment:(Comment *)comment{
    if(_comment!=comment){
        _comment = comment;
        _authorLbl.text = comment.author;
//        [_avatar sd_setImageWithURL:[NSURL URLWithString:comment.avatar] placeholderImage:[UIImage imageNamed:@"empty_picture"]];
        if(!comment.content){
            _commentLbl.text = @"";
        }else{
            _commentLbl.attributedText = [comment.content attributedStringWithLineSpacing:5.f];
        }
        _starRatingView.rating = [comment.rating floatValue];
    }
}
+ (CGFloat)heightWithContent:(NSString *)content{
    
    //author.height = 20.f  上下margin= 10.f
    CGFloat height = 30.f;
    
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:5.f];
    NSDictionary *attDic = @{NSFontAttributeName:[UIFont systemFontOfSize:14.f],NSParagraphStyleAttributeName:paragraphStyle1};
    if(content){
        height += [content heightWithAttributes:attDic andSize:CGSizeMake(kScreenWidth-25,CGFLOAT_MAX)]+10.f;
    }
    return height;
}
@end
