//
//  MovieDetailViewController.m
//  MovieFans
//
//  Created by Leo Gao on 15/9/10.
//  Copyright (c) 2015年 LeoCode. All rights reserved.
//

#import "MovieDetailViewController.h"
#import "HeaderDescView.h"
#import "TTTAttributedLabel.h"
#import "CommentCell.h"
#import "DoubanBrowseViewController.h"
#import "ReviewViewController.h"
#import "MoviePhotosViewController.h"
#import "Movie.h"
#import "EDStarRating.h"
#import "Celebrity.h"
#import "CelebrityViewController.h"

#define kHeaderViewHeight 220.f
#define kCellMargin 15.f
#define kCoverViewWidth 140.f
#define kPhotosCellHeight 100.f
#define kAbstractViewShortHeight (isPad?300.f:138.f)
#define kCellNormalIdentify @"cellNormalIdentify"
#define kCellCommentIdentify @"CommentCell"

@interface MovieDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,TTTAttributedLabelDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIView *headerView;
@property (nonatomic,strong) UIView *footerView;
@property (nonatomic,strong) UIImageView *coverView;//影片海报封面
@property (nonatomic,strong) EDStarRating *ratingView;//星星评分
@property (nonatomic,strong) UILabel *ratingLbl;
@property (nonatomic,strong) TTTAttributedLabel *basicInfoView;//基本信息
@property (nonatomic,strong) UILabel *abstractView;//简介
@property (nonatomic,assign) CGFloat abstractViewHeight; //电影简介高度

@property (nonatomic,assign) BOOL abstractViewHasBeenTapped;//点击过简介cell（查看全部简介）
@property (nonatomic,strong) NSArray *moviePhotos;//详情接口返回的剧照仅显示前4张
@property (nonatomic,strong) NSArray *comments;//热评
@property (nonatomic,strong) Movie *movieDetail;

@end

@implementation MovieDetailViewController

