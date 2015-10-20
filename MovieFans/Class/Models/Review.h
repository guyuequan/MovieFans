//
//  Review.h
//  MovieFans
//
//  Created by Leo Gao on 15/9/13.
//  Copyright (c) 2015年 LeoCode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Review : MTLModel<MTLJSONSerializing>

@property (nonatomic,copy) NSString *rId;//影评id
@property (nonatomic,copy) NSString *title;//影评名
@property (nonatomic,strong) NSString *avatar;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *alt;	//影评url
@property (nonatomic,copy) NSString *createdAt;	//发布日期	str
@property (nonatomic,copy) NSString *updatedAt;//	更新日期	str
@property (nonatomic,copy) NSString *subjectId;	//条目id	str
@property (nonatomic,copy) NSString *author;	//上传用户，见附录
@property (nonatomic,copy) NSString *summary;	//摘要，100字以内	str
@property (nonatomic,strong) NSNumber *rating;	//影评评分，
@property (nonatomic,strong) NSNumber *usefulCount;	//有用数	int
@property (nonatomic,strong) NSNumber *uselessCount;	//无用数	int
@property (nonatomic,strong) NSNumber *commentsCount;	//评论数
@end
