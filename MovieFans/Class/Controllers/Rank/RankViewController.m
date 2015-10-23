//
//  RankViewController.m
//  MovieFans
//
//  Created by Leo Gao on 15/9/7.
//  Copyright (c) 2015年 LeoCode. All rights reserved.
//

#import "RankViewController.h"
#import "MenuLabel.h"
#import "RankListViewController.h"
#import "SettingViewController.h"

#define kMenuHeight 40.f


@interface RankViewController ()<UIScrollViewDelegate>
@property (nonatomic,strong) NSArray *menuArray;
@property (nonatomic,strong) NSArray *requestPathArray;

@property (nonatomic,strong) UIScrollView *menuScrollView;
@property (nonatomic,strong) UIScrollView *contentScrollView;
@property (nonatomic,strong) NSMutableArray *menuLabels;
@end

@implementation RankViewController

#pragma - mark LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"电影榜单";
    [self setupRightBarItem];
    
    [self.view addSubview:self.menuScrollView];
    [self.view addSubview:self.contentScrollView];
    
    [self.menuScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.leading.equalTo(self.view.mas_leading);
        make.trailing.equalTo(self.view.mas_trailing);
        make.height.mas_equalTo(kMenuHeight);
    }];
    [self.contentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.menuScrollView.mas_bottom);
        make.leading.equalTo(self.view.mas_leading);
        make.trailing.equalTo(self.view.mas_trailing);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    [self addMenus];
    [self addContentViewControllers];
    
    // 添加默认控制器
    RankListViewController *vc = [self.childViewControllers firstObject];
    vc.view.frame = self.contentScrollView.bounds;
    [self.contentScrollView addSubview:vc.view];
    //设置第一个menu选中高亮
    MenuLabel *label = [self.menuLabels firstObject];
    label.scale = 1.0;
}
#pragma mark - Private
- (void)setupRightBarItem{
    UIButton *faverBtn = [[UIButton alloc]initWithFrame:CGRectMake(0.f, 0.f, 20.f, 20.f)];
    faverBtn.tintColor = [UIColor whiteColor];
    [faverBtn setImage:[[UIImage imageNamed:@"setting" ] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [faverBtn addTarget:self action:@selector(settingBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:faverBtn];
}

- (void)settingBtnClicked:(UIButton *)sender{
    SettingViewController *settingVC = [[SettingViewController alloc]init];
    settingVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:settingVC animated:YES];
}
/** 添加子控制器 */
- (void)addContentViewControllers{
    for (int i=0 ; i<self.menuArray.count ;i++){
        RankListViewController *vc = [[RankListViewController alloc]init];
        vc.urlPath = self.requestPathArray[i];
        [self addChildViewController:vc];
    }
    self.contentScrollView.contentSize = CGSizeMake(kViewWidth*self.menuArray.count,0.f);
}
/** 添加菜单栏 */
- (void)addMenus{
    CGFloat horMargin = 30.f;
    CGFloat lblWidth;
    CGFloat originX = 0.f;
    TLabel *backView = [[TLabel alloc]init];
    backView.themeBackgroundColorKey = THEME_COLOR_MENU_BACKGROUND;
    [self.menuScrollView addSubview:backView];
    
    for (int i = 0; i < [self.menuArray count]; i++) {
        MenuLabel *lbl = [[MenuLabel alloc]init];
        lbl.text = self.menuArray[i];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.tag = i;
        [self.menuScrollView addSubview:lbl];
        
        //设置frame
        [lbl sizeToFit];
        lblWidth = lbl.frame.size.width+horMargin;
        lbl.frame = CGRectMake(originX,0.f,lblWidth,kMenuHeight);
        originX += lblWidth;
        
        //触摸事件
        lbl.userInteractionEnabled = YES;
        [lbl addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(menuClick:)]];
        
        [self.menuLabels addObject:lbl];
    }
    backView.frame = CGRectMake(0.f, 0.f,(originX+10.f)>kScreenWidth?(originX+10.f):kScreenWidth,kMenuHeight);
    self.menuScrollView.contentSize = CGSizeMake(originX+10.f,kMenuHeight);
}

- (void)menuClick:(UITapGestureRecognizer *)recognizer{
    MenuLabel *titlelabel = (MenuLabel *)recognizer.view;
    CGFloat offsetX = titlelabel.tag * self.contentScrollView.frame.size.width;
    CGFloat offsetY = self.contentScrollView.contentOffset.y;
    CGPoint offset = CGPointMake(offsetX, offsetY);
    
    [self.contentScrollView setContentOffset:offset animated:YES];
}

#pragma mark - Protocol

#pragma mark -UIScrollViewDelegate
/** 滚动结束后调用（代码导致） */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    // 获得索引
    NSUInteger index = scrollView.contentOffset.x / self.contentScrollView.frame.size.width;
    
    if(self.menuScrollView.contentSize.width>self.menuScrollView.frame.size.width){
        // 滚动标题栏
        MenuLabel *titleLabel = (MenuLabel *)self.menuLabels[index];
        
        CGFloat offsetx = titleLabel.center.x - self.menuScrollView.frame.size.width * 0.5;
        
        CGFloat offsetMax = self.menuScrollView.contentSize.width - self.menuScrollView.frame.size.width;
        if (offsetx < 0) {
            offsetx = 0;
        }else if (offsetx > offsetMax){
            offsetx = offsetMax;
        }
        
        CGPoint offset = CGPointMake(offsetx, self.menuScrollView.contentOffset.y);
        [self.menuScrollView setContentOffset:offset animated:YES];
        
        [self.menuLabels enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if (idx != index) {
                MenuLabel *temlabel = self.menuLabels[idx];
                temlabel.scale = 0.0;
            }
        }];
    }
    
    // 添加控制器
    RankListViewController *newsVc = self.childViewControllers[index];
    if (newsVc.view.superview) return;
    newsVc.view.frame = scrollView.bounds;
    [self.contentScrollView addSubview:newsVc.view];
}