#pragma - mark LifeCycle
- (instancetype)initWithMovieModel:(Movie *)movie{
    if(self = [super init]){
        _movieDetail = movie;
        _movieId = movie.mId;
        _movieName = movie.title;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
    self.navigationItem.title = self.movieName;
    
    if(!self.movieDetail){
        [self requestData];
    }else{
        [self refreshViewWithMovie:self.movieDetail];
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
  
}

#pragma mark - Private
- (void)setupSubviews{
    [self.view addSubview:self.tableView];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.tableView setHidden:YES];
    [self setupRightBarItem];
}
- (void)setupRightBarItem{
    //收藏
    UIButton *faverBtn = [[UIButton alloc]initWithFrame:CGRectMake(0.f, 0.f, 32.f, 32.f)];
    faverBtn.tintColor = [UIColor yellowColor];
    [faverBtn setImage:[UIImage imageNamed:@"star_unfav"] forState:UIControlStateNormal];
    [faverBtn setImage:[[UIImage imageNamed:@"star_fav"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateSelected];
    [faverBtn addTarget:self action:@selector(collectBtnClicekd:) forControlEvents:UIControlEventTouchUpInside];
    if([[DBUtil sharedUtil]  getObjectById:self.movieId fromTable:TABLE_MOVIE]){
        faverBtn.selected = YES;
    }
    UIBarButtonItem *faverItem = [[UIBarButtonItem alloc]initWithCustomView:faverBtn];
    
    self.navigationItem.rightBarButtonItems = @[faverItem];
}
- (void)collectBtnClicekd:(UIButton *)sender{
    [MobClick event:@"UMEVentSaveMovie"];
    
    if(self.movieDetail){
        sender.selected = !sender.selected;
        //UI立即响应
        if(sender.selected){//收藏
            [AFMInfoBanner showAndHideWithText:@"收藏成功" style:AFMInfoBannerStyleInfo];
        }else{
            [AFMInfoBanner showAndHideWithText:@"已取消收藏" style:AFMInfoBannerStyleInfo];
        }

        //后台，数据操作
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE,0), ^{
            if(sender.selected){//收藏
                NSDictionary *dic = [MTLJSONAdapter JSONDictionaryFromModel:self.movieDetail error:nil];
                [[DBUtil sharedUtil] putObject:dic withId:self.movieDetail.mId intoTable:TABLE_MOVIE];
            }else{//取消收藏
                [[DBUtil sharedUtil]  deleteObjectById:self.movieDetail.mId fromTable:TABLE_MOVIE];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter]postNotificationName:NOTICE_COLLECTION_DATA_CHANGED object:nil];
            });
        });
    }else{
        [AFMInfoBanner showAndHideWithText:@"收藏失败" style:AFMInfoBannerStyleError];
    }
    
}
-(void)requestData{
    if(!self.movieId){
        return;
    }
    [SVProgressHUD showWithStatus:@""];
    
    [[NetworkManager sharedManager] requestMovieDetailWithParams:@{@"apikey":kApiKey4Douban} movieId:self.movieId andBlock:^(Movie *movie, NSError *error) {
        if(movie){
            self.movieDetail = movie;
            [self refreshViewWithMovie:movie];
        }
        [SVProgressHUD dismiss];
    }];
}
- (void)moreBtnClicked:(UIButton *)sender{
    [MobClick event:@"UMEVentClickMoreReview"];
    ReviewViewController *reviewVC = [[ReviewViewController alloc]init];
    reviewVC.movieId = self.movieId;
    reviewVC.movieName = self.movieName;
    [self.navigationController pushViewController:reviewVC animated:YES];
}
- (void)refreshViewWithMovie:(Movie *)movie{
    if(movie){
        [self.tableView setHidden:NO];
        
        [self.coverView sd_setImageWithURL:[NSURL URLWithString:movie.images.large] placeholderImage:[UIImage imageNamed:@"poster_default"]];
        
        //电影简介
        NSString *abstract = [NSString stringWithFormat:@"       %@",movie.summary];
        NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc] initWithString:abstract];
        NSMutableParagraphStyle * paragraphStyle2 = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle2 setLineSpacing:5.f];
        NSDictionary *attDic = @{NSFontAttributeName:[UIFont systemFontOfSize:15.f],NSParagraphStyleAttributeName:paragraphStyle2};
        [attStr addAttributes:attDic range:NSMakeRange(0,[attStr length])];
        self.abstractView.attributedText = attStr;
        
        _abstractViewHeight = [attStr.string heightWithAttributes:attDic andSize:CGSizeMake(kViewWidth-20,CGFLOAT_MAX)]+25.f;
        if([[movie.summary trimWhitespace] length]==0){
            _abstractViewHeight = 1.f;
        }
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        //豆瓣分数
        if(movie.rating){
            self.ratingLbl.text = [NSString stringWithFormat:@"%.1f分",[movie.rating floatValue]];
            self.ratingView.rating = movie.rating.floatValue/2.f;
            if([self.ratingLbl.text isEqualToString:@"0.0分"]){
                self.ratingLbl.text = [NSString stringWithFormat:@"  -   分"];
            }
        }
        //剧照cell
        self.moviePhotos = movie.photos;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        //热评
        self.comments = movie.popularComments;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        //拼接基本信息字符串
        NSMutableString *mStr = [[NSMutableString alloc]init];
        [mStr appendFormat:@"类型: %@",[movie.genres componentsJoinedByString:@"/"]];
        
        [mStr appendFormat:@"\n地区: "];
        [mStr appendFormat:@"%@",[movie.countries componentsJoinedByString:@"/"]];
        
        [mStr appendFormat:@"\n时长: %@",movie.duration];
        [mStr appendFormat:@"\n年份: %@",movie.year];
        
        [mStr appendFormat:@"\n导演: "];
        [mStr appendFormat:@"%@",[[movie.directors valueForKey:@"name"]componentsJoinedByString:@"/"]];
        
        [mStr appendFormat:@"\n演员: "];
        [mStr appendFormat:@"%@",[[movie.casts valueForKey:@"name"] componentsJoinedByString:@","]];
        
        NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle1 setLineSpacing:5.f];
        
        
        NSAttributedString *attString = [[NSAttributedString alloc] initWithString:mStr
                                                                        attributes:@{
                                                                                     (id)kCTForegroundColorAttributeName : (id)[ThemeManager themeColorWithKey:THEME_COLOR_LABEL_DARK].CGColor,
                                                                                     NSFontAttributeName : [UIFont systemFontOfSize:15],
                                                                                     NSKernAttributeName : [NSNull null],
                                                                                     NSParagraphStyleAttributeName:paragraphStyle1,
                                                                                     }];
        //基本信息
        self.basicInfoView.text = attString;
        
        
        //导演加链接
        for(int i=0;i<[movie.directors count];i++){
            NSRange range = [mStr rangeOfString:[movie.directors[i] valueForKey:@"name"]];
            if(range.location!=NSNotFound){
                Celebrity *celebrity = movie.directors[i];
                [self.basicInfoView addLinkToTransitInformation:celebrity.dictionaryValue withRange:range];
            }
        }
        
        //演员加链接
        for(int i=0;i<[movie.casts count];i++){
            NSRange range = [mStr rangeOfString:[movie.casts[i] valueForKey:@"name"]];
            if(range.location!=NSNotFound){
                Celebrity *celebrity = movie.casts[i];
                [self.basicInfoView addLinkToTransitInformation:celebrity.dictionaryValue withRange:range];
            }
        }
        
    }
}
#pragma mark - Protocol
#pragma mark Tableview Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    //三块内容：简介、剧照、热评
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
            if([self.moviePhotos count]==0){
                height = 1.f;
            }
            break;
        case 2:
            if(indexPath.row<[self.comments count]){
                Comment *comment = self.comments[indexPath.row];
                height = [CommentCell heightWithContent:comment.content];
            }
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
        case 2:{//短评
            num = [self.comments count];
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
            descView.descLbl.text = @"热评";
            break;
        default:
            break;
    }
    descView.backgroundColor = [ThemeManager themeColorWithKey:THEME_COLOR_MENU_BACKGROUND];
    return descView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kCellNormalIdentify];
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.accessoryType = UITableViewCellAccessoryNone;
    switch (indexPath.section) {
        case 0:{
            [cell.contentView addSubview:self.abstractView];
            [self.abstractView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(cell.contentView.mas_leading).offset(kCellMargin);
                make.trailing.equalTo(cell.contentView.mas_trailing).offset(-kCellMargin);
                make.top.equalTo(cell.contentView.mas_top).offset(10.f);
                make.height.mas_greaterThanOrEqualTo(40.f);
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
                    make.height.mas_equalTo(20.f);
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
            CGFloat horGap = 5.f;
            NSInteger count = 4;
            CGFloat verGap = 5.f;
            CGFloat w = (kViewWidth-kCellMargin*2-30.f-(count-1)*horGap)/count;
            CGFloat h = kPhotosCellHeight-verGap*2;
            if(isPad){
                count = 6;
                cell.accessoryType = UITableViewCellAccessoryNone;
                w = (kViewWidth-kCellMargin*2-(count-1)*horGap)/count;
            }
            
            for(int i=0;i<count;i++){
                UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(kCellMargin+(w+horGap)*i,verGap,w,h)];
                imgView.contentMode = UIViewContentModeScaleAspectFill;
                imgView.clipsToBounds = YES;
                if(i<[self.moviePhotos count]){
                    [imgView sd_setImageWithURL:[NSURL URLWithString:[self.moviePhotos[i] valueForKey:@"thumb"]] placeholderImage:[UIImage imageNamed:@"poster_default"]];
                }
                [cell.contentView addSubview:imgView];
            }
        }
            break;
        case 2:{
            cell = [self.tableView dequeueReusableCellWithIdentifier:kCellCommentIdentify];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            ((CommentCell*)cell).comment = self.comments[indexPath.row];
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
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }else if(indexPath.section==1){//剧照
        MoviePhotosViewController *photoVC = [[MoviePhotosViewController alloc]init];
        photoVC.title = self.movieName;
        photoVC.movieId = self.movieId;
        [self.navigationController pushViewController:photoVC animated:YES];
    }else if(indexPath.section==2){
        NSNumber *num = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_PASTEBOARD_SWITCH];
        if([num isEqual:@1]) {
            Comment *comment = self.comments[indexPath.row];
            [UIPasteboard generalPasteboard].string = comment.content;
            [self.view.window makeToast:@"已复制到剪切板" duration:kDefaultTipDuration position:CSToastPositionCenter];
        }
    }
}
#pragma mark TTTAttributedLabelDelegate
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithTransitInformation:(NSDictionary *)components{
    [MobClick event:@"UMEVentClickCelebirty"];
    
    CelebrityViewController *celebrityVC = [[CelebrityViewController alloc]init];
    celebrityVC.celebrityId = [components valueForKey:@"cId"];
    celebrityVC.title = [components valueForKey:@"name"];
    [self.navigationController pushViewController:celebrityVC animated:YES];
}
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:actionSheet.title]];
}


