//
//  CollectionViewController.m
//  MovieFans
//
//  Created by Leo Gao on 15/9/17.
//  Copyright (c) 2015年 LeoCode. All rights reserved.
//

#import "CollectionViewController.h"
#import "MovieCollectionViewController.h"
#import "ReviewCollectionViewController.h"
#import "CelebrityCollectionViewController.h"
#import "TSegmentedControl.h"

@interface CollectionViewController ()
@property (nonatomic,strong) TSegmentedControl *segment;
@property (nonatomic,assign) NSInteger selectedSegmentIndex;
@property (nonatomic,strong) MovieCollectionViewController *movieListVC;
@property (nonatomic,strong) ReviewCollectionViewController *reviewListVC;
@property (nonatomic,strong) CelebrityCollectionViewController *celebrityListVC;
@end

@implementation CollectionViewController
#pragma - mark LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showDoneBtn) name:NOTICE_COLLECTION_DATA_BEGIN_EDIT object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hideDoneBtn) name:NOTICE_COLLECTION_DATA_END_EDIT object:nil];
    
    self.navigationItem.titleView = self.segment;
    _selectedSegmentIndex = 0;
    
    self.reviewListVC = [[ReviewCollectionViewController alloc]init];
    [self addChildViewController:self.reviewListVC];
    
    self.celebrityListVC = [[CelebrityCollectionViewController alloc]init];
    [self addChildViewController:self.celebrityListVC];
    
    self.movieListVC = [[MovieCollectionViewController alloc]init];
    [self addChildViewController:self.movieListVC];
    self.movieListVC.view.frame = self.view.bounds;
    [self.view addSubview:self.movieListVC.view];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [self endEdit];
    [super viewWillDisappear:animated];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
#pragma mark - Public

#pragma mark - Private
- (void)segmentSelected:(UISegmentedControl*)sender{
    if(sender.selectedSegmentIndex == _selectedSegmentIndex){
        return;
    }else{
        [self endEdit];
        switch (sender.selectedSegmentIndex) {
            case 0:
            {
                [self.view bringSubviewToFront:self.movieListVC.view];
            }
                break;
            case 1:
            {
                if(!self.celebrityListVC.view.superview){
                    self.celebrityListVC.view.frame = self.view.bounds;
                    [self.view addSubview:self.celebrityListVC.view];
                }
                [self.view bringSubviewToFront:self.celebrityListVC.view];

            }
                break;
            case 2:
            {
                if(!self.reviewListVC.view.superview){
                    self.reviewListVC.view.frame = self.view.bounds;
                    [self.view addSubview:self.reviewListVC.view];
                }
                [self.view bringSubviewToFront:self.reviewListVC.view];
                
            }
                break;
            default:
                break;
        }
        _selectedSegmentIndex = sender.selectedSegmentIndex;
    }
}

- (void)endEdit{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_COLLECTION_DATA_END_EDIT object:nil];
}
- (void)showDoneBtn{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(endEdit)];
}
- (void)hideDoneBtn{
    self.navigationItem.rightBarButtonItem = nil;
}
#pragma mark - Protocol

#pragma mark - Custom Accessors

-(UISegmentedControl *)segment{
    if(!_segment){
        _segment = [[TSegmentedControl alloc]initWithItems:@[@"影片",@"影人",@"影评"]];
        _segment.frame = CGRectMake(0.f,0.f,230.f,25.f);
        _segment.selectedSegmentIndex = 0;
        _segment.layer.cornerRadius = 0.f;
        
        _segment.themeTitleNormalColorKey = THEME_COLOR_SEGMENT_TEXT_NORMAL;
        _segment.themeTitleSelectedColorKey = THEME_COLOR_SEGMENT_TEXT_SELECTED;
        _segment.themeBackgroundSelectedColorKey = THEME_COLOR_SEGMENT_BACKGROUND_SELECTED;
        [_segment addTarget:self action:@selector(segmentSelected:) forControlEvents:UIControlEventValueChanged];
    }
    return _segment;
}
@end
