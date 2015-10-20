//
//  Review.m
//  MovieFans
//
//  Created by Leo Gao on 15/9/13.
//  Copyright (c) 2015年 LeoCode. All rights reserved.
//

#import "Review.h"

@implementation Review

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"rId": @"id",
             @"title": @"title",
             @"subjectId": @"subject_id",
             @"alt": @"alt",
             @"author": @"author.name",
             @"createdAt": @"created_at",
             @"updatedAt": @"updated_at",
             @"summary": @"summary",
             @"content": @"content",
             @"rating": @"rating.value",
             @"usefulCount": @"useful_count",
             @"uselessCount": @"useless_count",
             @"commentsCount": @"comments_count",
             @"avatar": @"author.avatar"
             };
}

@end
