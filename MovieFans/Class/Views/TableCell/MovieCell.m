//
//  MovieCell.m
//  MovieFans
//
//  Created by Leo Gao on 15/9/7.
//  Copyright (c) 2015年 LeoCode. All rights reserved.
//

#import "MovieCell.h"

#define kCellMargin 10.f
@implementation MovieCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        [self initSubViews];
    }
    return  self;
}
- (void)initSubViews{
    _coverIV= [[UIImageView alloc]init];
    _coverIV.contentMode = UIViewContentModeScaleAspectFill;
    _coverIV.clipsToBounds = YES;
    [self.contentView addSubview:_coverIV];
    
    _nameLbl = [[TLabel alloc]init];
    _nameLbl.font = [UIFont fontWithName:@"Helvetica-BoldOblique" size:16.f];
    _nameLbl.textColor = [UIColor darkGrayColor];
    _nameLbl.themeTextColorKey = THEME_COLOR_LABEL_DARK;
    [self.contentView addSubview:_nameLbl];
    
    _categoryLbl = [[TLabel alloc]init];
    _categoryLbl.font = [UIFont italicSystemFontOfSize:12.f];
    _categoryLbl.textColor = [UIColor darkGrayColor];
    _categoryLbl.themeTextColorKey = THEME_COLOR_LABEL_LIGHT;
    [self.contentView addSubview:_categoryLbl];
    
    _yearLbl = [[TLabel alloc]init];
    _yearLbl.font = [UIFont italicSystemFontOfSize:12.f];
    _yearLbl.textColor = [UIColor darkGrayColor];
    _yearLbl.themeTextColorKey = THEME_COLOR_LABEL_LIGHT;
    [self.contentView addSubview:_yearLbl];
    
    _ratingValueLbl = [[TLabel alloc]init];
    _ratingValueLbl.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_ratingValueLbl];
    
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
    
    [self setupSubviewsLayout];
}
- (void)setupSubviewsLayout{
    
    CGFloat verMargin = 5.f;
    CGFloat coverWidth = isPad?75.f:60.f;
    
    [_coverIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView.mas_leading).offset(kCellMargin);
        make.top.equalTo(self.contentView.mas_top).offset(verMargin);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-verMargin);
        make.width.mas_equalTo(coverWidth);
    }];
    [_nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.coverIV.mas_trailing).offset(5.f);
        make.top.equalTo(self.contentView.mas_top).offset(isPad?10.f:0);
        make.height.mas_equalTo(35.f);
        make.trailing.equalTo(self.contentView.mas_trailing);
    }];
    [_categoryLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.nameLbl.mas_leading);
        make.bottom.equalTo(self.yearLbl.mas_top);
        make.height.mas_equalTo(20.f);
        make.width.mas_greaterThanOrEqualTo(100.f);
    }];
    [_yearLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.nameLbl.mas_leading);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(isPad?-20.f:-verMargin);
        make.height.mas_equalTo(20.f);
        make.width.mas_greaterThanOrEqualTo(100.f);
    }];
    [_ratingValueLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(40.f);
        make.trailing.equalTo(self.contentView.mas_trailing).offset(-kCellMargin);
        make.width.mas_greaterThanOrEqualTo(50.f);
    }];
    
    
}
- (void)setDataModel:(MovieSimple*)model{
    if(model){
        if(model.posterPathMedium){
            [self.coverIV  sd_setImageWithURL:[NSURL URLWithString:model.posterPathMedium] placeholderImage:[UIImage imageNamed:@"poster_default"]];
        }
        if(model.movieName){
            self.nameLbl.text = [NSString stringWithFormat:@"%@",model.movieName];
        }
        if(model.categoryArr){
            self.categoryLbl.text = [NSString stringWithFormat:@"类型:%@",[model.categoryArr componentsJoinedByString:@"/"]];
        }else if(model.wishSee) {
            self.categoryLbl.text = [NSString stringWithFormat:@"热度:%@",model.wishSee];
        }
        if(model.year){
            self.yearLbl.text = [NSString stringWithFormat:@"年份:%@",model.year];
        }else if(model.pubDate){
            self.yearLbl.text = [NSString stringWithFormat:@"上映日期:%@",model.pubDate];
        }
        if(model.rating){
            NSString *str = [NSString stringWithFormat:@" %.1f 分",[model.rating floatValue]];
            if([model.rating floatValue]==0.f){
                str = [NSString stringWithFormat:@"  -   分"];
            }
            NSMutableAttributedString *attrString =
            [[NSMutableAttributedString alloc] initWithString:str];
            
            UIFont *redFont = [UIFont fontWithName:@"Helvetica-BoldOblique" size:18.f];
            [attrString addAttribute:NSFontAttributeName value:redFont
                               range:NSMakeRange(0,[str length])];
            [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,[str length])];
            self.ratingValueLbl.attributedText = attrString;
        }
    }
}

+ (CGFloat)HeightOfCell{
    return isPad?110.f:85.f;
}

@end
