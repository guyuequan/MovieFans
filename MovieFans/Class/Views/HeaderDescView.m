//
//  HeaderDescView.m
//  Ban
//
//  Created by Leo Gao on 15/7/9.
//  Copyright (c) 2015年 LeoCode. All rights reserved.
//

#import "HeaderDescView.h"
@interface HeaderDescView()
@property (nonatomic,strong) NSString *desc;
@property (nonatomic,strong) NSString *moreTxt;
@end
@implementation HeaderDescView

//-(instancetype)initWithDesc:(NSString *)desc{
//    return [self initWithDesc:desc andShowMoreLabelWithText:@""];
//}
//-(instancetype)initWithDesc:(NSString *)desc andShowMoreLabelWithText:(NSString *)moreTxt{
//    self = [super init];
//    if(self){
//        _desc = desc;
//        moreTxt = moreTxt;
//        [self setupSubviews];
//    }
//    return self;
//}

-(instancetype)init{
    self = [super init];
    if(self){
        [self setupSubviews];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setupSubviews];
    }
    return self;
}
-(void)setupSubviews{
    CGFloat gapH = 6.f;
    CGFloat gapW = 10.f;
    
    _colorLbl = [[TLabel alloc]init];
    _colorLbl.backgroundColor = [UIColor orangeColor];
    _colorLbl.layer.cornerRadius = 3.f;
    _colorLbl.layer.masksToBounds = YES;
    [self addSubview:_colorLbl];

    _descLbl = [[TLabel alloc]init];
    _descLbl.backgroundColor = [UIColor clearColor];
    _descLbl.font = [UIFont boldSystemFontOfSize:15.f];
//    _descLbl.textColor = [UIColor colorWithHexString:@"0x66BFFf"];
    _descLbl.themeTextColorKey = THEME_COLOR_LABEL_DARK;
    _descLbl.text = self.desc;
    [self addSubview:_descLbl];
    
    _moreLbl = [[TLabel alloc]init];
    _moreLbl.backgroundColor = [UIColor clearColor];
    _moreLbl.font = [UIFont boldSystemFontOfSize:14.f];
//    _moreLbl.textColor = [UIColor colorWithHexString:@"0xff9933"];
    _moreLbl.themeTextColorKey = THEME_COLOR_LABEL_DARK;
    _moreLbl.textAlignment = NSTextAlignmentRight;
    _moreLbl.text = self.moreTxt;
    [self addSubview:_moreLbl];
    
    [_colorLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.mas_leading).offset(gapW);
        make.width.equalTo(@2.f);
        make.top.equalTo(self.mas_top).offset(gapH);
        make.bottom.equalTo(self.mas_bottom).offset(-gapH);
    }];

    [_descLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_colorLbl.mas_trailing).offset(gapW);
        make.top.equalTo(self.mas_top).offset(gapH);
        make.bottom.equalTo(self.mas_bottom).offset(-gapH);
        make.trailing.equalTo(_moreLbl.mas_leading);
    }];
    [_moreLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_descLbl.mas_trailing);
        make.top.equalTo(self.mas_top).offset(gapH);
        make.bottom.equalTo(self.mas_bottom).offset(-gapH);
        make.trailing.equalTo(self.mas_trailing).offset(-gapW);
        make.width.equalTo(@80.f);
    }];
    
}


@end
