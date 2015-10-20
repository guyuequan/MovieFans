//
//  SearchTagCell.m
//  MovieFans
//
//  Created by Leo Gao on 15/10/18.
//  Copyright © 2015年 LeoCode. All rights reserved.
//

#import "SearchTagCell.h"

@implementation SearchTagCell
- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        _label = [[UILabel alloc]initWithFrame:CGRectMake(0.f, 0.f, frame.size.width, frame.size.height)];
        _label.font = [UIFont boldSystemFontOfSize:14.f];
        _label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_label];
        _label.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self registNotice];
    }
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self applyTheme];
}
- (void)willMoveToSuperview:(UIView *)newSuperview{
    [self applyTheme];
}

- (void)registNotice{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeDidChangeNotification:) name:NOTICE_THEME_CHANGED object:nil];
    
}
- (void)applyTheme {
    if([ThemeManager shareInstance].themeType==ThemeTypeNight){
        _label.textColor = [UIColor randomLightColor];
    }else{
        _label.textColor = [UIColor randomDarkColor];
    }
}
- (void)themeDidChangeNotification:(NSNotification *)notification {
    [self applyTheme];
}

// 根据标签内容，计算并返回size大小
+ (CGSize)sizeWithTag:(NSString *)tag{
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont boldSystemFontOfSize:14.f];
    label.text = tag;
    [label sizeToFit];
    return label.bounds.size;
}
@end
