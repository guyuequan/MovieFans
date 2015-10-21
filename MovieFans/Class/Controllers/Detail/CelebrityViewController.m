//
//  CelebrityViewController.m
//  MovieFans
//
//  Created by Leo Gao on 15/9/18.
//  Copyright © 2015年 LeoCode. All rights reserved.
//

#import "CelebrityViewController.h"
#import "TTTAttributedLabel.h"
#import "Celebrity.h"
#import "HeaderDescView.h"
#import "Photo.h"
#import "MovieCell.h"
#import "Work.h"
#import "MoviePhotosViewController.h"
#import "MovieDetailViewController.h"
#import "SearchResultViewController.h"

#define kCellNormalIdentify @"cellNormalIdentify"
#define kHeaderViewHeight 220.f
#define kCoverViewWidth 180.f
#define kPhotosCellHeight 100.f
#define kAbstractMargin 10.f
#define kAbstractViewShortHeight (isPad?300.f:138.f)
@interface CelebrityViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *contentView;
@property (nonatomic,strong) UIImageView *avatarView;
@property (nonatomic,strong) UILabel *basicInfoView;//基本信息
@property (nonatomic,strong) UIView *headerView;
@property (nonatomic,strong) UIView *footerView;
@property (nonatomic,strong) UILabel *abstractView;//简介
@property (nonatomic,assign) CGFloat abstractViewHeight; //电影简介高度

@property (nonatomic,assign) BOOL abstractViewHasBeenTapped;//点击过简介cell（查看全部简介）
@property (nonatomic,strong) NSArray *photos;//详情接口返回的剧照仅显示前4张
@property (nonatomic,strong) NSArray *works;//相关作品
@property (nonatomic,strong) Celebrity *celebrity;
@end

@implementation CelebrityViewController

