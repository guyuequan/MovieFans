//
//  SearchViewController.m
//  MovieFans
//
//  Created by Leo Gao on 15/9/8.
//  Copyright (c) 2015年 LeoCode. All rights reserved.
//

#import "SearchViewController.h"
#import "UISearchBar+Common.h"
#import "SearchResultViewController.h"
#import "TTableViewCell.h"
#import "SearchTagCell.h"

#define kHeaderDescHeight 35.f
#define kCollectionHorMargin 20.f
@interface SearchViewController ()<UISearchBarDelegate,UISearchDisplayDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) NSArray *movieTypes;
@property (nonatomic,strong) NSArray *regions;
@property (nonatomic,strong) NSArray *years;
@property (nonatomic,strong) UISearchBar *searchBar;
@property (nonatomic,strong) UITableView *historyTable;

@property (nonatomic,strong) NSMutableArray *searchHistory;
@property (nonatomic,strong) UICollectionView *tagCollectionView;
@property (nonatomic,strong) NSMutableDictionary *heightMap;
@end

@implementation SearchViewController

#pragma - mark LifeCycle
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self endSearch:self.searchBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tagCollectionView];
    [self.tagCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.navigationItem.titleView = self.searchBar;
}
#pragma mark - Public
#pragma mark - inherit
- (void)applyTheme{
    [super applyTheme];
    [self.searchBar insertBGColor:[ThemeManager themeColorWithKey:THEME_COLOR_NAVIGATION_BAR_BACKGROUND]];
    self.searchBar.barStyle = [ThemeManager shareInstance].themeType == ThemeTypeNight?UIBarStyleBlack:UIBarStyleDefault;
    [self.tagCollectionView reloadData];
}
#pragma mark - Private
- (void)showSearchHistory{
    
    if(!self.historyTable.superview){
        [self.view addSubview:self.historyTable];
         self.historyTable.backgroundColor = [ThemeManager themeColorWithKey:THEME_COLOR_VIEW_BACKGROUND];
        [self.historyTable reloadData];
    }
    
    _searchHistory = [[[NSUserDefaults standardUserDefaults] objectForKey:KEY_SEARCH_HISTORY] mutableCopy];
    [self.historyTable reloadData];
    
}
- (void)cleanSearchHistory:(UITapGestureRecognizer *)gesture{
    [[NSUserDefaults standardUserDefaults] setObject:@[] forKey:KEY_SEARCH_HISTORY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.searchHistory removeAllObjects];
    [self.historyTable reloadData];
    
}
- (void)endSearch:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
    searchBar.text = @"";
    
    [self.historyTable removeFromSuperview];
}
- (void)synchronizeHistory{
    [[NSUserDefaults standardUserDefaults] setObject:self.searchHistory forKey:KEY_SEARCH_HISTORY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.historyTable reloadData];
}
- (void)jumpToSearchResultVCWithTag:(NSString *)tag question:(NSString *)question{
    SearchResultViewController *resultVC = [[SearchResultViewController alloc]init];
    resultVC.hidesBottomBarWhenPushed = YES;
    resultVC.pushFlag = YES;
    if(tag){
        resultVC.title = [NSString stringWithFormat:@"\"%@\"的检索结果",tag];
    }else if(question){
         resultVC.title = [NSString stringWithFormat:@"\"%@\"的检索结果",question];
    }
    [resultVC loadDataWithTag:tag question:question];
    [self.navigationController pushViewController:resultVC animated:YES];
}

