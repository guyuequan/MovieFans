//
//  celebrity.h
//  MovieFans
//
//  Created by Leo Gao on 15/9/16.
//  Copyright (c) 2015年 LeoCode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Cover.h"
/**
 *  影人
 */
@interface Celebrity : MTLModel<MTLJSONSerializing>

@property (nonatomic,copy) NSString *cId;//条目ID
@property (nonatomic,copy) NSString *name;//姓名
@property (nonatomic,copy) NSString *nameEn;//英文名
@property (nonatomic,copy) NSString *alt; //条目页URL
@property (nonatomic,strong) NSArray *aka; //别名
@property (nonatomic,copy) NSString *mobileUrl;//移动版url
@property (nonatomic,strong) Cover *avatars; //影人头像
@property (nonatomic,copy) NSString *summary;//简介
@property (nonatomic,copy) NSString *gender;//性别
@property (nonatomic,copy) NSString *birthday;//生日
@property (nonatomic,copy) NSString *bornPlace;//出生地
@property (nonatomic,copy) NSString *constellation;//星座
@property (nonatomic,strong) NSArray *professions;//职业
@property (nonatomic,copy) NSString *website;//官方网址
@property (nonatomic,strong) NSArray *photos;//剧照
@property (nonatomic,strong) NSArray *works;//作品

@end