- (instancetype)initWithCelebrity:(Celebrity*)celebrity{
    if(self = [super init]){
        _celebrity = celebrity;
        _celebrityId = celebrity.cId;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.contentView];
    self.contentView.hidden = YES;
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self setupRightBarItem];
    
    if(!self.celebrity){
        [self requestCelebrityData];
    }else{
        [self refreshViewWithCelebrity:self.celebrity];
    }
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}
#pragma mark - inherit
- (void)applyTheme{
    [super applyTheme];
    self.abstractView.backgroundColor = [ThemeManager themeColorWithKey:THEME_COLOR_VIEW_BACKGROUND];
    self.abstractView.textColor = [ThemeManager themeColorWithKey:THEME_COLOR_LABEL_DARK];
    self.basicInfoView.textColor = [ThemeManager themeColorWithKey:THEME_COLOR_LABEL_DARK];
}
#pragma mark - Private
- (void)setupRightBarItem{
    //收藏
    UIButton *faverBtn = [[UIButton alloc]initWithFrame:CGRectMake(0.f, 0.f, 32.f, 32.f)];
    faverBtn.tintColor = [UIColor yellowColor];
    [faverBtn setImage:[UIImage imageNamed:@"star_unfav"] forState:UIControlStateNormal];
    [faverBtn setImage:[[UIImage imageNamed:@"star_fav"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateSelected];
    [faverBtn addTarget:self action:@selector(collectBtnClicekd:) forControlEvents:UIControlEventTouchUpInside];
    if([[DBUtil sharedUtil]  getObjectById:self.celebrityId fromTable:TABLE_CELEBRITY]){
        faverBtn.selected = YES;
    }
    UIBarButtonItem *faverItem = [[UIBarButtonItem alloc]initWithCustomView:faverBtn];
    
    //分享按钮
//    UIButton *shareBtn = [[UIButton alloc]initWithFrame:CGRectMake(0.f, 0.f, 25.f, 25.f)];
//    [shareBtn setImage:[UIImage imageNamed:@"movie_share"] forState:UIControlStateNormal];
//    [shareBtn addTarget:self action:@selector(shareBtnClicekd:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc]initWithCustomView:shareBtn];
    self.navigationItem.rightBarButtonItems = @[faverItem];
    
}
- (void)collectBtnClicekd:(UIButton *)sender{
    [MobClick event:@"UMEVentSaveCelebrity"];
    BOOL isSucceed = NO;
    if(self.celebrity){
        if(!sender.selected){//收藏
            NSDictionary *dic = [MTLJSONAdapter JSONDictionaryFromModel:self.celebrity error:nil];
            [[DBUtil sharedUtil] putObject:dic withId:self.celebrityId intoTable:TABLE_CELEBRITY];
            
            if([[DBUtil sharedUtil]  getObjectById:self.celebrityId fromTable:TABLE_CELEBRITY]){
                [AFMInfoBanner showAndHideWithText:@"收藏成功" style:AFMInfoBannerStyleInfo];
                sender.selected = !sender.selected;
                isSucceed = YES;
            }else{
                [AFMInfoBanner showAndHideWithText:@"收藏失败" style:AFMInfoBannerStyleError];
            }
        }else{//取消收藏
            [[DBUtil sharedUtil]  deleteObjectById:self.celebrityId fromTable:TABLE_CELEBRITY];
            if(![[DBUtil sharedUtil]  getObjectById:self.celebrityId fromTable:TABLE_CELEBRITY]){
                [AFMInfoBanner showAndHideWithText:@"已取消收藏" style:AFMInfoBannerStyleInfo];
                sender.selected = !sender.selected;
                isSucceed = YES;
            }else{
                [AFMInfoBanner showAndHideWithText:@"收藏失败" style:AFMInfoBannerStyleError];
            }
        }
    }else{
        [AFMInfoBanner showAndHideWithText:@"收藏失败" style:AFMInfoBannerStyleError];
    }
    if(isSucceed){
        [[NSNotificationCenter defaultCenter]postNotificationName:NOTICE_COLLECTION_DATA_CHANGED object:nil];
    }
}
- (void)shareBtnClicekd:(UIButton *)sender{
    NSLog(@"分享...");
}
- (void)requestCelebrityData{
    
    if(!self.celebrityId){
        return;
    }
    
    [SVProgressHUD showWithStatus:@""];
    [[NetworkManager sharedManager] requestCelebrityDataWithParams:@{@"apikey":kApiKey4Douban} celebrityId:self.celebrityId andBlock:^(Celebrity *celebrity, NSError *error) {
        self.celebrity = celebrity;

        [SVProgressHUD dismiss];
        [self refreshViewWithCelebrity:celebrity];
    }];
}
- (void)refreshViewWithCelebrity:(Celebrity *)celebrity{
     self.contentView.hidden = NO;
    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:celebrity.avatars.large] placeholderImage:[UIImage imageNamed:@"poster_default"]];
    
    //拼接基本信息字符串
    NSMutableString *mStr = [[NSMutableString alloc]init];
    
//    [mStr appendFormat:@"英文名:  %@",celebrity.nameEn];
//    [mStr appendFormat:@"\n别    名:  %@",[celebrity.aka componentsJoinedByString:@","]];
////    [mStr appendFormat:@"\n性    别:  %@",celebrity.gender];
//    [mStr appendFormat:@"\n出生地:  %@",celebrity.bornPlace];
//    [mStr appendFormat:@"\n生    日:  %@",celebrity.birthday];
//    [mStr appendFormat:@"\n职    业:  "];
//    [mStr appendFormat:@"%@",[celebrity.professions componentsJoinedByString:@"/"]];
//    
    if(celebrity.nameEn){
        [mStr appendFormat:@" %@",celebrity.nameEn];
    }
    if(celebrity.aka){
        [mStr appendFormat:@"\n %@",[celebrity.aka componentsJoinedByString:@","]];
    }
//    [mStr appendFormat:@"\n性    别:  %@",celebrity.gender];
    if(celebrity.bornPlace){
        [mStr appendFormat:@"\n %@",celebrity.bornPlace];
    }
    if(celebrity.birthday){
        [mStr appendFormat:@"\n %@",celebrity.birthday];
    }
    if(celebrity.professions){
        [mStr appendFormat:@"\n%@",[celebrity.professions componentsJoinedByString:@"/"]];
    }
    
//    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
//    [paragraphStyle1 setLineSpacing:5.f];
    
    
//    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:mStr
//                                                                    attributes:@{
//                                                                                 (id)kCTForegroundColorAttributeName : (id)[UIColor orangeColor].CGColor,
//                                                                                 NSFontAttributeName : [UIFont italicSystemFontOfSize:14],
//                                                                                 NSKernAttributeName : [NSNull null],
//                                                                                 NSParagraphStyleAttributeName:paragraphStyle1,
//                                                                                 }];

    self.basicInfoView.attributedText = [mStr attributedStringWithLineSpacing:6.f];
    self.basicInfoView.textAlignment = NSTextAlignmentCenter;
    
    
    //影人简介
    NSString *abstract = [NSString stringWithFormat:@"       %@",[celebrity.summary trimWhitespace]];
    NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc] initWithString:abstract];
    NSMutableParagraphStyle * paragraphStyle2 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle2 setLineSpacing:5.f];
    NSDictionary *attDic = @{NSFontAttributeName:[UIFont systemFontOfSize:14.f],NSParagraphStyleAttributeName:paragraphStyle2};
    [attStr addAttributes:attDic range:NSMakeRange(0,[attStr length])];
    self.abstractView.attributedText = attStr;

    _abstractViewHeight = [attStr.string heightWithAttributes:attDic andSize:CGSizeMake(kViewWidth-kAbstractMargin*2,CGFLOAT_MAX)]+20.f;
    if([[celebrity.summary trimWhitespace] length]==0){
        _abstractViewHeight = 1.f;
    }
    [self.contentView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    //剧照cell
    self.photos = celebrity.photos;
    [self.contentView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    //作品
    self.works = celebrity.works;
    [self.contentView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"%@",self.parentViewController);
    if ([self.parentViewController isKindOfClass:[UINavigationController class]]) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
//        [self.fatherNavController pushViewController:[[UIViewController alloc] init] animated:YES];
    }
}
- (void)moreBtnClicked:(UIButton *)sender{
    SearchResultViewController *searchResultVC = [[SearchResultViewController alloc]init];
    searchResultVC.pushFlag = YES;
    searchResultVC.title = [NSString stringWithFormat:@"\"%@\"的作品",self.celebrity.name];
    [searchResultVC loadDataWithTag:@"" question:self.celebrity.name];
    [self.navigationController pushViewController:searchResultVC animated:YES];
}
#pragma mark - Protocol
#pragma mark Tableview Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    //三块内容：简介、剧照、作品
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat height = 0.f;
    switch (indexPath.section) {
        case 0:
            //默认如果简介过长指显示100的高度，点击一次再现实完整
            if(self.abstractViewHeight>kAbstractViewShortHeight&&!self.abstractViewHasBeenTapped){
                height = kAbstractViewShortHeight;
            }else{
                height = self.abstractViewHeight;
            }
            break;
        case 1:
            height = kPhotosCellHeight;
            if([self.photos count]==0){
                height = 1.f;
            }
            break;
        case 2:
            height = [MovieCell HeightOfCell];
            break;
        default:
            break;
    }
    return height;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger num = 0;
    switch (section) {
        case 0:{//简介
            num = 1;
        }
            break;
        case 1:{//剧照
            num = 1;
        }
            break;
        case 2:{//作品
            num = [self.works count];
        }
            break;
        default:
            break;
    }
    return num;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    HeaderDescView *descView = [[HeaderDescView alloc]initWithFrame:CGRectMake(0.f, 0.f, kViewWidth,30.f)];
    switch (section) {
        case 0:
            descView.descLbl.text = @"简介";
            break;
        case 1:
            descView.descLbl.text = @"剧照";
            break;
        case 2:
            descView.descLbl.text = @"作品";
            break;
        default:
            break;
    }
