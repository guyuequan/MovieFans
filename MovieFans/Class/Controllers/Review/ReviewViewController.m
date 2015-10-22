//
//  ReviewViewController.m
//  MovieFans
//
//  Created by Leo Gao on 15/9/12.
//  Copyright (c) 2015年 LeoCode. All rights reserved.
//

#import "ReviewViewController.h"
#import "ReviewListViewController.h"
#import "CommentsListViewController.h"

@interface ReviewViewController ()
@property (nonatomic,strong) TSegmentedControl *segment;
@property (nonatomic,assign) NSInteger selectedSegmentIndex;
@property (nonatomic,strong) ReviewListViewController *reviewListVC;
@property (nonatomic,strong) CommentsListViewController *commentListVC;

@end

@implementation ReviewViewController

#pragma - mark LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView = self.segment;
    _selectedSegmentIndex = 0;
    
    //长评
    [self addChildViewController:self.reviewListVC];
    
    //添加短评
    [self addChildViewController:self.commentListVC];
    self.commentListVC.view.frame = self.view.bounds;
    [self.view addSubview:self.commentListVC.view];
    
}

#pragma mark - Public

#pragma mark - Private
- (void)segmentSelected:(UISegmentedControl*)sender{
    if(sender.selectedSegmentIndex == _selectedSegmentIndex){
        return;
    }else{
        switch (sender.selectedSegmentIndex) {
            case 0:
            {
                [self.view bringSubviewToFront:self.commentListVC.view];
                self.commentListVC.view.hidden = NO;
                self.reviewListVC.view.hidden = YES;
            }
                break;
            case 1:
            {
                if(!self.reviewListVC.view.superview){
                    self.reviewListVC.view.frame = self.view.bounds;
                    [self.view addSubview:self.reviewListVC.view];
                }
                [self.view bringSubviewToFront:self.reviewListVC.view];
                self.commentListVC.view.hidden = YES;
                self.reviewListVC.view.hidden = NO;
            }
                break;
            default:
                break;
        }
        _selectedSegmentIndex = sender.selectedSegmentIndex;
    }
}
#pragma mark - Custom Accessors

-(UISegmentedControl *)segment{
    if(!_segment){
        _segment = [[TSegmentedControl alloc]initWithItems:@[@"短评",@"影评"]];
        _segment.frame = CGRectMake(0.f,0.f,200.f,25.f);
        _segment.selectedSegmentIndex = 0;
        _segment.layer.cornerRadius = 0.f;
//        [_segment setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor orangeColor]} forState:UIControlStateSelected];
//        [_segment setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor darkGrayColor]} forState:UIControlStateNormal];
        _segment.themeTitleNormalColorKey = THEME_COLOR_SEGMENT_TEXT_NORMAL;
        _segment.themeTitleSelectedColorKey = THEME_COLOR_SEGMENT_TEXT_SELECTED;
        _segment.themeBackgroundSelectedColorKey = THEME_COLOR_SEGMENT_BACKGROUND_SELECTED;
        [_segment addTarget:self action:@selector(segmentSelected:) forControlEvents:UIControlEventValueChanged];
    }
    return _segment;
}
- (ReviewListViewController *)reviewListVC{
    if(!_reviewListVC){
        _reviewListVC = [[ReviewListViewController alloc]init];
        _reviewListVC.movieId = self.movieId;
        _reviewListVC.movieName = self.movieName;
    }
    return _reviewListVC;
}
- (CommentsListViewController *)commentListVC{
    if(!_commentListVC){
        _commentListVC = [[CommentsListViewController alloc]init];
        _commentListVC.movieId = self.movieId;
    }
    return _commentListVC;
}
@end
