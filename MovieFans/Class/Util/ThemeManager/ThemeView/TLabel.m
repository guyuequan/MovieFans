//
//  TLabel.m
//  MovieFans
//
//  Created by Leo Gao on 15/9/24.
//  Copyright © 2015年 LeoCode. All rights reserved.
//

#import "TLabel.h"
#import "ThemeManager.h"

@implementation TLabel

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
    if(self.themeTextColorKey){
        color = [ThemeManager themeColorWithKey:self.themeTextColorKey];
        if(color){
            self.textColor = color;
        }
    }
    if(self.themeBackgroundColorKey){
        color = [ThemeManager themeColorWithKey:self.themeBackgroundColorKey];
        if(color) {
            self.backgroundColor = color;
        }
    }
}

- (void)themeDidChangeNotification:(NSNotification *)notification {
    [self applyTheme];
}
@end
