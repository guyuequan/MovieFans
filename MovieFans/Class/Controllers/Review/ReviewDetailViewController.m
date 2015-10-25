//
//  ReviewDetailViewController.m
//  MovieFans
//
//  Created by Leo Gao on 15/9/12.
//  Copyright (c) 2015年 LeoCode. All rights reserved.
//

#import "ReviewDetailViewController.h"
#import "Review.h"
#import "EDStarRating.h"

#define kUsefulLabelHeight 25.f
@interface ReviewDetailViewController ()

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) TLabel *titleLabel;
@property (nonatomic,strong) UIImageView *avatorImageView;
@property (nonatomic,strong) TLabel *authorLabel;
@property (nonatomic,strong) EDStarRating *ratingView;
@property (nonatomic,strong) TLabel *dateLabel;
@property (nonatomic,strong) TLabel *contentLabel;
@property (nonatomic,strong) TLabel *usefulLabel;
@property (nonatomic,strong) TLabel *uselessCountLabel;

@property (nonatomic,assign) CGFloat lastOffsetY;
@property (nonatomic,assign) BOOL isScrolling;
@end

@implementation ReviewDetailViewController

#pragma - mark LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupRightBarItem];
    [self setupSubviews];
}
- (void)viewDidDisappear:(BOOL)animated{
    [self showNavigationBar];
    [super viewDidDisappear:animated];
}
#pragma mark - Public

