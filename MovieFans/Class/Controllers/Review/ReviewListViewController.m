//
//  ReviewListViewController.m
//  MovieFans
//
//  Created by Leo Gao on 15/9/11.
//  Copyright (c) 2015年 LeoCode. All rights reserved.
//

#import "ReviewListViewController.h"
#import "ReviewCell.h"
#import "ReviewDetailViewController.h"

@interface ReviewListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,assign) NSInteger startNum;
@property (nonatomic,assign) NSInteger pageCount;
@property (nonatomic,strong) NSMutableArray *reviewsArray;
@property (nonatomic,assign) BOOL noMoreFlag;

@property (nonatomic,strong) UITableView *tableView;
@end

@implementation ReviewListViewController

#pragma - mark LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _startNum = 0;
    _pageCount = 20;
    _noMoreFlag = NO;
    
    [self.view addSubview:self.tableView];
    self.tableView.hidden = YES;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    

    //添加上拉加载更多
    __weak typeof(self) weakSelf = self;
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf requestCommentsWithLoadMoreFlag:YES];
    }];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if([self.reviewsArray count]==0){
        [self requestCommentsWithLoadMoreFlag:NO];
    }
}

#pragma mark - private
- (void)requestCommentsWithLoadMoreFlag:(BOOL)moreFlag{
    //加载更多数据失败后
    if(self.noMoreFlag){
        [self.tableView.infiniteScrollingView stopAnimating];
        [self.view.window makeToast:@"已经没有更多数据啦!" duration:2.f position:CSToastPositionBottom];
        return;
    }
    //首次加载，不是加载更多
    if(!moreFlag){
        [SVProgressHUD showWithStatus:@""];
        [self.reviewsArray removeAllObjects];
    }
    if(self.movieId){
        [[NetworkManager sharedManager] requestMovieReviewsWithParams:@{@"apikey":kApiKey4Douban,@"start":[NSNumber numberWithInteger:self.startNum],@"count":[NSNumber numberWithInteger:self.pageCount]} movieId:self.movieId andBlock:^(id data, NSError *error) {
            if([SVProgressHUD isVisible]){
                [SVProgressHUD dismiss];
            }
            if(moreFlag){
                [self.tableView.infiniteScrollingView stopAnimating];
            }
            if([data isKindOfClass:[NSDictionary class]]){
                self.startNum = [data[@"next_start"] integerValue];
                NSArray *reviews = data[@"reviews"];
                
               [self.reviewsArray addObjectsFromArray:[MTLJSONAdapter modelsOfClass:[Review class] fromJSONArray:reviews error:nil]];
                
                //是否加载了更多数据
                if([reviews count]<self.pageCount){
                    _noMoreFlag = YES;
                    self.blankLabel.hidden = NO;
                     self.tableView.hidden = YES;
                }
                if([self.reviewsArray count]>0){
                    self.tableView.hidden = NO;
                    self.blankLabel.hidden = YES;
                    [self.tableView reloadData];
                }
            }
        }];
    }
}
#pragma mark - Protocol
#pragma mark  UITableViewDataSource/UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.reviewsArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0.f;
    if(indexPath.row<[self.reviewsArray count]){
        Review *review = self.reviewsArray[indexPath.row];
        height = [ReviewCell heightWithTitle:review.title];
    }
    return  height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ReviewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"review_Cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.review = self.reviewsArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [MobClick event:@"UMEVentClickReviewDetial"];
    
    ReviewDetailViewController *detailVC = [[ReviewDetailViewController alloc]init];
    detailVC.review = self.reviewsArray[indexPath.row];
    detailVC.title = self.movieName;
    [self.navigationController pushViewController:detailVC animated:YES];
}
#pragma mark - Custom Accessors
- (NSMutableArray *)reviewsArray{
    if(!_reviewsArray){
        _reviewsArray = [NSMutableArray array];
    }
    return  _reviewsArray;
}
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[ReviewCell class] forCellReuseIdentifier:@"review_Cell"];
        _tableView.tableFooterView = [UIView new];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
@end
