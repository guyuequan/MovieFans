//
//  Movie.h
//  MovieFans
//
//  Created by Leo Gao on 15/9/15.
//  Copyright (c) 2015年 LeoCode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Cover.h"

@interface Movie : MTLModel<MTLJSONSerializing>
@property (nonatomic,copy) NSString *mId;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *originalTitle;//原名
@property (nonatomic,strong) NSArray *akaArray; //又名
@property (nonatomic,copy) NSString *alt;//条目页URL
@property (nonatomic,copy) NSString *mobileUrl;	//移动版条目页URL
@property (nonatomic,strong) NSNumber *rating;	//评分
@property (nonatomic,copy) NSNumber *ratingsCount;	//评分人数
@property (nonatomic,copy) NSNumber *wishCount;	//想看人数
@property (nonatomic,copy) NSNumber *collectCount;	//看过人数
@property (nonatomic,copy) NSNumber *doCount;	//在看人数，如果是电视剧，默认值为0，如果是电影值为null
@property (nonatomic,strong) Cover *images;	//电影海报图，分别提供288px x 465px(大)，96px x 155px(中) 64px x 103px(小)尺寸
@property (nonatomic,strong) NSArray *directors;	//导演，数据结构为影人的简化描述，见附录	array
@property (nonatomic,strong) NSArray *casts;	//主演，最多可获得4个，数据结构为影人的简化描述，见附录	array	
@property (nonatomic,strong) NSArray *writers;	//编剧，数据结构为影人的简化描述，见附录	array
@property (nonatomic,copy) NSString *website;	//官方网站	str
@property (nonatomic,copy) NSString *doubanSite;	//豆瓣小站	str
@property (nonatomic,copy) NSString *pubdate;	//如果条目类型是电影则为上映日期，如果是电视剧则为首Ï日期	array
@property (nonatomic,copy) NSString *mainlandPubdate;	//大陆上映日期，如果条目类型是电影则为上映日期，如果是电视剧则为首播日期		''
@property (nonatomic,copy) NSString *year;	//年代	str
@property (nonatomic,strong) NSArray *languages;	//语言	array
@property (nonatomic,copy) NSString *duration;	//片长
@property (nonatomic,strong) NSArray *genres;	//影片类型，最多提供3个	array
@property (nonatomic,strong) NSArray *countries;	//制片国家/地区	array	Y	Y	Y	[]
@property (nonatomic,copy) NSString *summary;	//简介	str	Y	Y	Y	''
@property (nonatomic,copy) NSNumber *commentsCount; //短评数量	int	Y	Y	Y	0
@property (nonatomic,copy) NSNumber *reviewsCount;	//影评数量	int	Y	Y	Y	0
@property (nonatomic,copy) NSString *scheduleUrl;	//影讯页URL(movie only)	str	Y	Y	Y	''
@property (nonatomic,strong) NSArray *trailerUrls;	//预告片URL，对高级用户以上开放，最多开放4个地址	array	N	Y	Y	[]
@property (nonatomic,strong) NSArray *clipUrls;	//片段URL，对高级用户以上开放，最多开放4个地址	array	N	Y	Y	[]
@property (nonatomic,strong) NSArray *blooperUrls;	//花絮URL，对高级用户以上开放，最多开放4个地址	array	N	Y	Y	[]
@property (nonatomic,strong) NSArray *photos;	//电影剧照，前10张，见附录	array	N	Y	Y	[]
@property (nonatomic,strong) NSArray *popularReviews; //影评，前10条，影评结构，见附录
@property (nonatomic,strong) NSArray *popularComments; //热门短评
@end
