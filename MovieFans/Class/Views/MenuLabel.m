//
//  MenuLabel.m
//  MovieFans
//
//  Created by Leo Gao on 15/9/7.
//  Copyright (c) 2015年 LeoCode. All rights reserved.
//

#import "MenuLabel.h"

@implementation MenuLabel{
    BOOL isNight;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        self.textAlignment = NSTextAlignmentCenter;
        self.font = [UIFont systemFontOfSize:18];
        
        self.scale = 0.0;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeDidChangeNotification:) name:NOTICE_THEME_CHANGED object:nil];
        [self applyTheme];
        
    }
    return self;
}
- (void)dealloc {
    @try {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    @catch (NSException *exception) {
        // do nothing, only unregistering self from notifications
    }
}

/** 通过scale的改变改变多种参数 */
- (void)setScale:(CGFloat)scale
{
    _scale = scale;
    
    if(isNight){
        self.textColor = [UIColor colorWithRed:0.5+scale/2 green:0.5-scale/2 blue:0.5-scale/2 alpha:1];
    }else{
        self.textColor = [UIColor colorWithRed:scale green:0 blue:0 alpha:1];
    }
    
    CGFloat minScale = 0.8;
    CGFloat trueScale = minScale + (1-minScale)*scale;
    self.transform = CGAffineTransformMakeScale(trueScale, trueScale);
}


- (void)themeDidChangeNotification:(NSNotification *)notification {
    [self applyTheme];
}
- (void)applyTheme {
    if([ThemeManager shareInstance].themeType==ThemeTypeNight){
        isNight = YES;
    }else{
        isNight = NO;
    }
    [self setScale:self.scale];
}
@end
