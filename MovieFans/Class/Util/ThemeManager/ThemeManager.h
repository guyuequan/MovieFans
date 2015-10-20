//
//  ThemeManager.h
//  WXWeibo
//
//  Created by wei.chen on 13-5-14.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import <Foundation/Foundation.h>


//主题切换状态
FOUNDATION_EXPORT NSString *const KEY_THEME_NAME;
FOUNDATION_EXPORT NSString *const THEME_DEFAULT;
FOUNDATION_EXPORT NSString *const THEME_NIGHT;

typedef NS_ENUM(NSInteger,ThemeType){
    ThemeTypeDefault = 0,
    ThemeTypeNight
};

//切换通知
FOUNDATION_EXPORT NSString *const NOTICE_THEME_CHANGED;

//主题色
FOUNDATION_EXPORT NSString *const THEME_COLOR_VIEW_BACKGROUND;
FOUNDATION_EXPORT NSString *const THEME_COLOR_LABEL_DARK;
FOUNDATION_EXPORT NSString *const THEME_COLOR_LABEL_LIGHT;
FOUNDATION_EXPORT NSString *const THEME_COLOR_CELL_TITLE;
FOUNDATION_EXPORT NSString *const THEME_COLOR_CELL_CONTENT;
FOUNDATION_EXPORT NSString *const THEME_COLOR_CELL_BACKGROUND_DARK;
FOUNDATION_EXPORT NSString *const THEME_COLOR_CELL_BACKGROUND_LIGHT;
FOUNDATION_EXPORT NSString *const THEME_COLOR_BUTTON_TEXT;
FOUNDATION_EXPORT NSString *const THEME_COLOR_BUTTON_BACKGROUND;
FOUNDATION_EXPORT NSString *const THEME_COLOR_MENU_BACKGROUND;
FOUNDATION_EXPORT NSString *const THEME_COLOR_NAVIGATION_BAR_BACKGROUND;
FOUNDATION_EXPORT NSString *const THEME_COLOR_NAVIGATION_ITEM_TINT;
FOUNDATION_EXPORT NSString *const THEME_COLOR_TAB_BAR_TINT;
FOUNDATION_EXPORT NSString *const THEME_COLOR_TAB_BAR_BACKGROUND;
FOUNDATION_EXPORT NSString *const THEME_COLOR_SEGMENT_BACKGROUND;
FOUNDATION_EXPORT NSString *const THEME_COLOR_SEGMENT_BACKGROUND_SELECTED;
FOUNDATION_EXPORT NSString *const THEME_COLOR_SEGMENT_TEXT_SELECTED;
FOUNDATION_EXPORT NSString *const THEME_COLOR_SEGMENT_TEXT_NORMAL;


@interface ThemeManager : NSObject
//主题索引配置信息
@property (nonatomic,retain) NSDictionary *themesConfig;
//主题颜色的配置信息
@property (nonatomic,strong) NSDictionary *colorConfig;

@property (nonatomic,assign) ThemeType themeType;

+ (ThemeManager *)shareInstance;

+ (UIColor *)themeColorWithKey:(NSString *)colorName;
+ (UIImage *)themeImageWithKey:(NSString *)imageName;
@end
