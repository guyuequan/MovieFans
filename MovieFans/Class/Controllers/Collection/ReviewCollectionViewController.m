//
//  ReviewCollectionViewController.m
//  MovieFans
//
//  Created by Leo Gao on 15/9/17.
//  Copyright (c) 2015年 LeoCode. All rights reserved.
//

#import "ReviewCollectionViewController.h"
#import "ReviewDetailViewController.h"
#import "Review.h"
#import "TTableViewCell.h"

@interface ReviewCollectionViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) NSMutableArray *reviewsArray;
@property (nonatomic,strong) UITableView *tableView;
@end

@implementation ReviewCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    self.tableView.hidden = YES;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
  
    [self loadData];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadData) name:NOTICE_COLLECTION_DATA_CHANGED object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(endEdit) name:NOTICE_COLLECTION_DATA_END_EDIT object:nil];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
#pragma mark - private
- (void)loadData{
    [SVProgressHUD showWithStatus:@""];
    [self.reviewsArray removeAllObjects];
    [self.tableView reloadData];
    self.tableView.hidden = YES;
    
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *array = [[DBUtil sharedUtil] getAllItemsFromTable:TABLE_REVIEW];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            YTKKeyValueItem *item = array[idx];
            if(item.itemObject){
                Review *review = [MTLJSONAdapter modelOfClass:[Review class] fromJSONDictionary:item.itemObject error:nil];
                [self.reviewsArray addObject:review];
            }
        }];
        if([_reviewsArray count]==0){
            self.blankLabel.hidden = NO;
        }else{
            self.blankLabel.hidden = YES;
            self.tableView.hidden = NO;
            [self.tableView reloadData];
        }
        [SVProgressHUD dismiss];
    });
}
- (void)endEdit{
    [self.tableView reloadData];
}
#pragma mark  UITableViewDataSource/UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.reviewsArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"review_Cell"];
    if(!cell){
        cell = [[TTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"review_Cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.backgroundColor = [UIColor clearColor];
    
    Review *review = self.reviewsArray[indexPath.row];
    cell.textLabel.text = review.title;
    cell.textLabel.font = [UIFont systemFontOfSize:16.f];
    cell.detailTextLabel.text = review.author;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12.f];
    
    cell.themeTitleColorKey = THEME_COLOR_CELL_TITLE;
    cell.themeDetailColorKey = THEME_COLOR_CELL_CONTENT;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    ReviewDetailViewController *detailVC = [[ReviewDetailViewController alloc]init];
    detailVC.review = self.reviewsArray[indexPath.row];
    detailVC.title = @"影评全文";
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Review *r = [self.reviewsArray objectAtIndex:indexPath.row];
        [[DBUtil sharedUtil] deleteObjectById:r.rId fromTable:TABLE_REVIEW];
        [self.reviewsArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];

        if([self.reviewsArray count]==0){
            self.blankLabel.hidden = NO;
            self.tableView.hidden = YES;
        }else{
            self.blankLabel.hidden = YES;
            self.tableView.hidden = NO;
        }
        [MobClick event:@"UMEVentDeleteCollection"];
    }
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
        _tableView = [[UITableView alloc]init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.rowHeight = 55.f;
        self.tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}
@end
