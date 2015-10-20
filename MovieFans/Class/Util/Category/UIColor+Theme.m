//
//  UIColor+Theme.m
//  MovieFans
//
//  Created by wootide on 15/9/23.
//  Copyright © 2015年 LeoCode. All rights reserved.
//

#import "UIColor+Theme.h"

@implementation UIColor (Theme)
+ (UIColor *)colorWithThemeKey:(NSString *)key{
    return [ThemeManager getThemeColor:key];
}

//+ (UIColor *)viewBackgroundColorLight{
//    return [ThemeManager getThemeColor:THEME_COLOR_VIEW_BACKGROUND_LIGHT];
//}
//+ (UIColor *)viewBackgroundColor{
//    return [ThemeManager getThemeColor:THEME_COLOR_VIEW_BACKGROUND];
//}
//+ (UIColor *)labelDarkColor{
//    return [ThemeManager getThemeColor:THEME_COLOR_LABEL_DARK];
//}
//+ (UIColor *)labelLightColor{
//    return [ThemeManager getThemeColor:THEME_COLOR_LABEL_LIGHT];
//}
//+ (UIColor *)cellTitleColor{
//    return [ThemeManager getThemeColor:THEME_COLOR_CELL_TITLE];
//}
//+ (UIColor *)cellContentColor{
//    return [ThemeManager getThemeColor:THEME_COLOR_CELL_CONTENT];
//}
//+ (UIColor *)cellBackgroundLightColor{
//    return [ThemeManager getThemeColor:THEME_COLOR_CELL_BACKGROUND_DARK];
//}
//+ (UIColor *)cellBackgroundDarkColor{
//    return [ThemeManager getThemeColor:THEME_COLOR_CELL_BACKGROUND_LIGHT];
//}
//+ (UIColor *)buttonTextColor{
//    return [ThemeManager getThemeColor:THEME_COLOR_BUTTON_TEXT];
//}
//+ (UIColor *)buttonBackgroundColor{
//    return [ThemeManager getThemeColor:THEME_COLOR_BUTTON_BACKGROUND];
//}
//+ (UIColor *)menuBackgroundColor{
//    return [ThemeManager getThemeColor:THEME_COLOR_MENU_BACKGROUND];
//}
//+ (UIColor *)navigationBarBackgroundColor{
//    return [ThemeManager getThemeColor:THEME_COLOR_NAVIGATION_BAR_BACKGROUND];
//}
//+ (UIColor *)navigationItemTintColor{
//    return [ThemeManager getThemeColor:THEME_COLOR_NAVIGATION_ITEM_TINT];
//}
//+ (UIColor *)tabBarTintColor{
//    return [ThemeManager getThemeColor:THEME_COLOR_TAB_BAR_TINT];
//}
//+ (UIColor *)tabBarBackgroundColor{
//    return [ThemeManager getThemeColor:THEME_COLOR_TAB_BAR_BACKGROUND];
//}
//+ (UIColor *)segmentBackgroundColor{
//    return [ThemeManager getThemeColor:THEME_COLOR_SEGMENT_BACKGROUND];
//}
//+ (UIColor *)segmentTintColor{
//    return [ThemeManager getThemeColor:THEME_COLOR_SEGMENT_TINT];
//}
//+ (UIColor *)segmentTextSelectedColor{
//    return [ThemeManager getThemeColor:THEME_COLOR_SEGMENT_TEXT_SELECTED];
//}
//+ (UIColor *)segmentTextNormalColor{
//    return [ThemeManager getThemeColor:THEME_COLOR_SEGMENT_TEXT_NORMAL];
//}
@end