#pragma mark - Private
- (void)setupSubviews{
    //加载UI
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.titleLabel];//标题
    [self.scrollView addSubview:self.avatorImageView];//头像
    [self.scrollView addSubview:self.authorLabel];//作者
    [self.scrollView addSubview:self.ratingView];//评分
    [self.scrollView addSubview:self.dateLabel];//时间
    [self.scrollView addSubview:self.contentLabel];//内容
    [self.scrollView addSubview:self.usefulLabel];//有用数
    [self.scrollView addSubview:self.uselessCountLabel];//无用数
    
    CGFloat horMargin = 10.f;
    
    //添加布局约束
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.scrollView.mas_leading).offset(horMargin);
        make.top.equalTo(self.scrollView.mas_top).offset(10.f);
        make.trailing.equalTo(self.scrollView.mas_trailing).offset(-horMargin);
        make.height.mas_greaterThanOrEqualTo(40.f);
        make.width.mas_equalTo(kViewWidth-2*horMargin);
    }];
    
    [self.avatorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.titleLabel.mas_leading);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10.f);
        make.width.mas_equalTo(20.f);
        make.height.mas_equalTo(20.f);
    }];
    [self.authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.avatorImageView.mas_trailing).offset(5.f);
        make.top.equalTo(self.avatorImageView.mas_top);
        make.width.mas_greaterThanOrEqualTo(10.f);
        make.height.mas_equalTo(20.f);
    }];
    
    [self.ratingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.authorLabel.mas_trailing).offset(5.f);
        make.top.equalTo(self.avatorImageView.mas_top);
        make.width.mas_equalTo(100.f);
        make.height.mas_equalTo(20.f);
    }];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.scrollView.mas_trailing).offset(-horMargin);
        make.top.equalTo(self.avatorImageView.mas_top);
        make.width.mas_equalTo(130.f);
        make.height.mas_equalTo(20.f);
    }];

    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.scrollView.mas_leading).offset(horMargin);
        make.top.equalTo(self.avatorImageView.mas_bottom).offset(20.f);
        make.trailing.equalTo(self.scrollView.mas_trailing).offset(-horMargin);
        make.height.mas_greaterThanOrEqualTo(200.f);
        make.bottom.equalTo(self.usefulLabel.mas_top).offset(-60.f);
    }];
    [self.usefulLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLabel.mas_bottom).offset(60.f);
        make.height.mas_equalTo(kUsefulLabelHeight);
        make.trailing.equalTo(self.scrollView.mas_centerX).offset(-10.f);
        make.width.mas_greaterThanOrEqualTo(100.f);
        make.bottom.equalTo(self.scrollView.mas_bottom).offset(-60.f);
    }];
    [self.uselessCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.usefulLabel.mas_top);
        make.height.mas_equalTo(kUsefulLabelHeight);
        make.leading.equalTo(self.scrollView.mas_centerX).offset(10.f);
        make.width.equalTo(self.usefulLabel.mas_width);
    }];
    //设置数据
    self.titleLabel.text = self.review.title;
    [self.avatorImageView sd_setImageWithURL:[NSURL URLWithString:self.review.avatar]];
    self.authorLabel.text = self.review.author;
    if(self.review.content){
        NSString *tmp = [self.review.content trimWhitespace];
//        NSLog(@"%@",tmp);
        self.contentLabel.attributedText = [tmp attributedStringWithLineSpacing:5.f];
    }
    
    if(self.review.updatedAt){
        self.dateLabel.text = [self.review.updatedAt substringToIndex:16];
    }
    self.ratingView.rating = [self.review.rating floatValue];
    self.usefulLabel.text = [NSString stringWithFormat:@"有用 %@",[self.review.usefulCount stringValue]];
    self.uselessCountLabel.text = [NSString stringWithFormat:@"无用 %@",[self.review.uselessCount stringValue]];
}
- (void)setupRightBarItem{
    //收藏按钮
    UIButton *faverBtn = [[UIButton alloc]initWithFrame:CGRectMake(0.f, 0.f, 32.f, 32.f)];
    faverBtn.tintColor = [UIColor yellowColor];
    [faverBtn setImage:[UIImage imageNamed:@"star_unfav"] forState:UIControlStateNormal];
    [faverBtn setImage:[[UIImage imageNamed:@"star_fav"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateSelected];
    [faverBtn addTarget:self action:@selector(faverBtnClicekd:) forControlEvents:UIControlEventTouchUpInside];
    
    if([[DBUtil sharedUtil]  getObjectById:self.review.rId fromTable:TABLE_REVIEW]){
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
//- (void)faverBtnClicekd:(UIButton *)sender{
//    [MobClick event:@"UMEVentSaveReview"];
//    BOOL isSucceed = NO;
//    if(self.review){
//        if(!sender.selected){//收藏
//            NSDictionary *dic = [MTLJSONAdapter JSONDictionaryFromModel:self.review error:nil];
//            [[DBUtil sharedUtil] putObject:dic withId:self.review.rId intoTable:TABLE_REVIEW];
//            
//            if([[DBUtil sharedUtil]  getObjectById:self.review.rId fromTable:TABLE_REVIEW]){
//                [AFMInfoBanner showAndHideWithText:@"收藏成功" style:AFMInfoBannerStyleInfo];
//                sender.selected = !sender.selected;
//                isSucceed = YES;
//            }else{
//                [AFMInfoBanner showAndHideWithText:@"收藏失败" style:AFMInfoBannerStyleError];
//            }
//        }else{//取消收藏
//            [[DBUtil sharedUtil]  deleteObjectById:self.review.rId fromTable:TABLE_REVIEW];
//            if(![[DBUtil sharedUtil]  getObjectById:self.review.rId fromTable:TABLE_REVIEW]){
//                sender.selected = !sender.selected;
//                [AFMInfoBanner showAndHideWithText:@"已取消收藏" style:AFMInfoBannerStyleInfo];
//                isSucceed = YES;
//            }else{
//                [AFMInfoBanner showAndHideWithText:@"收藏失败" style:AFMInfoBannerStyleError];
//            }
//        }
//    }else{
//        [AFMInfoBanner showAndHideWithText:@"收藏失败" style:AFMInfoBannerStyleError];
//    }
//    if(isSucceed){
//        [[NSNotificationCenter defaultCenter]postNotificationName:NOTICE_COLLECTION_DATA_CHANGED object:nil];
//    }
//}
- (void)faverBtnClicekd:(UIButton *)sender{
    [MobClick event:@"UMEVentSaveMovie"];
    
    if(self.review){
        //UI立即响应
        sender.selected = !sender.selected;
        if(sender.selected){//收藏
            [AFMInfoBanner showAndHideWithText:@"收藏成功" style:AFMInfoBannerStyleInfo];
        }else{
            [AFMInfoBanner showAndHideWithText:@"已取消收藏" style:AFMInfoBannerStyleInfo];
        }
        
        //后台，数据操作
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE,0), ^{
            if(sender.selected){//收藏
                NSDictionary *dic = [MTLJSONAdapter JSONDictionaryFromModel:self.review error:nil];
                [[DBUtil sharedUtil] putObject:dic withId:self.review.rId intoTable:TABLE_REVIEW];
            }else{//取消收藏
                [[DBUtil sharedUtil]  deleteObjectById:self.review.rId fromTable:TABLE_REVIEW];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter]postNotificationName:NOTICE_COLLECTION_DATA_CHANGED object:nil];
            });
        });
    }else{
        [AFMInfoBanner showAndHideWithText:@"收藏失败" style:AFMInfoBannerStyleError];
    }
    
}
- (void)shareBtnClicekd:(UIButton *)sender{
    NSLog(@"shareBtnClicekd");

}
- (void)hideNavigationBar{
    self.navigationController.navigationBarHidden = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}
