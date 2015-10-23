//
//  CommentsListViewController.m
//  MovieFans
//
//  Created by Leo Gao on 15/9/12.
//  Copyright (c) 2015年 LeoCode. All rights reserved.
//

#import "CommentsListViewController.h"
#import "CommentCell.h"

@interface CommentsListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,assign) NSInteger startNum;
@property (nonatomic,assign) NSInteger pageCount;
@property (nonatomic,assign) BOOL noMoreFlag;
@property (nonatomic,strong) NSMutableArray *commentsArray;
@property (nonatomic,strong) UITableView *tableView;
@end

@implementation CommentsListViewController

#pragma - mark LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _startNum = 0;
    _pageCount = 20;
    _noMoreFlag = NO;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    

    
    //添加上拉加载更多
    __weak typeof(self) weakSelf = self;
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        weakSelf.startNum = [weakSelf.commentsArray count];
        [weakSelf requestCommentsWithLoadMoreFlag:YES];
    }];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if([self.commentsArray count]==0){
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
        [self.commentsArray removeAllObjects];
    }
    if(self.movieId){
        [[NetworkManager sharedManager] requestMovieCommentsWithParams:@{@"apikey":kApiKey4Douban,@"start":[NSNumber numberWithInteger:self.startNum],@"count":[NSNumber numberWithInteger:self.pageCount]} movieId:self.movieId andBlock:^(id data, NSError *error) {
            if([SVProgressHUD isVisible]){
                [SVProgressHUD dismiss];
            }
            if(moreFlag){
                [self.tableView.infiniteScrollingView stopAnimating];
            }
            if([data isKindOfClass:[NSDictionary class]]){
                NSArray *comments = data[@"comments"];
                //是否加载了更多数据
                if([comments count]<self.pageCount){
                    _noMoreFlag = YES;
                    self.blankLabel.hidden = NO;
                    self.tableView.hidden = YES;
                }
                [self.commentsArray addObjectsFromArray:[MTLJSONAdapter modelsOfClass:[Comment class] fromJSONArray:comments error:nil]];
                
                if([self.commentsArray count]>0){
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
    return [self.commentsArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0.f;
    if(indexPath.row<[self.commentsArray count]){
        Comment *comment = self.commentsArray[indexPath.row];
        height = [CommentCell heightWithContent:comment.content];
    }
    return  height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"comment_cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.comment = self.commentsArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSNumber *num = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_PASTEBOARD_SWITCH];
    if([num isEqual:@1]) {
        Comment *comment = self.commentsArray[indexPath.row];
        [UIPasteboard generalPasteboard].string = comment.content;
        [self.view.window makeToast:@"已复制到剪切板" duration:kDefaultTipDuration position:CSToastPositionCenter];
    }
}
#pragma mark - Custom Accessors
- (NSMutableArray *)commentsArray{
    if(!_commentsArray){
        _commentsArray = [NSMutableArray array];
    }
    return  _commentsArray;
}
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[CommentCell class] forCellReuseIdentifier:@"comment_cell"];
        _tableView.tableFooterView = [UIView new];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
@end
