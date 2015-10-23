//
//  CommentCell.m
//  MovieFans
//
//  Created by Leo Gao on 15/9/11.
//  Copyright (c) 2015年 LeoCode. All rights reserved.
//

#import "CommentCell.h"

#define kCellMargin 15.f
#define kAuthorHeight 20.f

#define kCommentFont [UIFont systemFontOfSize:15.f]


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
    //背景色
//    TLabel *backgroundView = [[TLabel alloc]init];
//    backgroundView.themeBackgroundColorKey = THEME_COLOR_CELL_BACKGROUND_DARK;
//    [self.contentView addSubview:backgroundView];
//    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(5,0.f,0.f,0.f));
//    }];
//
    //头像
//    _avatar = [[UIImageView alloc]init];
//    _avatar.contentMode = UIViewContentModeScaleAspectFit;
//    [self.contentView addSubview:_avatar];
    
//    [_avatar mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.equalTo(self.contentView.mas_leading).offset(kCellMargin);
//        make.top.equalTo(self.contentView.mas_top).offset(5);
//        make.width.mas_equalTo(20.f);
//        make.height.mas_equalTo(20.f);
//    }];
//
    _authorLbl = [[TLabel alloc]init];
    _authorLbl.themeTextColorKey = THEME_COLOR_LABEL_LIGHT;
    _authorLbl.font = [UIFont systemFontOfSize:15.f];
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
    _commentLbl.font = kCommentFont;
    _commentLbl.themeTextColorKey = THEME_COLOR_LABEL_LIGHT;
    [self.contentView addSubview:_commentLbl];
    
    _usefulBtn = [[TButton alloc]init];
    [_usefulBtn setImage:[UIImage imageNamed:@"useful"] forState:UIControlStateNormal];
    _usefulBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    _usefulBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    _usefulBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    _usefulBtn.themeTextColorNormalKey = THEME_COLOR_LABEL_LIGHT;
    [self.contentView addSubview:_usefulBtn];
    
    [_authorLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView.mas_leading).offset(kCellMargin);
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.width.mas_lessThanOrEqualTo(150.f);
        make.height.mas_equalTo(kAuthorHeight);
    }];
    [_starRatingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_authorLbl.mas_trailing);
        make.top.equalTo(_authorLbl.mas_top);
        make.width.mas_equalTo(100.f);
        make.height.equalTo(_authorLbl.mas_height);
    }];
    [_usefulBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_authorLbl.mas_top).offset(5);
        make.height.equalTo(_authorLbl.mas_height).offset(-5);
        make.trailing.equalTo(self.contentView.mas_trailing).offset(-kCellMargin);
        make.width.mas_greaterThanOrEqualTo(90);
    }];
    
    [_commentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_authorLbl.mas_leading);
        make.top.equalTo(_authorLbl.mas_bottom).offset(10);
        make.trailing.equalTo(self.contentView.mas_trailing).offset(-kCellMargin);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
    }];
    
    
    //分割线
    TLabel *line = [[TLabel alloc]init];
    line.themeBackgroundColorKey = THEME_COLOR_MENU_BACKGROUND;
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView.mas_leading).offset(kCellMargin);
        make.trailing.equalTo(self.contentView.mas_trailing).offset(-kCellMargin);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.mas_equalTo(1);
    }];

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
        [_usefulBtn setTitle:[comment.usefulCount stringValue] forState:UIControlStateNormal];
    }
}
+ (CGFloat)heightWithContent:(NSString *)content{
    
    CGFloat height = kAuthorHeight+30;
    
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:5.f];
    NSDictionary *attDic = @{NSFontAttributeName:kCommentFont,NSParagraphStyleAttributeName:paragraphStyle1};
    if(content){
        height += [content heightWithAttributes:attDic andSize:CGSizeMake(kScreenWidth-kCellMargin*2,CGFLOAT_MAX)];
    }
    return height;
}
@end
