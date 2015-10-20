//
//  MovieCollectionViewController.m
//  MovieFans
//
//  Created by Leo Gao on 15/9/16.
//  Copyright (c) 2015年 LeoCode. All rights reserved.
//

#import "MovieCollectionViewController.h"
#import "Movie.h"
#import "MovieDetailViewController.h"
#import "CoverCell.h"

#define kCellMargin 5.f
#define kCollectionMargin 15.f
@interface MovieCollectionViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,CoverCellDelegate>

@property (nonatomic,strong) NSMutableArray *movies;
@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,assign) BOOL showDeleteFlag;
@end

@implementation MovieCollectionViewController

#pragma - mark LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self loadData];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadData) name:NOTICE_COLLECTION_DATA_CHANGED object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(resetShowDeleteFlag) name:NOTICE_COLLECTION_DATA_END_EDIT object:nil];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
#pragma mark - Public

#pragma mark - Private
- (void)loadData{
    [SVProgressHUD showWithStatus:@""];
    [self.movies removeAllObjects];
    [self.collectionView reloadData];
    self.collectionView.hidden = YES;
    
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *array = [[DBUtil sharedUtil] getAllItemsFromTable:TABLE_MOVIE];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            YTKKeyValueItem *item = array[idx];
            if(item.itemObject){
                Movie *movie = [MTLJSONAdapter modelOfClass:[Movie class] fromJSONDictionary:item.itemObject error:nil];
                [self.movies addObject:movie];
            }
        }];
        if([self.movies count]==0){
            self.blankLabel.hidden = NO;
        }else{
            self.blankLabel.hidden = YES;
            self.collectionView.hidden = NO;
            [self.collectionView reloadData];
        }
        [SVProgressHUD dismiss];
    });
}

-(void)longPressToDo:(UILongPressGestureRecognizer *)gesture{
    if(gesture.state == UIGestureRecognizerStateBegan){
        
        if(self.showDeleteFlag){
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTICE_COLLECTION_DATA_END_EDIT object:nil];
            return;
        }
        CGPoint point = [gesture locationInView:self.collectionView];
        NSIndexPath * indexPath = [self.collectionView indexPathForItemAtPoint:point];
        if(indexPath){
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTICE_COLLECTION_DATA_BEGIN_EDIT object:nil];
            self.showDeleteFlag = YES;
        };
    }
}
- (void)resetShowDeleteFlag{
    self.showDeleteFlag = NO;
}
#pragma mark - Protocol
#pragma mark UICollectionViewDelegate/UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.movies count];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CoverCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([self class]) forIndexPath:indexPath];
    cell.delegate = self;
    Movie *m = self.movies[indexPath.row];
    [cell setCoverUrlPath:[m.images large] showDelegateFlag:self.showDeleteFlag];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if(self.showDeleteFlag){
        return;
    }
    MovieDetailViewController *detailVC = [[MovieDetailViewController alloc]initWithMovieModel:self.movies[indexPath.row]];
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark CoverCellDelegate
- (void)CoverCell:(CoverCell *)cell deleteViewTapped:(UITapGestureRecognizer *)tap{
    CGPoint point = [tap locationInView:self.collectionView];
    NSIndexPath * indexPath = [self.collectionView indexPathForItemAtPoint:point];
    if(indexPath){
        Movie *m = [self.movies objectAtIndex:indexPath.row];
        [[DBUtil sharedUtil] deleteObjectById:m.mId fromTable:TABLE_MOVIE];
        [self.movies removeObjectAtIndex:indexPath.row];
        [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
        
        if([self.movies count]==0){
            self.blankLabel.hidden = NO;
            self.collectionView.hidden = YES;
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTICE_COLLECTION_DATA_END_EDIT object:nil];
        }else{
            self.blankLabel.hidden = YES;
            self.collectionView.hidden = NO;
        }
    }
}
#pragma mark - Custom Accessors

- (UICollectionView *)collectionView{
    if(!_collectionView){
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.minimumLineSpacing = kCellMargin;
        flowLayout.minimumInteritemSpacing = kCellMargin;
        flowLayout.sectionInset = UIEdgeInsetsMake(kCollectionMargin, kCollectionMargin, kCollectionMargin, kCollectionMargin);
        NSInteger columnNum = 4;
        if (isPad){
            columnNum = 6;
        }
        CGFloat itemWidth = (kViewWidth-kCellMargin*(columnNum-1)-kCollectionMargin*2)/columnNum;
        flowLayout.itemSize = CGSizeMake(itemWidth,itemWidth*1.5);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[CoverCell class] forCellWithReuseIdentifier:NSStringFromClass([self class])];
        
        UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
        longPressGr.minimumPressDuration = 0.5;
        [_collectionView addGestureRecognizer:longPressGr];

    }
    return _collectionView;
}
- (NSMutableArray *)movies{
    if(!_movies){
        _movies = [NSMutableArray array];
    }
    return _movies;
}
@end
