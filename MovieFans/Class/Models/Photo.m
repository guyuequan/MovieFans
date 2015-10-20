//
//  Photo.m
//  MovieFans
//
//  Created by Leo Gao on 15/9/16.
//  Copyright (c) 2015年 LeoCode. All rights reserved.
//

#import "Photo.h"

@implementation Photo
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"cId": @"id",
             @"subjectId": @"subject_id",
             @"alt": @"alt",
             @"icon": @"icon",
             @"image": @"image",
             @"thumb": @"thumb",
             @"cover": @"cover",
             @"createdAt": @"created_at",
             @"desc": @"desc",
             @"author": @"author.name",
             @"albumId": @"album_id",
             @"albumTitle": @"album_title",
             @"albumUrl": @"album_url",
             @"commentsCount": @"comments_count",
             @"photosCount": @"photos_count"
             };
}
@end
