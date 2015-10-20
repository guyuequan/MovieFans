//
//  MovieSubject.m
//  MovieFans
//
//  Created by Leo Gao on 15/9/22.
//  Copyright © 2015年 LeoCode. All rights reserved.
//

#import "MovieSubject.h"
#import "Cover.h"

@implementation MovieSubject


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"mId": @"id",
             @"title": @"title",
             @"originalTitle": @"original_title",
             @"alt": @"alt",
             @"year": @"year",
             @"rating": @"rating.average",
             @"pubdateStr": @"pubdates",
             @"duration": @"durations",
             @"genres": @"genres",
             @"images": @"images",
             };
}

+ (NSValueTransformer *)durationJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id obj,BOOL *success, NSError *__autoreleasing *error) {
        NSString *duration;
        if([obj isKindOfClass:[NSArray class]]){
            duration = [obj firstObject];
        }else{
            duration = [NSString stringWithFormat:@"%@",obj];
        }
        return duration;
    } reverseBlock:^id( NSString *string, BOOL *success, NSError *__autoreleasing *error) {
        if(string&&![string isEmpty]){
            return @[string];
        }else{
            return @[];
        }
    }];
}
+ (NSValueTransformer *)pubdateStrJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id obj,BOOL *success, NSError *__autoreleasing *error) {
        NSString *pubdate;
        if([obj isKindOfClass:[NSArray class]]){
            pubdate = [obj firstObject];
        }else{
            pubdate = [NSString stringWithFormat:@"%@",obj];
        }
        return pubdate;
    } reverseBlock:^id( NSString *string, BOOL *success, NSError *__autoreleasing *error) {
        if(string&&![string isEmpty]){
            return @[string];
        }else{
            return @[];
        }
    }];
}
+ (NSValueTransformer *)imagesJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSDictionary *dic,BOOL *success, NSError *__autoreleasing *error) {
        Cover *cover = [MTLJSONAdapter modelOfClass:[Cover class] fromJSONDictionary:dic error:nil];
        if(cover){
            return cover;
        }else{
            return [[Cover alloc]init];
        }
    } reverseBlock:^id(Cover *cover, BOOL *success, NSError *__autoreleasing *error) {
        if(cover){
            return [MTLJSONAdapter JSONDictionaryFromModel:cover error:nil];
        }else{
            return @"";
        }
    }];
}
@end
