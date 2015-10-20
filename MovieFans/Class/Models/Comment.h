//
//  Comment.h
//  MovieFans
//
//  Created by Leo Gao on 15/9/11.
//  Copyright (c) 2015年 LeoCode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Comment : MTLModel<MTLJSONSerializing>

@property (nonatomic,copy) NSString *author;
@property (nonatomic,copy) NSNumber *rating;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,strong) NSString *avatar;
@property (nonatomic,copy) NSString *cId;//影评id
@property (nonatomic,copy) NSString *createdAt;	//发布日期	str
@property (nonatomic,copy) NSString *subjectId;	//条目id	str
@property (nonatomic,strong) NSNumber *usefulCount;	//有用数	int

@end
