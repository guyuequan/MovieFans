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
@property (nonatomic,strong) ReviewListViewController *reviewList;
@property (nonatomic,strong) CommentsListViewController *commentList;

@end

@implementation ReviewViewController

#pragma - mark LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView = self.segment;
    _selectedSegmentIndex = 0;
    
    [self addChildViewController:self.reviewList];
    
    [self addChildViewController:self.commentList];
    self.commentList.view.frame = self.view.bounds;
    [self.view addSubview:self.commentList.view];
    
    
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
                [self.view bringSubviewToFront:self.commentList.view];
                self.commentList.view.hidden = NO;
                self.reviewList.view.hidden = YES;
            }
                break;
            case 1:
            {
                if(!self.reviewList.view.superview){
                    self.reviewList.view.frame = self.view.bounds;
                    [self.view addSubview:self.reviewList.view];
                }
                [self.view bringSubviewToFront:self.reviewList.view];
                self.commentList.view.hidden = YES;
                self.reviewList.view.hidden = NO;
            }
                break;
            default:
                break;
        }
        _selectedSegmentIndex = sender.selectedSegmentIndex;
    }
}
#pragma mark - Protocol

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
- (ReviewListViewController *)reviewList{
    if(!_reviewList){
        _reviewList = [[ReviewListViewController alloc]init];
        _reviewList.movieId = self.movieId;
        _reviewList.movieName = self.movieName;
    }
    return _reviewList;
}
- (CommentsListViewController *)commentList{
    if(!_commentList){
        _commentList = [[CommentsListViewController alloc]init];
        _commentList.movieId = self.movieId;
    }
    return _commentList;
}
@end
