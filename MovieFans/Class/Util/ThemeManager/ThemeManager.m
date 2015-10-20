//
//  ThemeManager.m
//  WXWeibo
//
//  Created by wei.chen on 13-5-14.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "ThemeManager.h"

//主题切换状态
NSString *const KEY_THEME_NAME = @"keyThemeName";
NSString *const THEME_DEFAULT = @"default";
NSString *const THEME_NIGHT = @"night";

//切换通知
NSString *const NOTICE_THEME_CHANGED = @"noticeThemeChanged";

//主题色
NSString *const THEME_COLOR_VIEW_BACKGROUND = @"theme_color_view_background";
NSString *const THEME_COLOR_LABEL_DARK = @"theme_color_label_dark";
NSString *const THEME_COLOR_LABEL_LIGHT = @"theme_color_label_light";
NSString *const THEME_COLOR_CELL_TITLE = @"theme_color_cell_title";
NSString *const THEME_COLOR_CELL_CONTENT = @"theme_color_cell_content";
NSString *const THEME_COLOR_CELL_BACKGROUND_DARK = @"theme_color_cell_background_dark";
NSString *const THEME_COLOR_CELL_BACKGROUND_LIGHT = @"theme_color_cell_background_light";
NSString *const THEME_COLOR_BUTTON_TEXT = @"theme_color_button_text";
NSString *const THEME_COLOR_BUTTON_BACKGROUND = @"theme_color_button_background";
NSString *const THEME_COLOR_MENU_BACKGROUND = @"theme_color_menu_background";
NSString *const THEME_COLOR_NAVIGATION_BAR_BACKGROUND = @"theme_color_navigation_bar_background";
NSString *const THEME_COLOR_NAVIGATION_ITEM_TINT = @"theme_color_navigation_item_tint";
NSString *const THEME_COLOR_TAB_BAR_TINT = @"theme_color_tab_bar_tint";
NSString *const THEME_COLOR_TAB_BAR_BACKGROUND = @"theme_color_tab_bar_background";
NSString *const THEME_COLOR_SEGMENT_BACKGROUND = @"theme_color_segment_background";
NSString *const THEME_COLOR_SEGMENT_BACKGROUND_SELECTED = @"theme_color_segment_background_selected";
NSString *const THEME_COLOR_SEGMENT_TEXT_SELECTED = @"theme_color_segment_text_selected";
NSString *const THEME_COLOR_SEGMENT_TEXT_NORMAL = @"theme_color_segment_text_normal";

@interface ThemeManager()
@property (nonatomic,copy) NSString *themeName;
@property (nonatomic,copy) NSString *theme;
@end
@implementation ThemeManager
@synthesize themeType = _themeType;
- (id)init{
    self = [super init];
    if (self) {
        if(self.themeType==ThemeTypeNight){
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        }else{
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        }
    }
    return self;
}
- (NSDictionary *)themesConfig{
    if(!_themesConfig){
        //初始化主题配置文件
        NSString *themePath = [[NSBundle mainBundle] pathForResource:@"theme/theme" ofType:@"plist"];
        _themesConfig = [NSDictionary dictionaryWithContentsOfFile:themePath];
    }
    return _themesConfig;
}
- (ThemeType)themeType{
    if([[[NSUserDefaults standardUserDefaults] valueForKey:KEY_THEME_NAME] isEqualToString:THEME_NIGHT]){
        return ThemeTypeNight;
    }else{
        return ThemeTypeDefault;
    }
}
- (void)setThemeType:(ThemeType)themeType{
    NSString *theme = (themeType==ThemeTypeNight)?THEME_NIGHT:THEME_DEFAULT;
    //保存主题到本地
    [[NSUserDefaults standardUserDefaults] setValue:theme forKey:KEY_THEME_NAME];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    if(themeType==ThemeTypeNight){
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    }else{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    }
    
    NSString *themePath = [self getThemePath];
    NSString *filePath = [themePath stringByAppendingPathComponent:@"ThemeColor.plist"];
    self.colorConfig = [NSDictionary dictionaryWithContentsOfFile:filePath];
    
    //发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_THEME_CHANGED object:theme];
    
}
//获取颜色配置
- (NSDictionary *)colorConfig{
    if(!_colorConfig){
        NSString *colorConfigPath = [[self getThemePath] stringByAppendingPathComponent:@"ThemeColor.plist"];
        NSLog(@"colorConfigPath:%@",colorConfigPath);
        _colorConfig = [NSDictionary dictionaryWithContentsOfFile:colorConfigPath];
    }
    return _colorConfig;
}

//获取当前主题包的目录
- (NSString *)getThemePath {
    
    //项目包的根路径
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *themeKey = [[NSUserDefaults standardUserDefaults] valueForKey:KEY_THEME_NAME];
    if(!themeKey){
        themeKey = @"default";
    }
    //取得当前主题的子路径:
    NSString *subPath = [self.themesConfig valueForKey:themeKey];
    //主题的完整路径
    NSString *path = [resourcePath stringByAppendingPathComponent:subPath];
    return path;
}

//获取当前主题下的图片
- (UIImage *)getThemeImageWithName:(NSString *)imageName {
    if (imageName.length == 0) {
        return nil;
    }
    //获取当前主题包的目录
    NSString *path = [self getThemePath];
    //imageName在当前主题的文件路径
    NSString *imagePath = [path stringByAppendingPathComponent:imageName];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    return image;
}

//返回当前主题下的颜色
- (UIColor *)getColorWithName:(NSString *)name {
//    if (name.length == 0) {
//        return nil;
//    }
    NSString *rgb = [self.colorConfig objectForKey:name];
//    NSArray *rgbs = [rgb componentsSeparatedByString:@","];
//    if (rgbs.count == 3) {
//        float r = [rgbs[0] floatValue];
//        float g = [rgbs[1] floatValue];
//        float b = [rgbs[2] floatValue];
//        UIColor *color = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1];
//        return color;
//    }
//    return nil;
    return [UIColor colorWithHexString:rgb];
}



#pragma mark public
+ (ThemeManager *)shareInstance {
    static ThemeManager *sharedInstance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

+ (UIColor *)themeColorWithKey:(NSString *)colorName{
    return  [[ThemeManager shareInstance]getColorWithName:colorName];
}
+ (UIImage *)themeImageWithKey:(NSString *)imageName {
    return  [[ThemeManager shareInstance]getThemeImageWithName:imageName];
}
@end
