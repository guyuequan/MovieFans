//
//  MovieSimple.h
//  TVFans
//
//  Created by Leo Gao on 2/18/15.
//  Copyright (c) 2015 LeoCode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface MovieSimple : NSObject<NSCoding>
@property (nonatomic,strong) NSString *movieID;
@property (nonatomic,strong) NSString *movieName;//片名
@property (nonatomic,strong) NSString *posterPathMedium;//海报
@property (nonatomic,strong) NSString *posterPathLarge;//清晰海报路径
@property (nonatomic,strong) NSArray *categoryArr;//分类
@property (nonatomic,strong) NSString *country;//国家
@property (nonatomic,strong) NSNumber *rating;//评分
@property (nonatomic,strong) NSString *pubDate;//上映日期
@property (nonatomic,strong) NSString *year;//年代
@property (nonatomic,strong) NSString *rank;//排名/序号
@property (nonatomic,strong) NSString *wishSee;//多少人想看
@end
