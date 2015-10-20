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
#define kCellMargin 10.f
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
    _titleLabel.font = [UIFont systemFontOfSize:15.f];
    _titleLabel.numberOfLines = 0;
    [self.contentView addSubview:_titleLabel];

    _abstractLabel = [[TLabel alloc]init];
//    _abstractLabel.textColor = [UIColor darkGrayColor];
    _abstractLabel.themeTextColorKey = THEME_COLOR_LABEL_LIGHT;
    _abstractLabel.font = [UIFont systemFontOfSize:14.f];
    _abstractLabel.numberOfLines = 0;
    _abstractLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentView addSubview:_abstractLabel];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView.mas_leading).offset(kCellMargin);
        make.top.equalTo(self.contentView.mas_top);
        make.trailing.equalTo(self.contentView.mas_trailing).offset(-kCellMargin);
        make.bottom.equalTo(self.abstractLabel.mas_top);
    }];
    
    [_abstractLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.leading.equalTo(self.titleLabel.mas_leading);
        make.trailing.equalTo(self.titleLabel.mas_trailing);
        make.height.mas_equalTo(74.f);
        make.bottom.equalTo(self.contentView.mas_bottom);
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
            if(review.content.length>251){
                _abstractLabel.attributedText = [[review.content substringToIndex:250] attributedStringWithLineSpacing:5.f];
            }else{
                _abstractLabel.attributedText = [review.content attributedStringWithLineSpacing:5.f];
            }
        }
        
    }
}
+ (CGFloat)heightWithTitle:(NSString *)title{
    
    CGFloat height = 75.f;
    
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:5.f];
    NSDictionary *attDic = @{NSFontAttributeName:[UIFont systemFontOfSize:15.f],NSParagraphStyleAttributeName:paragraphStyle1};
    if(title){
        height += [title heightWithAttributes:attDic andSize:CGSizeMake(kScreenWidth-kHorMargin*2,CGFLOAT_MAX)]+10.f;
    }
    return height;
}
@end