- (void)showNavigationBar{
    self.navigationController.navigationBarHidden = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];

}
- (void)showOrHideNav:(UITapGestureRecognizer *)tap{
    if(![self.navigationController.navigationBar isHidden]){
        [self hideNavigationBar];
    }else{
        [self showNavigationBar];
    }
}
#pragma mark - Protocol
#pragma mark - Custom Accessors
- (UIScrollView *)scrollView{
    if(!_scrollView){
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.showsVerticalScrollIndicator = YES;
    }
    return _scrollView;
}
- (TLabel *)titleLabel{
    if(!_titleLabel){
        _titleLabel = [[TLabel alloc]init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:18.f];
        _titleLabel.themeTextColorKey = THEME_COLOR_LABEL_DARK;
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}
- (UIImageView *)avatorImageView{
    if(!_avatorImageView){
        _avatorImageView = [[UIImageView alloc]init];
        _avatorImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _avatorImageView;
}
- (TLabel *)authorLabel{
    if(!_authorLabel){
        _authorLabel = [[TLabel alloc]init];
        _authorLabel.font = [UIFont systemFontOfSize:13.f];
        _authorLabel.themeTextColorKey = THEME_COLOR_LABEL_LIGHT;
    }
    return _authorLabel;
}
- (EDStarRating *)ratingView{
    if(!_ratingView){
        _ratingView = [[EDStarRating alloc]init];
        _ratingView.starImage = [[UIImage imageNamed:@"ratingstar"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        _ratingView.starHighlightedImage = [[UIImage imageNamed:@"ratingstar_activated"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        _ratingView.maxRating = 5.0;
        _ratingView.horizontalMargin = 15.0;
        [_ratingView setNeedsDisplay];
        _ratingView.displayMode=EDStarRatingDisplayHalf;

    }
    return _ratingView;
}
- (TLabel *)dateLabel{
    if(!_dateLabel){
        _dateLabel = [[TLabel alloc]init];
        _dateLabel.font = [UIFont systemFontOfSize:13.f];
        _dateLabel.themeTextColorKey = THEME_COLOR_LABEL_LIGHT;
        _dateLabel.textAlignment = NSTextAlignmentRight;
    }
    return _dateLabel;
}
- (TLabel *)contentLabel{
    if(!_contentLabel){
        _contentLabel = [[TLabel alloc]init];
        _contentLabel.font = [UIFont systemFontOfSize:17.f];
        _contentLabel.themeTextColorKey = THEME_COLOR_LABEL_LIGHT;
        _contentLabel.numberOfLines = 0;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showOrHideNav:)];
        _contentLabel.userInteractionEnabled = YES;
        _contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [_contentLabel addGestureRecognizer:tap];
    }
    return _contentLabel;
}
- (TLabel *)usefulLabel{
    if(!_usefulLabel){
        _usefulLabel = [[TLabel alloc]init];
        _usefulLabel.font = [UIFont systemFontOfSize:12.f];
        _usefulLabel.themeTextColorKey = THEME_COLOR_CELL_CONTENT;
        _usefulLabel.textAlignment = NSTextAlignmentCenter;
        _usefulLabel.themeBackgroundColorKey = THEME_COLOR_MENU_BACKGROUND;
        _usefulLabel.layer.cornerRadius = kUsefulLabelHeight/2;
        _usefulLabel.layer.masksToBounds = YES;
    }
    return _usefulLabel;
}
- (TLabel *)uselessCountLabel{
    if(!_uselessCountLabel){
        _uselessCountLabel = [[TLabel alloc]init];
        _uselessCountLabel.font = [UIFont systemFontOfSize:12.f];
        _uselessCountLabel.themeTextColorKey = THEME_COLOR_CELL_CONTENT;
        _uselessCountLabel.textAlignment = NSTextAlignmentCenter;
        _uselessCountLabel.themeBackgroundColorKey = THEME_COLOR_MENU_BACKGROUND;
        _uselessCountLabel.layer.cornerRadius = kUsefulLabelHeight/2;
        _uselessCountLabel.layer.masksToBounds = YES;
    }
    return _uselessCountLabel;
}

@end
