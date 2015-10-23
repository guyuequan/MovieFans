//
//  RankListViewController.m
//  MovieFans
//
//  Created by Leo Gao on 15/9/7.
//  Copyright (c) 2015年 LeoCode. All rights reserved.
//

#import "RankListViewController.h"
#import "MovieCell.h"
#import "MovieDetailViewController.h"
#import "Movie.h"

@interface RankListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *movieModelArray;

@property (nonatomic,assign) NSInteger startNum;
@property (nonatomic,assign) NSInteger pageCount;

@property (nonatomic,strong) NSString *cachePath;
@property (nonatomic,assign) BOOL noMoreFlag;
@end

@implementation RankListViewController
#pragma - mark LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    __weak typeof(self) weakSelf = self;
    
    //只有top250和即将上映有更多数据
    if([self.urlPath isEqualToString:kUrlGetMoviesTop250]||[self.urlPath isEqualToString:kUrlGetMoviesComing]){
        //添加上拉加载更多
        [self.tableView addInfiniteScrollingWithActionHandler:^{
            weakSelf.startNum = [weakSelf.movieModelArray count];
            [weakSelf requestMovieListUseCache:NO];
        }];
    }
    //下拉刷新
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf initData];
        weakSelf.blankLabel.hidden = YES;
        [weakSelf.movieModelArray removeAllObjects];
        [weakSelf.tableView reloadData];
        [weakSelf requestMovieListUseCache:NO];
    }];
    
    //首次加载数据
    [self requestMovieListUseCache:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if([SVProgressHUD isVisible]){
        [SVProgressHUD dismiss];
    }
}

