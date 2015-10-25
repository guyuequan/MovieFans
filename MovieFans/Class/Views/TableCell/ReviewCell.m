//
//  ReviewCell.m
//  MovieFans
//
//  Created by Leo Gao on 15/9/13.
//  Copyright (c) 2015年 LeoCode. All rights reserved.
//

#import "ReviewCell.h"

#define kHorMargin 20.f
#define kVerMargin 8.f
#define kCellMargin 15.f
@implementation ReviewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        [self setupSubViews];
    }
    return  self;
}

- (void)setupSubViews{
    _titleLabel = [[TLabel alloc]init];
//    _titleLabel.textColor = [UIColor darkGrayColor];
    _titleLabel.themeTextColorKey = THEME_COLOR_LABEL_DARK;
    _titleLabel.font = [UIFont systemFontOfSize:18.f];
    _titleLabel.numberOfLines = 0;
    [self.contentView addSubview:_titleLabel];

    _abstractLabel = [[TLabel alloc]init];
    _abstractLabel.themeTextColorKey = THEME_COLOR_LABEL_LIGHT;
    _abstractLabel.font = [UIFont systemFontOfSize:15.f];
    _abstractLabel.numberOfLines = 0;
    _abstractLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [self.contentView addSubview:_abstractLabel];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView.mas_leading).offset(kCellMargin);
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.trailing.equalTo(self.contentView.mas_trailing).offset(-kCellMargin);
        make.bottom.equalTo(self.abstractLabel.mas_top);
    }];
    
    [_abstractLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.leading.equalTo(self.titleLabel.mas_leading);
        make.trailing.equalTo(self.titleLabel.mas_trailing);
        make.height.mas_equalTo(74.f);
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

- (void)setReview:(Review *)review{
    if(_review!=review){
        _review = review;
        
        if(!review.title){
            _titleLabel.text = @"";
        }else{
            _titleLabel.attributedText = [review.title attributedStringWithLineSpacing:5.f];
        }
        
        if(!review.content){
            _abstractLabel.text = @"";
        }else{
            NSString *tmp = [review.content trimWhitespace];
            if(tmp.length>251){
                //不截取的话，会很卡
                _abstractLabel.attributedText = [[tmp substringToIndex:250] attributedStringWithLineSpacing:5.f];
            }else{
                _abstractLabel.attributedText = [tmp attributedStringWithLineSpacing:5.f];
            }
        }
        
    }
}
+ (CGFloat)heightWithTitle:(NSString *)title{
    
    CGFloat height = 75.f+10+10+10;//内容高度+上下margin+间隙
    
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:5.f];
    NSDictionary *attDic = @{NSFontAttributeName:[UIFont systemFontOfSize:15.f],NSParagraphStyleAttributeName:paragraphStyle1};
    if(title){
        height += [title heightWithAttributes:attDic andSize:CGSizeMake(kScreenWidth-kHorMargin*2,CGFLOAT_MAX)];
    }
    return height;
}
@end