//    descView.descLbl.textColor = [UIColor darkGrayColor];
    descView.backgroundColor = [ThemeManager themeColorWithKey:THEME_COLOR_MENU_BACKGROUND];
    return descView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [self.contentView dequeueReusableCellWithIdentifier:kCellNormalIdentify];
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    switch (indexPath.section) {
        case 0:{
            cell.accessoryType = UITableViewCellAccessoryNone;
            [cell.contentView addSubview:self.abstractView];
            cell.contentView.clipsToBounds = YES;
            [self.abstractView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(cell.contentView.mas_leading).offset(kAbstractMargin);
                make.trailing.equalTo(cell.contentView.mas_trailing).offset(-kAbstractMargin);
                make.top.equalTo(cell.contentView.mas_top).offset(5.f);
                make.height.mas_greaterThanOrEqualTo(40.f);
//                make.bottom.equalTo(cell.contentView.mas_bottom);
            }];
            if(self.abstractViewHeight>kAbstractViewShortHeight&&!self.abstractViewHasBeenTapped){
                UILabel *lbl = [[UILabel alloc]init];
                lbl.font = [UIFont systemFontOfSize:14.f];
                lbl.text = @"......";
                lbl.textColor = [UIColor orangeColor];
                lbl.backgroundColor = [ThemeManager themeColorWithKey:THEME_COLOR_VIEW_BACKGROUND];
                lbl.textAlignment = NSTextAlignmentCenter;
                [cell.contentView addSubview:lbl];
                [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(23.f);
                    make.bottom.equalTo(cell.contentView.mas_bottom);
                    make.trailing.equalTo(cell.contentView.mas_trailing);
                    make.leading.equalTo(cell.contentView.mas_leading);
                }];
            }
             cell.clipsToBounds = YES;
        }
            break;
        case 1:{
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            CGFloat horMargin = 10.f;
            CGFloat horGap = 5.f;
            NSInteger count = 4;
            CGFloat verGap = 5.f;
            CGFloat w = (kViewWidth-horMargin*2-30.f-(count-1)*horGap)/count;
            CGFloat h = kPhotosCellHeight-verGap*2;
            if(isPad){
                count = 6;
                cell.accessoryType = UITableViewCellAccessoryNone;
                w = (kViewWidth-horMargin*2-(count-1)*horGap)/count;
            }
            for(int i=0;i<count;i++){
                UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(horMargin+(w+horGap)*i,verGap,w,h)];
                imgView.contentMode = UIViewContentModeScaleAspectFill;
                imgView.clipsToBounds = YES;
                if(i<[self.photos count]){
                    Photo *photo = self.photos[i];
                    [imgView sd_setImageWithURL:[NSURL URLWithString:photo.image] placeholderImage:[UIImage imageNamed:@"poster_default"]];
                }
                [cell.contentView addSubview:imgView];
            }
        }
            break;
        case 2:{
            static NSString *cellStr = @"_cell";
            MovieCell *cell = [self.contentView dequeueReusableCellWithIdentifier:cellStr];
            if(!cell){
                cell = [[MovieCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            Work *work = self.works[indexPath.row];
            MovieSimple *movie = [[MovieSimple alloc]init];
            if(work){
                movie.movieID = work.subject.mId;
                movie.movieName = work.subject.title;
                movie.rating = work.subject.rating;
                movie.posterPathMedium = work.subject.images.medium;
                movie.year = work.subject.year;
                movie.categoryArr = work.subject.genres;
            }
            [cell setDataModel:movie];
            return cell;

        }
            break;
        default:
            break;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if(indexPath.section==0){//简介
        if(self.abstractViewHeight>kAbstractViewShortHeight&&!self.abstractViewHasBeenTapped){
            self.abstractViewHasBeenTapped = YES;
            [self.contentView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }else if(indexPath.section==1){//剧照
        MoviePhotosViewController *photoVC = [[MoviePhotosViewController alloc]init];
        photoVC.title = self.celebrity.name;
        photoVC.celebrityId = self.celebrity.cId;
        [self.navigationController pushViewController:photoVC animated:YES];
    }else if(indexPath.section==2){//影视作品
        MovieDetailViewController *detail = [[MovieDetailViewController alloc]init];
        Work *work = self.works[indexPath.row];
        if(work){
            detail.movieId = work.subject.mId;
            detail.movieName = work.subject.title;
        }
        detail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detail animated:YES];
    }
}
#pragma mark - Custom Accessors
- (UIView *)contentView{
    if(!_contentView){
        _contentView = [[UITableView alloc]init];
        _contentView.delegate = self;
        _contentView.dataSource = self;
        _contentView.backgroundColor = [UIColor clearColor];
        _contentView.showsVerticalScrollIndicator = NO;
        [_contentView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellNormalIdentify];
//        if (isPad){
            _contentView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        }
        _contentView.tableHeaderView = self.headerView;
        _contentView.tableFooterView = self.footerView;
    
    }
    return _contentView;
}
- (UIView *)headerView{
    if(!_headerView){
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0.f, 0.f, kViewWidth,kHeaderViewHeight)];
        //封面
        if(!_avatarView){
            _avatarView = [[UIImageView alloc]init];
            _avatarView.contentMode = UIViewContentModeScaleAspectFill;
            _avatarView.clipsToBounds = YES;
        }
        [_headerView addSubview:self.avatarView];
        
        //基本信息
        if(!_basicInfoView){
            _basicInfoView = [[UILabel alloc]initWithFrame:CGRectZero];
            _basicInfoView.numberOfLines = 0;;
            _basicInfoView.font = [UIFont italicSystemFontOfSize:14.f];
            _basicInfoView.lineBreakMode = NSLineBreakByCharWrapping;
            _basicInfoView.textColor = [UIColor orangeColor];
        }
        [_headerView addSubview:self.basicInfoView];
        
        [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(kViewWidth);
            make.height.mas_equalTo(kHeaderViewHeight);
        }];
        
        CGFloat horGap = 5.f;
        if (isPad){
            horGap = 10.f;
        }
        [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(_headerView.mas_leading).offset(horGap*2);
            make.top.equalTo(_headerView.mas_top).offset(horGap);
            make.width.mas_equalTo(kCoverViewWidth);
            make.bottom.mas_equalTo(_headerView.mas_bottom).offset(-horGap);
        }];
        [self.basicInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(_avatarView.mas_trailing).offset(horGap);
            make.top.equalTo(_avatarView.mas_top).offset(0.f);
            make.trailing.equalTo(_headerView.mas_trailing).offset(-horGap);
            make.height.equalTo(_avatarView.mas_height);
        }];
    }
    return _headerView;
}
- (UIView *)footerView{
    if(!_footerView){
        _footerView = [[UIView alloc]initWithFrame:CGRectMake(0.f, 0.f,kViewWidth,100.f)];
        TButton *moreBtn = [[TButton alloc]initWithFrame:CGRectMake(10.f, 5.f,kViewWidth-20.f,40.f)];
        [moreBtn setTitle:@"更多作品" forState:UIControlStateNormal];
        moreBtn.themeBackgroundColorKey = THEME_COLOR_MENU_BACKGROUND;
        moreBtn.themeTextColorNormalKey = THEME_COLOR_BUTTON_TEXT;
        [moreBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [moreBtn addTarget:self action:@selector(moreBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:moreBtn];
    }
    return _footerView;
}
//简介
- (UILabel *)abstractView{
    if(!_abstractView){
        _abstractView = [[UILabel alloc]init];
        _abstractView.numberOfLines = 0;
        _abstractView.textColor = [UIColor clearColor];
        _abstractView.font = [UIFont systemFontOfSize:14.f];
    }
    return _abstractView;
}
@end
