//
//  MyNavigationViewController.h
//  Ban
//
//  Created by Leo Gao on 15/7/8.
//  Copyright (c) 2015年 LeoCode. All rights reserved.
//

#import "MyNavigationViewController.h"
#import "ThemeManager.h"

@interface MyNavigationViewController ()

@end

@implementation MyNavigationViewController
- (instancetype)init{
    if(self = [super init]){
    }
    return self;
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad{
    [super viewDidLoad];
    self.navigationBar.translucent = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeDidChangeNotification:) name:NOTICE_THEME_CHANGED object:nil];
    [self applyTheme];
}
#pragma mark - UpdateThemeProtocol
- (void)applyTheme {
    [self.navigationBar setBackgroundImage:[UIImage imageWithColor:[ThemeManager themeColorWithKey:THEME_COLOR_NAVIGATION_BAR_BACKGROUND]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setBarTintColor:[ThemeManager themeColorWithKey:THEME_COLOR_NAVIGATION_ITEM_TINT]];
    [self.navigationBar setTintColor:[ThemeManager themeColorWithKey:THEME_COLOR_NAVIGATION_ITEM_TINT]];
    UIColor *color = [ThemeManager themeColorWithKey:THEME_COLOR_NAVIGATION_ITEM_TINT];
    if(color){
        [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[ThemeManager themeColorWithKey:THEME_COLOR_NAVIGATION_ITEM_TINT]}];
    }
}
- (BOOL)shouldAutorotate{
    return [self.visibleViewController shouldAutorotate];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return [self.visibleViewController preferredInterfaceOrientationForPresentation];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [self.visibleViewController supportedInterfaceOrientations];
}

#pragma mark - pravite

- (void)themeDidChangeNotification:(NSNotification *)notification {
    [self applyTheme];
}
@end
