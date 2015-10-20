//
//  TButton.m
//  MovieFans
//
//  Created by Leo Gao on 15/9/24.
//  Copyright © 2015年 LeoCode. All rights reserved.
//

#import "TButton.h"
#import "ThemeManager.h"

@implementation TButton


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
- (void)willMoveToSuperview:(UIView *)newSuperview{
    [self applyTheme];
}
- (void)_init {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeDidChangeNotification:) name:NOTICE_THEME_CHANGED object:nil];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
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
    if(self.themeTextColorNormalKey) {
        color = [ThemeManager themeColorWithKey:self.themeTextColorNormalKey];
        if(color){
            [self setTitleColor:color forState:UIControlStateNormal];
        }
    }
    if(self.themeTextColorHighlightedKey){
        color = [ThemeManager themeColorWithKey:self.themeTextColorHighlightedKey];
        if(color){
            [self setTitleColor:color forState:UIControlStateHighlighted];
        }
    }
    if(self.themeBackgroundColorKey){
        color = [ThemeManager themeColorWithKey:self.themeBackgroundColorKey];
        if(color){
            [self setBackgroundColor:color];
        }
    }
}
- (void)themeDidChangeNotification:(NSNotification *)notification {
    [self applyTheme];
}
@end
