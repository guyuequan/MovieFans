//
//  RootTabViewController.m
//  Ban
//
//  Created by Leo Gao on 15/7/8.
//  Copyright (c) 2015年 LeoCode. All rights reserved.
//

#import "RootTabViewController.h"
#import "RankViewController.h"
#import "SettingViewController.h"
#import "SearchViewController.h"
#import "CollectionViewController.h"

@interface RootTabViewController ()

@end

@implementation RootTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViewControllers];

    [self applyTheme];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeDidChangeNotification:) name:NOTICE_THEME_CHANGED object:nil];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupViewControllers {
    
    RankViewController *rankVC = [[RankViewController alloc] init];
    MyNavigationViewController *rankNav = [[MyNavigationViewController alloc]initWithRootViewController:rankVC];
    rankNav.tabBarItem.title = @"榜单";
    rankNav.tabBarItem.image = [UIImage imageNamed:@"hot_rank"];
    
    SearchViewController *searchVC = [[SearchViewController alloc] init];
    MyNavigationViewController *searchNav = [[MyNavigationViewController alloc]initWithRootViewController:searchVC];
    searchNav.tabBarItem.title = @"搜索";
    searchNav.tabBarItem.image = [UIImage imageNamed:@"search"];
    
    CollectionViewController *collectionVC = [[CollectionViewController alloc]init];
    MyNavigationViewController *collectionNav = [[MyNavigationViewController alloc]initWithRootViewController:collectionVC];
    collectionNav.tabBarItem.title = @"收藏";
    collectionNav.tabBarItem.image = [UIImage imageNamed:@"star"];
    
//    SettingViewController *setVC = [[SettingViewController alloc] init];
//    MyNavigationViewController *settingNav = [[MyNavigationViewController alloc]initWithRootViewController:setVC];
//    settingNav.tabBarItem.title = @"设置";
//    settingNav.tabBarItem.image = [UIImage imageNamed:@"setting"];
    
    self.viewControllers = @[rankNav,searchNav,collectionNav];

    self.selectedIndex = 0;
}

#pragma mark - UpdateThemeProtocol
- (void)applyTheme {
    //    [self.navigationBar setBackgroundImage:[UIImage imageWithColor:[ThemeManager themeColorWithKey:THEME_COLOR_NAVIGATION_BAR_BACKGROUND]] forBarMetrics:UIBarMetricsDefault];
    [self.tabBar setBackgroundColor:[ThemeManager themeColorWithKey:THEME_COLOR_TAB_BAR_BACKGROUND]];
    [self.tabBar setBarTintColor:[ThemeManager themeColorWithKey:THEME_COLOR_TAB_BAR_BACKGROUND]];
    [self.tabBar setTintColor:[ThemeManager themeColorWithKey:THEME_COLOR_TAB_BAR_TINT]];
}

#pragma mark - pravite
- (void)themeDidChangeNotification:(NSNotification *)notification {
    [self applyTheme];
}
@end
