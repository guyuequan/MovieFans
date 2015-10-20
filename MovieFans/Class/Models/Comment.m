//
//  Comment.m
//  MovieFans
//
//  Created by Leo Gao on 15/9/11.
//  Copyright (c) 2015年 LeoCode. All rights reserved.
//

#import "Comment.h"

@implementation Comment

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"cId": @"id",
             @"subjectId": @"subject_id",
             @"author": @"author.name",
             @"avatar": @"author.avatar",
             @"createdAt": @"created_at",
             @"content": @"content",
             @"rating": @"rating.value",
             @"usefulCount": @"useful_count"
             };
}

@end
