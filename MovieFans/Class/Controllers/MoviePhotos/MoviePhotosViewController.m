//
//  MoviePhotosViewController.m
//  MovieFans
//
//  Created by Leo Gao on 15/9/13.
//  Copyright (c) 2015年 LeoCode. All rights reserved.
//

#import "MoviePhotosViewController.h"
#import "MWPhotoBrowser.h"
#import "Photo.h"

#define kCellMargin 5.f
#define kCollectionMargin 10.f
#define kCellIdentify @"cell_identify"
@interface MoviePhotosViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,MWPhotoBrowserDelegate>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *photos;
@property (nonatomic,strong) NSMutableArray *photosArray;

@property (nonatomic,assign) NSInteger startNum;
@property (nonatomic,assign) NSInteger pageCount;
@end

@implementation MoviePhotosViewController

#pragma - mark LifeCycle

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if([self.photos count]==0){
        [self requestPhotos];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _startNum = 0;
    _pageCount = 50;
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - Public

#pragma mark - Private
- (void)requestPhotos{
    if(!self.movieId&&!self.celebrityId){
        return;
    }
    
    [SVProgressHUD showWithStatus:@""];
    [self.photos removeAllObjects];
    [self.photosArray removeAllObjects];

    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:[NSNumber numberWithInteger:self.startNum] forKey:@"start"];
    [params setValue:[NSNumber numberWithInteger:self.pageCount] forKey:@"count"];
    [params setValue:kApiKey4Douban forKey:@"apikey"];
    
    if(self.movieId){
        [[NetworkManager sharedManager] requestMoviePhotosWithParams:params movieId:self.movieId andBlock:^(id data, NSError *error) {
            if([data isKindOfClass:[NSDictionary class]]){
                int count = 0;
                NSArray *photos = data[@"photos"];
                for(int i=0;i<[photos count];i++){
                    count++;
                    Photo *photo = [MTLJSONAdapter modelOfClass:[Photo class] fromJSONDictionary:photos[i] error:nil];
                    if(photo){
                        [self.photos addObject:photo];
                        [self.photosArray addObject:[MWPhoto photoWithURL:[NSURL URLWithString:photo.image]]];
                    }
                }
                [SVProgressHUD dismiss];
                if([self.photos count]==0){
                    self.blankLabel.hidden = NO;
                    self.collectionView.hidden = YES;
                }
                [self.collectionView reloadData];
            }
        }];

    }else if(self.celebrityId){
        [[NetworkManager sharedManager] requestMoviePhotosWithParams:params celebrityId:self.celebrityId andBlock:^(id data, NSError *error) {
            if([data isKindOfClass:[NSDictionary class]]){
                int count = 0;
                NSArray *photos = data[@"photos"];
                for(int i=0;i<[photos count];i++){
                    count++;
                    Photo *photo = [MTLJSONAdapter modelOfClass:[Photo class] fromJSONDictionary:photos[i] error:nil];
                    if(photo){
                        [self.photos addObject:photo];
                        [self.photosArray addObject:[MWPhoto photoWithURL:[NSURL URLWithString:photo.image]]];
                    }
                }
                [SVProgressHUD dismiss];
                if([self.photos count]==0){
                    self.blankLabel.hidden = NO;
                    self.collectionView.hidden = YES;
                }
                [self.collectionView reloadData];
            }
        }];
    }
}
#pragma mark - Protocol
#pragma mark - UICollectionViewDelegate/UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.photos count];
}
//每个UICollectionView展示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentify forIndexPath:indexPath];
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.f, 0.f, cell.contentView.bounds.size.width, cell.contentView.bounds.size.height)];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    [imageView sd_setImageWithURL:[NSURL URLWithString:[self.photos[indexPath.row] valueForKey:@"thumb"]] placeholderImage:[UIImage imageNamed:@"poster_default"]];
    [cell.contentView addSubview:imageView];
    return cell;
    
}
//UICollectionView被选中时调用的方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0){
        
        BOOL displayActionButton = YES;
        BOOL displaySelectionButtons = NO;
        BOOL displayNavArrows = NO;
        BOOL enableGrid = NO;
        BOOL startOnGrid = NO;
        BOOL autoPlayOnAppear = NO;

        MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        browser.displayActionButton = displayActionButton;
        browser.displayNavArrows = displayNavArrows;
        browser.displaySelectionButtons = displaySelectionButtons;
        browser.alwaysShowControls = displaySelectionButtons;
        browser.zoomPhotosToFill = YES;
        browser.enableGrid = enableGrid;
        browser.startOnGrid = startOnGrid;
        browser.enableSwipeToDismiss = NO;
        browser.autoPlayOnAppear = autoPlayOnAppear;
        [browser setCurrentPhotoIndex:indexPath.row];
        [self.navigationController pushViewController:browser animated:YES];
    }
}
//返回这个UICollectionView是否可以被选择
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.photosArray.count;
}
- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < self.photosArray.count)
        return [self.photosArray objectAtIndex:index];
    return nil;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
    if (index < self.photosArray.count)
        return [self.photosArray objectAtIndex:index];
    return nil;
}
- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Custom Accessors
- (UICollectionView *)collectionView{
    if(!_collectionView){
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.minimumLineSpacing = kCellMargin;
        flowLayout.minimumInteritemSpacing = kCellMargin;
        flowLayout.sectionInset = UIEdgeInsetsMake(kCollectionMargin, kCollectionMargin, kCollectionMargin, kCollectionMargin);
        NSInteger columnNum = 3;
        if (isPad){
            columnNum = 5;
        }
        CGFloat itemWidth = (kViewWidth-kCellMargin*(columnNum-1)-kCollectionMargin*2)/columnNum;
        flowLayout.itemSize = CGSizeMake(itemWidth,itemWidth*0.8);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kCellIdentify];
    }
    return _collectionView;
}
- (NSMutableArray *)photos{
    if(!_photos){
        _photos = [NSMutableArray array];
    }
    return _photos;
}
- (NSMutableArray *)photosArray{
    if(!_photosArray){
        _photosArray = [NSMutableArray array];
    }
    return _photosArray;
}

@end
