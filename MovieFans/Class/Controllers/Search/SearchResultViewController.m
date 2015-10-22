//
//  SearchResultViewController.m
//  MovieFans
//
//  Created by Leo Gao on 15/9/8.
//  Copyright (c) 2015年 LeoCode. All rights reserved.
//

#import "SearchResultViewController.h"
#import "MovieCell.h"
#import "MovieDetailViewController.h"
#import "Movie.h"

@interface SearchResultViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *movieModelArray;

@property (nonatomic,copy) NSString *tag;
@property (nonatomic,copy) NSString *question;

@property (nonatomic,assign) NSInteger startNum;
@property (nonatomic,assign) NSInteger pageCount;

@property (nonatomic,assign) BOOL noMoreFlag;
@end

@implementation SearchResultViewController
#pragma - mark LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];

    _startNum = 0;
    _pageCount = 20;
    
    [self.view addSubview:self.tableView];
    self.tableView.userInteractionEnabled = NO;
    self.tableView.hidden = YES;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    __weak typeof(self) weakSelf = self;
    //添加上拉加载更多
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        weakSelf.startNum = [weakSelf.movieModelArray count];
        [weakSelf searchMoviesWithLoadMoreFlag:YES];
     }];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(self.pushFlag&&[self.movieModelArray count]==0){
        [SVProgressHUD showWithStatus:@""];
    }
}

#pragma mark - public

//这样设计是因为最初此VC是作为搜索页的子VC嵌入的。
- (void)loadDataWithTag:(NSString *)tag question:(NSString *)question{
    [self.view bringSubviewToFront:self.tableView];
    self.tableView.userInteractionEnabled = YES;
    self.tag = tag;
    self.question = question;
    [self.movieModelArray removeAllObjects];
    [self.tableView reloadData];
    
    //重新搜索时重置noMoreFlag
    _noMoreFlag = NO;
    [self searchMoviesWithLoadMoreFlag:NO];
}

#pragma mark - Private
- (void)searchMoviesWithLoadMoreFlag:(BOOL)moreflag{
    self.blankLabel.hidden = YES;
    
    //加载更多数据失败后
    if(self.noMoreFlag){
        [self.tableView.infiniteScrollingView stopAnimating];
        [self.view.window makeToast:@"已经没有更多数据啦!" duration:2.f position:CSToastPositionBottom];
        return;
    }
    //不是加载更多时
    if(!moreflag){
        [SVProgressHUD showWithStatus:@""];
        [self.movieModelArray removeAllObjects];
    }
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:[NSNumber numberWithInteger:self.startNum] forKey:@"start"];
    [params setValue:[NSNumber numberWithInteger:self.pageCount] forKey:@"count"];
    [params setValue:kApiKey4Douban forKey:@"apikey"];
    if(self.tag){
        [params setValue:self.tag forKey:@"tag"];
    }
    if(self.question){
        [params setValue:self.question forKey:@"q"];
    }
    
    [[NetworkManager sharedManager] searchMoviesWithParams:params andBlock:^(id data, NSError *error) {
        if([data isKindOfClass:[NSDictionary class]]){
            int count = 0;
            NSArray *subjects = data[@"subjects"];
            for(int i=0;i<[subjects count];i++){
                count++;
                MovieSimple *model = [MovieSimple new];
                model.movieID = subjects[i][@"id"];
                model.movieName = subjects[i][@"title"];
                model.rank = [NSString stringWithFormat:@"%ld",[self.movieModelArray count]+1];
                model.posterPathMedium = [subjects[i] valueForKeyPath:@"images.medium"];
                model.posterPathLarge = [subjects[i] valueForKeyPath:@"images.large"];
                model.categoryArr = subjects[i][@"genres"];
                model.year = subjects[i][@"year"];
                model.rating = [subjects[i] valueForKeyPath:@"rating.average"];
                
                [self.movieModelArray addObject:model];
            }
            if([SVProgressHUD isVisible]){
                [SVProgressHUD dismiss];
            }
            
            if(moreflag){
                [self.tableView.infiniteScrollingView stopAnimating];
            }
            //是否加载了更多数据
            if(count<self.pageCount){
                _noMoreFlag = YES;
            }
            if([self.movieModelArray count]>0){
                self.tableView.hidden = NO;
                [self.tableView reloadData];
            }else{
                self.blankLabel.hidden = NO;
            }
        }
    }];
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
    if(self.navigationController){
        [self.navigationController pushViewController:detail animated:YES];
    }else if([self.parentViewController navigationController]){
        [self.parentViewController.navigationController pushViewController:detail animated:YES];
    }
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
@end
