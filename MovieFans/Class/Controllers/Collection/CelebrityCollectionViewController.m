//
//  CelebrityCollectionViewController.m
//  MovieFans
//
//  Created by Leo Gao on 15/9/22.
//  Copyright © 2015年 LeoCode. All rights reserved.
//

#import "CelebrityCollectionViewController.h"
#import "Celebrity.h"
#import "CelebrityViewController.h"
#import "CoverCell.h"

#define kCellMargin 5.f
#define kCollectionMargin 15.f

@interface CelebrityCollectionViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,CoverCellDelegate>

@property (nonatomic,strong) NSMutableArray *celebrities;
@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,assign) BOOL showDeleteFlag;
@end

@implementation CelebrityCollectionViewController

#pragma - mark LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [SVProgressHUD showWithStatus:@""];
    [self loadData];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadData) name:NOTICE_COLLECTION_DATA_CHANGED object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(resetShowDeleteFlag) name:NOTICE_COLLECTION_DATA_END_EDIT object:nil];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
#pragma mark - Private
- (void)loadData{
    [self.celebrities removeAllObjects];
    [self.collectionView reloadData];
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        NSArray *array = [[DBUtil sharedUtil] getAllItemsFromTable:TABLE_CELEBRITY];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            YTKKeyValueItem *item = array[idx];
            if(item.itemObject){
                Celebrity *celebirty = [MTLJSONAdapter modelOfClass:[Celebrity class] fromJSONDictionary:item.itemObject error:nil];
                [self.celebrities addObject:celebirty];
            }
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            if([self.celebrities count]==0){
                self.blankLabel.hidden = NO;
            }else{
                self.blankLabel.hidden = YES;
                [self.collectionView reloadData];
            }
            if([SVProgressHUD isVisible]){
                [SVProgressHUD dismiss];
            }
        });
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
#pragma mark - UICollectionViewDelegate/UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.celebrities count];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CoverCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([self class]) forIndexPath:indexPath];
    cell.delegate = self;
    Celebrity *celebrity = self.celebrities[indexPath.row];
    [cell setCoverUrlPath:[celebrity.avatars large] showDelegateFlag:self.showDeleteFlag];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(self.showDeleteFlag){
        return;
    }
    Celebrity *celebrity = self.celebrities[indexPath.row];
    CelebrityViewController *celebrityVC = [[CelebrityViewController alloc]initWithCelebrity:celebrity];
    celebrityVC.title = celebrity.name;
    celebrityVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:celebrityVC animated:YES];
}
#pragma mark CoverCellDelegate
- (void)coverCell:(CoverCell *)cell deleteViewTapped:(UITapGestureRecognizer *)tap{
    CGPoint point = [tap locationInView:self.collectionView];
    NSIndexPath * indexPath = [self.collectionView indexPathForItemAtPoint:point];
    if(indexPath){
        Celebrity *c = [self.celebrities objectAtIndex:indexPath.row];
        [[DBUtil sharedUtil] deleteObjectById:c.cId fromTable:TABLE_CELEBRITY];
        [self.celebrities removeObjectAtIndex:indexPath.row];
        [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
        
        if([self.celebrities count]==0){
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
        longPressGr.minimumPressDuration = 1.0;
        [_collectionView addGestureRecognizer:longPressGr];

    }
    return _collectionView;
}
- (NSMutableArray *)celebrities{
    if(!_celebrities){
        _celebrities = [NSMutableArray array];
    }
    return _celebrities;
}
@end
