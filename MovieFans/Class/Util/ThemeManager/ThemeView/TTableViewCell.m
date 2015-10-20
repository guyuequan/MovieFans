//
//  TTableViewCell.m
//  MovieFans
//
//  Created by Leo Gao on 15/9/25.
//  Copyright © 2015年 LeoCode. All rights reserved.
//

#import "TTableViewCell.h"

@implementation TTableViewCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self registNotice];
        [self applyTheme];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self registNotice];
        [self applyTheme];
    }
    return self;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self registNotice];
        [self applyTheme];
    }
    return self;
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [self applyTheme];
}
- (void)registNotice{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeDidChangeNotification:) name:NOTICE_THEME_CHANGED object:nil];
    
}
- (void)applyTheme {
    UIColor *color;
    if(self.themeTitleColorKey){
        color = [ThemeManager themeColorWithKey:self.themeTitleColorKey];
        if(color){
            self.textLabel.textColor = color;
        }
    }
    if(self.themeDetailColorKey){
        color = [ThemeManager themeColorWithKey:self.themeDetailColorKey];
        if(color) {
            self.detailTextLabel.textColor = color;
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