/** 滚动结束（手势导致） */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

/** 正在滚动 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // 取出绝对值 避免最左边往右拉时形变超过1
    CGFloat value = ABS(scrollView.contentOffset.x / scrollView.frame.size.width);
    NSUInteger leftIndex = (int)value;
    NSUInteger rightIndex = leftIndex + 1;
    CGFloat scaleRight = value - leftIndex;
    
    CGFloat scaleLeft = 1 - scaleRight;
    MenuLabel *labelLeft = self.menuLabels[leftIndex];
    labelLeft.scale = scaleLeft;
    // 考虑到最后一个板块，如果右边已经没有板块了 就不在下面赋值scale了
    if (rightIndex < self.menuLabels.count) {
        MenuLabel *labelRight = self.menuLabels[rightIndex];
        labelRight.scale = scaleRight;
    }
    
}

#pragma mark - Custom Accessors
- (NSArray *)menuArray{
    if(!_menuArray){
        _menuArray = @[@"正在热映",@"本周口碑榜",@"新片榜",@"即将上映",@"北美票房榜",@"豆瓣Top250"];
    }
    return _menuArray;
}
- (NSArray *)requestPathArray{
    if(!_requestPathArray){
        _requestPathArray = @[kUrlGetMoviesNowPlaying,kUrlGetMoviesWeekly,kUrlGetMoviesNew,kUrlGetMoviesComing,kUrlGetMoviesUSBox,kUrlGetMoviesTop250];
    }
    return _requestPathArray;
}
- (UIScrollView *)menuScrollView{
    if(!_menuScrollView){
        _menuScrollView = [[UIScrollView alloc]init];
        _menuScrollView.showsHorizontalScrollIndicator = NO;
        _menuScrollView.showsVerticalScrollIndicator = NO;
        _menuScrollView.backgroundColor = [UIColor clearColor];
    }
    return _menuScrollView;
}
- (UIScrollView *)contentScrollView{
    if(!_contentScrollView){
        _contentScrollView = [[UIScrollView alloc]init];
        _contentScrollView.showsHorizontalScrollIndicator = NO;
        _contentScrollView.showsVerticalScrollIndicator = NO;
        _contentScrollView.pagingEnabled = YES;
        _contentScrollView.delegate = self;
        _contentScrollView.bounces = NO;
    }
    return _contentScrollView;
}
- (NSMutableArray *)menuLabels{
    if(!_menuLabels){
        _menuLabels = [NSMutableArray array];
    }
    return _menuLabels;
}
@end
