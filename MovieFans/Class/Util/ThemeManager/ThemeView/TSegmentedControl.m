//
//  TSegmentedControl.m
//  MovieFans
//
//  Created by Leo Gao on 15/9/24.
//  Copyright © 2015年 LeoCode. All rights reserved.
//

#import "TSegmentedControl.h"

@implementation TSegmentedControl

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self _init];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self _init];
    }
    return self;
}

- (id)init {
    if (self = [super init]) {
        [self _init];
    }
    return self;
}
- (void)_init {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeDidChangeNotification:) name:NOTICE_THEME_CHANGED object:nil];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self applyTheme];
}
- (void)willMoveToSuperview:(UIView *)newSuperview{
    [self applyTheme];
}
- (void)dealloc {
    @try {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    @catch (NSException *exception) {
        // do nothing, only unregistering self from notifications
    }
}

- (void)applyTheme {
    UIColor *color;
    if(self.themeTitleNormalColorKey){
        color = [ThemeManager themeColorWithKey:self.themeTitleNormalColorKey];
        if(color){
            [self setTitleTextAttributes:@{NSForegroundColorAttributeName:color} forState:UIControlStateNormal];
        }
    }
    if(self.themeTitleSelectedColorKey){
        color = [ThemeManager themeColorWithKey:self.themeTitleSelectedColorKey];
        if(color) {
            [self setTitleTextAttributes:@{NSForegroundColorAttributeName:color} forState:UIControlStateSelected];
        }
    }
    if(self.themeBackgroundSelectedColorKey){
        color = [ThemeManager themeColorWithKey:self.themeBackgroundSelectedColorKey];
        if(color){
//            [self setBackgroundColor:color];
            [self setBackgroundImage:[UIImage imageWithColor:color] forState:UIControlStateNormal barMetrics:UIBarMetricsCompact];
        }
    }
}

- (void)themeDidChangeNotification:(NSNotification *)notification {
    [self applyTheme];
}

@end