#pragma mark - Protocol
#pragma mark - Tableview Delegate
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return [MovieCell HeightOfCell];
//}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.movieModelArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellStr = @"_cell";
    MovieCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellStr];
    if(!cell){
        cell = [[MovieCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setDataModel:self.movieModelArray[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    MovieDetailViewController *detail = [[MovieDetailViewController alloc]init];
    MovieSimple *model = self.movieModelArray[indexPath.row];
    detail.movieId = model.movieID;
    detail.movieName = model.movieName;
    detail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark - Public

#pragma mark - Private
- (void)initData{
    _pageCount = 30;
    _startNum = 0;
    _noMoreFlag = NO;
}
- (void)requestMovieListUseCache:(BOOL)useCache{
    //加载更多数据失败后
    if(self.noMoreFlag){
        [self.tableView.infiniteScrollingView stopAnimating];
        [self.view.window makeToast:@"已经没有更多数据啦!" duration:2.f position:CSToastPositionBottom];
        return;
    }

    //首次加载，不是加载更多
    if(useCache){
        self.movieModelArray = [NSKeyedUnarchiver unarchiveObjectWithFile:self.cachePath];

        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = @"_yyyyMMdd";
        NSString *dateString = [formatter stringFromDate:[NSDate date]];
        NSString *cacheString = [[NSUserDefaults standardUserDefaults]valueForKey:[self.urlPath lastPathComponent]];

        if([self.movieModelArray count]>0&&[dateString isEqualToString:cacheString]){//有缓存 并且日期为当日
            [self.tableView reloadData];
        }else{
            [self.tableView.header beginRefreshing];
        }
        return;
    }
    
    NSDictionary *param = @{@"start":[NSNumber numberWithInteger:self.startNum],@"count":[NSNumber numberWithInteger:self.pageCount],@"apikey":kApiKey4Douban};
    NSInteger oldCount = [self.movieModelArray count];
    
    [[NetworkManager sharedManager] requestRankListWithParams:param path:self.urlPath andBlock:^(id data, NSError *error) {
        if(data){
            if([self.urlPath isEqualToString:kUrlGetMoviesNowPlaying]||[self.urlPath isEqualToString:kUrlGetMoviesComing]){
                NSArray *subjects = data[@"entries"];
                for(int i=0;i<[subjects count];i++){
                    MovieSimple *model = [MovieSimple new];
                    model.movieID = subjects[i][@"id"];
                    model.movieName = subjects[i][@"title"];
                    model.posterPathMedium = [subjects[i] valueForKeyPath:@"images.medium"];
                    model.posterPathLarge = [subjects[i] valueForKeyPath:@"images.large"];
                    model.pubDate = subjects[i][@"pubdate"];
                    model.wishSee = subjects[i][@"wish"];
                    model.rating = [subjects[i] valueForKey:@"rating"];
                    model.rank = [NSString stringWithFormat:@"%ld",[self.movieModelArray count]+1];
                    BOOL flag = NO;//是否已包含,因为接口请求页面数增加，不是返回空，而是返回重复数据
                    for(MovieSimple *m in self.movieModelArray){
                        if([m.movieID isEqualToString:model.movieID]){
                            flag = YES;
                        }
                    }
                    if(!flag){
                        [self.movieModelArray addObject:model];
                    }
                }
            }
            
            else if([self.urlPath isEqualToString:kUrlGetMoviesTop250]||[self.urlPath isEqualToString:kUrlGetMoviesNew]){
                NSArray *subjects = data[@"subjects"];
                for(int i=0;i<[subjects count];i++){
                    MovieSimple *model = [MovieSimple new];
                    model.movieID = subjects[i][@"id"];
                    model.movieName = subjects[i][@"title"];
                    model.rank = [NSString stringWithFormat:@"%ld",[self.movieModelArray count]+1];
                    model.posterPathMedium = [subjects[i] valueForKeyPath:@"images.medium"];
                    model.posterPathLarge = [subjects[i] valueForKeyPath:@"images.large"];
                    model.categoryArr = subjects[i][@"genres"];
                    model.year = subjects[i][@"year"];
                    model.rating = [subjects[i] valueForKeyPath:@"rating.average"];
                    
                    BOOL flag = NO;//是否已包含
                    for(MovieSimple *m in self.movieModelArray){
                        if([m.movieID isEqualToString:model.movieID]){
                            flag = YES;
                        }
                    }
                    if(!flag){
                        [self.movieModelArray addObject:model];
                    }
                }
            }else if([self.urlPath isEqualToString:kUrlGetMoviesUSBox]||[self.urlPath isEqualToString:kUrlGetMoviesWeekly]){
                NSArray *subjects = data[@"subjects"];
                for(int i=0;i<[subjects count];i++){
                    MovieSimple *model = [MovieSimple new];
                    model.movieID = [subjects[i] valueForKeyPath:@"subject.id"];
                    model.movieName = [subjects[i]valueForKeyPath:@"subject.title"];
                    model.rank = [NSString stringWithFormat:@"%ld",[self.movieModelArray count]+1];
                    model.posterPathMedium = [subjects[i] valueForKeyPath:@"subject.images.medium"];
                    model.posterPathLarge = [subjects[i] valueForKeyPath:@"subject.images.large"];
                    model.categoryArr = [subjects[i]valueForKeyPath:@"subject.genres"];
                    model.year = [subjects[i] valueForKeyPath:@"subject.year"];
                    model.rating = [subjects[i] valueForKeyPath:@"subject.rating.average"];
                    BOOL flag = NO;//是否已包含
                    for(MovieSimple *m in self.movieModelArray){
                        if([m.movieID isEqualToString:model.movieID]){
                            flag = YES;
                        }
                    }
                    if(!flag){
                        [self.movieModelArray addObject:model];
                    }
                }
            }
            [self.tableView.infiniteScrollingView stopAnimating];
            
            //是否加载了更多数据
            if([self.movieModelArray count]==oldCount){
                 [self.view.window makeToast:@"已经没有更多数据啦!" duration:2.f position:CSToastPositionBottom];
                _noMoreFlag = YES;
            }else{
                [self.tableView reloadData];
                [self cacheData];
            }
        }else{
            self.blankLabel.hidden = NO;
        }
        
        if([self.tableView.header isRefreshing]){
            [self.tableView.header endRefreshing];
        }
    }];
}
- (void)cacheData{
    //缓存
    BOOL flag = [NSKeyedArchiver archiveRootObject:self.movieModelArray toFile:self.cachePath];
    if(flag){
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = @"_yyyyMMdd";
        NSString *dateString = [formatter stringFromDate:[NSDate date]];
        [[NSUserDefaults standardUserDefaults]setValue:dateString forKey:[self.urlPath lastPathComponent]];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    NSLog(@"归档%@!!!",flag?@"成功":@"失败");
    NSLog(@"cache:%@",[[NSUserDefaults standardUserDefaults] valueForKey:[self.urlPath lastPathComponent]]);
}
#pragma mark - Custom Accessors
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0.f, 0.f, 0.f, 0.f)];
        _tableView.rowHeight = [MovieCell HeightOfCell];
//        if (isPad){
            _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        }
    }
    return _tableView;
}
- (NSMutableArray *)movieModelArray{
    if(!_movieModelArray){
        _movieModelArray = [NSMutableArray array];
    }
    return _movieModelArray;
}
- (NSString *)cachePath{
    if(!_cachePath){
        NSString *homeDictionary = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        _cachePath = [homeDictionary stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.archiver",[self.urlPath lastPathComponent]]];//添加储存的文件名
//        NSLog(@"path:%@",_cachePath);
    }
    return _cachePath;
}
@end