- (NSString *)tagWithIndexPath:(NSIndexPath *)indexPath{
    NSString *tag;
    switch (indexPath.section) {
        case 0:
            tag = self.movieTypes[indexPath.row];
            break;
        case 1:
            tag = self.regions[indexPath.row];
            break;
        case 2:
            tag = self.years[indexPath.row];
            break;
        default:
            break;
    }
    return tag;
}
#pragma mark - Protocol
#pragma mark - UICollectionViewDelegate/UICollectionViewDataSource //标签
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    NSString *key = [NSString stringWithFormat:@"%ld_%ld",indexPath.section,indexPath.row];
    if(![self.heightMap valueForKey:key]){
        CGSize size = [SearchTagCell sizeWithTag:[self tagWithIndexPath:indexPath]];
        [self.heightMap setValue:[NSValue valueWithCGSize:size] forKey:key];
        return size;
    }else{
        NSValue *sizeValue = [self.heightMap valueForKey:key];
        return [sizeValue CGSizeValue];
    }
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(collectionView.bounds.size.width,kHeaderDescHeight);
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 3;
}
//定义展示的UICollectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return [self.movieTypes count];
            break;
        case 1:
            return [self.regions count];
            break;
        case 2:
            return [self.years count];
            break;
            
        default:
            break;
    }
    return 0;
}
//每个UICollectionView展示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SearchTagCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([self class]) forIndexPath:indexPath];
    cell.label.text = [self tagWithIndexPath:indexPath];
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if (kind == UICollectionElementKindSectionHeader){
        UICollectionReusableView *reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        [reusableview.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        //定制头部视图的内容
        TLabel *headerV = [[TLabel alloc]initWithFrame:CGRectMake(kCollectionHorMargin,0.f,collectionView.bounds.size.width-2*kCollectionHorMargin,kHeaderDescHeight)];
        NSString *desc = @"";
        switch (indexPath.section) {
            case 0:
                desc = @"按标签";
                break;
            case 1:
                desc = @"按区域";
                break;
            case 2:
                desc = @"按年份";
                break;
            default:
                break;
        }
        headerV.text = desc;
        headerV.font = [UIFont boldSystemFontOfSize:13.f];
        headerV.themeTextColorKey = THEME_COLOR_LABEL_DARK;
        [reusableview addSubview:headerV];
        
        TLabel *lineView = [[TLabel alloc]initWithFrame:CGRectMake(kCollectionHorMargin, reusableview.bounds.size.height-1.f,reusableview.bounds.size.width-2*kCollectionHorMargin, 1.f)];
        lineView.themeBackgroundColorKey = THEME_COLOR_LABEL_LIGHT;
        [reusableview addSubview:lineView];
        return reusableview;
    
    }
    return nil;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *tag = @"";
    switch (indexPath.section) {
        case 0:
            tag = self.movieTypes[indexPath.row];
            break;
        case 1:
            tag = self.regions[indexPath.row];
            break;
        case 2:
            tag = self.years[indexPath.row];
            break;
        default:
            break;
    }
    [self jumpToSearchResultVCWithTag:tag question:nil];
    [MobClick event:@"UMEventClickSeachTag"];
}