#pragma mark - Custom Accessors
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellNormalIdentify];
        [_tableView registerClass:[CommentCell class] forCellReuseIdentifier:kCellCommentIdentify];
//        if (isPad){
            _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        }
        _tableView.tableHeaderView = self.headerView;
        _tableView.tableFooterView = self.footerView;
        
    }
    return _tableView;
}
- (UIView *)headerView{
    if(!_headerView){
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0.f, 0.f, kViewWidth,kHeaderViewHeight)];
        _headerView.backgroundColor = [UIColor clearColor];
        //封面
        _coverView = [[UIImageView alloc]init];
        _coverView.contentMode = UIViewContentModeScaleAspectFill;
        _coverView.clipsToBounds = YES;
        [_headerView addSubview:self.coverView];

        //星星
        _ratingView = [[EDStarRating alloc]init];
        _ratingView.starImage = [[UIImage imageNamed:@"ratingstar"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        _ratingView.starHighlightedImage = [[UIImage imageNamed:@"ratingstar_activated"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        _ratingView.maxRating = 5.0;
        _ratingView.horizontalMargin = 0.0;
        [_ratingView setNeedsDisplay];
        _ratingView.displayMode=EDStarRatingDisplayHalf;
        [_headerView addSubview:_ratingView];

        //评分
        _ratingLbl = [[UILabel alloc]init];
        _ratingLbl.textColor = [UIColor redColor];
        _ratingLbl.font = [UIFont italicSystemFontOfSize:25.f];
        _ratingLbl.textAlignment = NSTextAlignmentLeft;
        _ratingLbl.layer.cornerRadius = 5.f;
        _ratingLbl.layer.masksToBounds = YES;
        [_headerView addSubview:_ratingLbl];
        
        
        //基本信息
        _basicInfoView = [[TTTAttributedLabel alloc]initWithFrame:CGRectZero];
        _basicInfoView.numberOfLines = 0;
        _basicInfoView.delegate = self;
        _basicInfoView.linkAttributes = @{(id)kCTForegroundColorAttributeName : (id)[ThemeManager themeColorWithKey:THEME_COLOR_LABEL_DARK].CGColor,(NSString *)kCTUnderlineStyleAttributeName:[NSNumber numberWithBool:YES]};
        _basicInfoView.lineBreakMode = NSLineBreakByCharWrapping;
       
        [_headerView addSubview:self.basicInfoView];
        
        [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(kViewWidth);
            make.height.mas_equalTo(kHeaderViewHeight);
        }];
        
        CGFloat horGap = 5.f;
        [_coverView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(_headerView.mas_leading).offset(isPad?15:10);
            make.top.equalTo(_headerView.mas_top).offset(10);
            make.width.mas_equalTo(kCoverViewWidth);
            make.bottom.mas_equalTo(_headerView.mas_bottom).offset(-10);
        }];
    
        [_ratingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.coverView.mas_trailing).offset(horGap);
            make.top.equalTo(self.coverView.mas_top).offset(horGap);
            make.width.mas_equalTo(75.f);
            make.height.mas_equalTo(25.f);
        }];
        
        [_ratingLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(_headerView.mas_trailing).offset(-horGap);
            make.top.equalTo(_ratingView.mas_top);
            make.leading.equalTo(_ratingView.mas_trailing).offset(horGap);
            make.height.equalTo(_ratingView.mas_height);
        }];

        [_basicInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.coverView.mas_trailing).offset(horGap);
            make.top.equalTo(self.ratingLbl.mas_bottom).offset(5);
            make.trailing.equalTo(_headerView.mas_trailing).offset(-horGap);
            make.bottom.equalTo(_headerView.mas_bottom).offset(-5);
        }];
    }
    return _headerView;
}
- (UIView *)footerView{
    if(!_footerView){
        _footerView = [[UIView alloc]initWithFrame:CGRectMake(0.f, 0.f,kViewWidth,100.f)];
        TButton *moreBtn = [[TButton alloc]initWithFrame:CGRectMake(kCellMargin, 5.f,kViewWidth-kCellMargin*2,40.f)];
        [moreBtn setTitle:@"浏览更多影评" forState:UIControlStateNormal];
        moreBtn.themeBackgroundColorKey = THEME_COLOR_CELL_BACKGROUND_DARK;
        moreBtn.themeTextColorNormalKey = THEME_COLOR_BUTTON_TEXT;
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
        _abstractView.textColor = [ThemeManager themeColorWithKey:THEME_COLOR_LABEL_DARK];
    }
    return _abstractView;
}
- (NSArray *)comments{
    if(!_comments){
        _comments = [NSArray array];
    }
    return _comments;
}
@end
