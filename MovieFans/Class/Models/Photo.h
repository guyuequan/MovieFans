//
//  Photo.h
//  MovieFans
//
//  Created by Leo Gao on 15/9/16.
//  Copyright (c) 2015年 LeoCode. All rights reserved.
//

#import "MTLModel.h"

/**
 *  剧照
 */
@interface Photo : MTLModel<MTLJSONSerializing>

@property (nonatomic,copy) NSString *cId;//图片id
@property (nonatomic,copy) NSString *subjectId;//条目id
@property (nonatomic,copy) NSString *alt;//	图片展示页url
@property (nonatomic,copy) NSString *icon;//	图片地址，icon尺寸;
@property (nonatomic,copy) NSString *image;//	图片地址，image尺寸
@property (nonatomic,copy) NSString *thumb;//	图片地址，thumb尺寸
@property (nonatomic,copy) NSString *cover;	//图片地址，cover尺寸
@property (nonatomic,copy) NSString *createdAt;	//发布日期
@property (nonatomic,copy) NSString *desc;	//图片描述
@property (nonatomic,copy) NSString *author;	//上传用户;
@property (nonatomic,copy) NSString *albumId; //相册id
@property (nonatomic,copy) NSString *albumTitle; //相册标题
@property (nonatomic,copy) NSString *albumUrl;//	相册地址
@property (nonatomic,strong) NSNumber *commentsCount;	//评论数
@property (nonatomic,strong) NSNumber *photosCount;	//全部剧照数量

@end