#pragma mark UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:YES animated:YES];
    [self showSearchHistory];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self endSearch:searchBar];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSString *keyWord = searchBar.text;
    if([keyWord isEqualToString:@""]){
        return;
    }
    if(![self.searchHistory containsObject:keyWord]){
        [self.searchHistory insertObject:keyWord atIndex:0];
    }else{
        [self.searchHistory removeObject:keyWord];
        [self.searchHistory insertObject:keyWord atIndex:0];
    }
    [self jumpToSearchResultVCWithTag:nil question:keyWord];
    [self endSearch:searchBar];
    
    [self synchronizeHistory];
    [MobClick event:@"UMEventClickSearchButton"];
}
#pragma mark UITableViewDataSource,UITableViewDelegate //历史记录
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.searchHistory count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = self.searchHistory[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [ThemeManager themeColorWithKey:THEME_COLOR_LABEL_DARK];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *keyWord = self.searchHistory[indexPath.row];
    self.searchBar.text = keyWord;
    [self.searchHistory removeObject:keyWord];
    [self.searchHistory insertObject:keyWord atIndex:0];
    [self synchronizeHistory];
    
    [self jumpToSearchResultVCWithTag:nil question:keyWord];
    [self endSearch:self.searchBar];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 35.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if([self.searchHistory count]==0){
        return [[UIView alloc] init];
    }
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(0.f, 0.f,kViewWidth,40.f)];
    lbl.text = @"清空搜素历史";
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cleanSearchHistory:)];
    [lbl addGestureRecognizer:tap];
    lbl.backgroundColor = [ThemeManager themeColorWithKey:THEME_COLOR_CELL_BACKGROUND_DARK];
    lbl.textColor = [ThemeManager themeColorWithKey:THEME_COLOR_LABEL_LIGHT];
    return lbl;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.searchHistory removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self synchronizeHistory];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView==self.historyTable){
        [self.searchBar resignFirstResponder];
    }
}
#pragma mark - Custom Accessors
- (NSArray *)movieTypes{
    if(!_movieTypes){
    
//        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//        formatter.dateFormat = @"yyyy-MM-dd";
//        NSDate *theDay = [formatter dateFromString:@"2015-11-5"];
//        NSDate *today = [NSDate date];
//        if([today earlierDate:theDay]==today){
        
        //审核用
        BOOL showAllTag = [[[NSUserDefaults standardUserDefaults]valueForKey:KEY_IF_SHOW_ALL_TAG] boolValue];
        if(showAllTag){
            _movieTypes = @[@"高分",@"爱情",@"喜剧",@"动画",@"科幻",
                            @"剧情",@"动作",@"经典",@"青春",
                            @"悬疑",@"犯罪",@"惊悚",@"文艺",
                            @"纪录片",@"励志",@"搞笑",@"恐怖",
                            @"战争",@"短片",@"魔幻",@"黑色幽默",
                            @"传记",@"情色",@"动画短片",@"感人",
                            @"暴力",@"音乐",@"童年",@"家庭",
                            @"黑帮",@"同志",@"女性",@"浪漫",
                            @"史诗",@"童话",@"烂片"];

        }else{
            _movieTypes = @[@"高分",@"爱情",@"喜剧",@"动画",@"科幻",
                            @"剧情",@"动作",@"经典",@"青春",
                            @"悬疑",@"犯罪",@"惊悚",@"文艺",
                            @"纪录片",@"励志",@"搞笑",@"恐怖",
                            @"战争",@"短片",@"魔幻",@"黑色幽默",
                            @"传记",@"动画短片",@"感人",
                            @"音乐",@"童年",@"家庭",@"浪漫",
                            @"史诗",@"童话",@"烂片"];
        }

    }
    return _movieTypes;
}
- (NSArray *)regions{
    if(!_regions){
        _regions = @[@"大陆",@"港台",@"欧美",@"日本",@"韩国",@"印度",@"泰国"];
    }
    return _regions;
}
- (NSArray *)years{
    if(!_years){
        _years = @[@"2015",@"2014",@"2013",@"2012",@"2011",@"2010",@"2009",@"2008",@"2007",@"2006",@"2005",@"2004",@"2003",@"2002",@"2001",@"2000",@"1999",@"1998",@"1997",@"1996",@"1995",@"1994",@"1993",@"1992",@"1991",@"1990",@"老电影"];
    }
    return _years;
}
- (NSMutableDictionary*)heightMap{
    if(!_heightMap){
        _heightMap = [NSMutableDictionary dictionary];
    }
    return _heightMap;
}
- (NSMutableArray *)searchHistory{
    if(!_searchHistory){
        _searchHistory = [NSMutableArray array];
    }
    return _searchHistory;
}
- (UISearchBar *)searchBar{
    if(!_searchBar){
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"请输入影视名称或关键字...";
        _searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
        _searchBar.autocapitalizationType = UIViewAutoresizingNone;
    }
    return _searchBar;
}
- (UITableView *)historyTable{
    if(!_historyTable){
        _historyTable = [[UITableView alloc]initWithFrame:CGRectMake(0.f,0.f,kViewWidth, kViewHeight)];
        _historyTable.delegate = self;
        _historyTable.dataSource = self;
        _historyTable.showsVerticalScrollIndicator = NO;
        _historyTable.backgroundColor = [ThemeManager themeColorWithKey:THEME_COLOR_VIEW_BACKGROUND];
        [_historyTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];

    }
    return _historyTable;
}
- (UICollectionView *)tagCollectionView{
    if(!_tagCollectionView){
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.minimumLineSpacing = 20.f;
        flowLayout.minimumInteritemSpacing = 18.f;
        flowLayout.sectionInset = UIEdgeInsetsMake(10.f,kCollectionHorMargin,10.f,kCollectionHorMargin);
        _tagCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _tagCollectionView.backgroundColor = [UIColor clearColor];
        _tagCollectionView.dataSource = self;
        _tagCollectionView.delegate = self;
        _tagCollectionView.showsVerticalScrollIndicator = NO;
        [_tagCollectionView registerClass:[SearchTagCell class] forCellWithReuseIdentifier:NSStringFromClass([self class])];
        [_tagCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
    }
    return _tagCollectionView;
}
@end
