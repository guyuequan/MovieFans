//
//  BaseViewController.m
//  Ban
//
//  Created by Leo Gao on 15/7/8.
//  Copyright (c) 2015年 LeoCode. All rights reserved.
//

#import "BaseViewController.h"
#import "MobClick.h"
@interface BaseViewController ()

@end

@implementation BaseViewController

#pragma - mark LifeCycle
- (instancetype)init{
    if(self = [super init]){
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.navigationController.navigationBar.translucent = NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.automaticallyAdjustsScrollViewInsets=NO;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeDidChangeNotification:) name:NOTICE_THEME_CHANGED object:nil];
    }
    return self;
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.blankLabel];
    self.blankLabel.hidden = YES;
    [self.blankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    
    [self applyTheme];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [MobClick beginLogPageView:[NSString stringWithUTF8String:object_getClassName(self)]];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if([SVProgressHUD isVisible]){
        [SVProgressHUD dismiss];
    }
//    [MobClick endLogPageView:[NSString stringWithUTF8String:object_getClassName(self)]];
}
#pragma mark - inherit
- (void)themeDidChangeNotification:(NSNotification *)notification{
    [self applyTheme];
}
- (void)applyTheme{
    self.view.backgroundColor = [ThemeManager themeColorWithKey:THEME_COLOR_VIEW_BACKGROUND];
    self.blankLabel.textColor = [ThemeManager themeColorWithKey:THEME_COLOR_LABEL_LIGHT];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (UILabel *)blankLabel{
    if(!_blankLabel){
        _blankLabel = [[UILabel alloc]init];
        _blankLabel.font = [UIFont systemFontOfSize:14.f];
        _blankLabel.numberOfLines = 0;
        _blankLabel.text = @"没有数据耶...";
        _blankLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _blankLabel;
}
@end
