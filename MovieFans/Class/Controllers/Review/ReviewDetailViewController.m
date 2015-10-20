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

@interface ReviewDetailViewController ()

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) TLabel *titleLabel;
@property (nonatomic,strong) UIImageView *avatorImageView;
@property (nonatomic,strong) TLabel *authorLabel;
@property (nonatomic,strong) EDStarRating *ratingView;
@property (nonatomic,strong) TLabel *dateLabel;
@property (nonatomic,strong) TLabel *contentLabel;

@end

@implementation ReviewDetailViewController

#pragma - mark LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupRightBarItem];
    [self setupSubviews];
}

#pragma mark - Public

#pragma mark - Private
- (void)setupSubviews{
    //加载UI
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.titleLabel];
    [self.scrollView addSubview:self.avatorImageView];
    [self.scrollView addSubview:self.authorLabel];
    [self.scrollView addSubview:self.ratingView];
    [self.scrollView addSubview:self.dateLabel];
    [self.scrollView addSubview:self.contentLabel];
    
    CGFloat horMargin = 15.f;
    
    //添加布局约束
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.scrollView.mas_leading).offset(horMargin);
        make.top.equalTo(self.scrollView.mas_top).offset(5.f);
        make.trailing.equalTo(self.scrollView.mas_trailing).offset(-horMargin);
        make.height.mas_greaterThanOrEqualTo(40.f);
        make.width.mas_equalTo(kViewWidth-2*horMargin);
    }];
    
    [self.avatorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.titleLabel.mas_leading);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5.f);
        make.width.mas_equalTo(20.f);
        make.height.mas_equalTo(20.f);
    }];
    [self.authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.avatorImageView.mas_trailing).offset(10.f);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5.f);
        make.width.mas_greaterThanOrEqualTo(10.f);
        make.height.mas_equalTo(20.f);
    }];
    
    [self.ratingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.authorLabel.mas_trailing).offset(5.f);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5.f);
        make.width.mas_equalTo(100.f);
        make.height.mas_equalTo(20.f);
    }];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.scrollView.mas_trailing).offset(-10.f);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5.f);
        make.width.mas_equalTo(130.f);
        make.height.mas_equalTo(20.f);
    }];

    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.scrollView.mas_leading).offset(horMargin);
        make.top.equalTo(self.avatorImageView.mas_bottom).offset(20.f);
        make.trailing.equalTo(self.scrollView.mas_trailing).offset(-horMargin);
        make.height.mas_greaterThanOrEqualTo(200.f);
        make.bottom.equalTo(self.scrollView.mas_bottom).offset(-60.f);
    }];
    
    //设置数据
    self.titleLabel.text = self.review.title;
    [self.avatorImageView sd_setImageWithURL:[NSURL URLWithString:self.review.avatar]];
    self.authorLabel.text = self.review.author;
    if(self.review.content){
        self.contentLabel.attributedText = [self.review.content attributedStringWithLineSpacing:5.f];
    }
    if(self.review.updatedAt){
        self.dateLabel.text = [self.review.updatedAt substringToIndex:16];
    }
    self.ratingView.rating = [self.review.rating floatValue];
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
- (void)faverBtnClicekd:(UIButton *)sender{
    [MobClick event:@"UMEVentSaveReview"];
    BOOL isSucceed = NO;
    if(self.review){
        if(!sender.selected){//收藏
            NSDictionary *dic = [MTLJSONAdapter JSONDictionaryFromModel:self.review error:nil];
            [[DBUtil sharedUtil] putObject:dic withId:self.review.rId intoTable:TABLE_REVIEW];
            
            if([[DBUtil sharedUtil]  getObjectById:self.review.rId fromTable:TABLE_REVIEW]){
                [AFMInfoBanner showAndHideWithText:@"收藏成功" style:AFMInfoBannerStyleInfo];
                sender.selected = !sender.selected;
                isSucceed = YES;
            }else{
                [AFMInfoBanner showAndHideWithText:@"收藏失败" style:AFMInfoBannerStyleError];
            }
        }else{//取消收藏
            [[DBUtil sharedUtil]  deleteObjectById:self.review.rId fromTable:TABLE_REVIEW];
            if(![[DBUtil sharedUtil]  getObjectById:self.review.rId fromTable:TABLE_REVIEW]){
                sender.selected = !sender.selected;
                [AFMInfoBanner showAndHideWithText:@"已取消收藏" style:AFMInfoBannerStyleInfo];
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
    NSLog(@"shareBtnClicekd");

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
//        _titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
        _titleLabel.font = [UIFont boldSystemFontOfSize:17.f];
//        _titleLabel.textColor = [UIColor colorWithHexString:@"0x111111"];
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
//        _authorLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
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
        //        _dateLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
        _dateLabel.font = [UIFont systemFontOfSize:13.f];
        //        _dateLabel.textColor = [UIColor lightGrayColor];
        _dateLabel.themeTextColorKey = THEME_COLOR_LABEL_LIGHT;
        _dateLabel.textAlignment = NSTextAlignmentRight;
    }
    return _dateLabel;
}
- (TLabel *)contentLabel{
    if(!_contentLabel){
        _contentLabel = [[TLabel alloc]init];
        _contentLabel.font = [UIFont systemFontOfSize:15.f];
//        _contentLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
//        _contentLabel.textColor = [UIColor darkGrayColor];
        _contentLabel.themeTextColorKey = THEME_COLOR_LABEL_LIGHT;
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

@end
