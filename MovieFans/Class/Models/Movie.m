//
//  Movie.m
//  MovieFans
//
//  Created by Leo Gao on 15/9/15.
//  Copyright (c) 2015年 LeoCode. All rights reserved.
//

#import "Movie.h"
#import "Celebrity.h"
#import "Photo.h"
#import "Review.h"
#import "Comment.h"

@implementation Movie
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"mId": @"id",
             @"title": @"title",
             @"originalTitle": @"original_title",
             @"akaArray": @"aka",
             @"alt": @"alt",
             @"mobileUrl": @"mobile_url",
             @"rating": @"rating.average",
             @"ratingsCount": @"ratings_count",
             @"wishCount": @"wish_count",
             @"collectCount": @"collect_count",
             @"doCount": @"do_count",
             @"images": @"images",
             @"directors": @"directors",
             @"casts": @"casts",
             @"writers": @"writers",
             @"website": @"website",
             @"doubanSite": @"douban_site",
             @"pubdate": @"pubdate",
             @"mainlandPubdate": @"mainland_pubdate",
             @"year": @"year",
             @"languages": @"languages",
             @"duration": @"durations",
             @"genres": @"genres",
             @"countries": @"countries",
             @"summary": @"summary",
             @"commentsCount": @"comments_count",
             @"reviewsCount": @"reviews_count",
             @"scheduleUrl": @"schedule_url",
             @"trailerUrls": @"trailer_urls",
             @"clipUrls": @"clip_urls",
             @"blooperUrls": @"blooper_urls",
             @"photos": @"photos",
             @"popularReviews": @"popular_reviews",
             @"popularComments": @"popular_comments"
             };
}
+ (NSValueTransformer *)directorsJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSArray *array,BOOL *success, NSError *__autoreleasing *error) {
        NSMutableArray *mArray = [NSMutableArray array];
        for(int i=0;i<[array count];i++){
            NSDictionary *dic = array[i];
            Celebrity *celebrity = [MTLJSONAdapter modelOfClass:[Celebrity class] fromJSONDictionary:dic error:nil];
            if(celebrity){
                [mArray addObject:celebrity];
            }
        }
        return mArray;
    } reverseBlock:^id(NSArray *celebrities, BOOL *success, NSError *__autoreleasing *error) {
        if(celebrities){
            return [MTLJSONAdapter JSONArrayFromModels:celebrities error:nil];
        }else{
            return @[];
        }
    }];
}
+ (NSValueTransformer *)castsJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSArray *array,BOOL *success, NSError *__autoreleasing *error) {
        NSMutableArray *mArray = [NSMutableArray array];
        for(int i=0;i<[array count];i++){
            NSDictionary *dic = array[i];
            Celebrity *celebrity = [MTLJSONAdapter modelOfClass:[Celebrity class] fromJSONDictionary:dic error:nil];
            if(celebrity){
                [mArray addObject:celebrity];
            }
        }
        return mArray;
    } reverseBlock:^id(NSArray *celebrities, BOOL *success, NSError *__autoreleasing *error) {
        if(celebrities){
            return [MTLJSONAdapter JSONArrayFromModels:celebrities error:nil];
        }else{
            return @[];
        }
    }];
}
+ (NSValueTransformer *)writersJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSArray *array,BOOL *success, NSError *__autoreleasing *error) {
        NSMutableArray *mArray = [NSMutableArray array];
        for(int i=0;i<[array count];i++){
            NSDictionary *dic = array[i];
            Celebrity *celebrity = [MTLJSONAdapter modelOfClass:[Celebrity class] fromJSONDictionary:dic error:nil];
            if(celebrity){
                [mArray addObject:celebrity];
            }
        }
        return mArray;
    } reverseBlock:^id(NSArray *celebrities, BOOL *success, NSError *__autoreleasing *error) {
        if(celebrities){
            return [MTLJSONAdapter JSONArrayFromModels:celebrities error:nil];
        }else{
            return @[];
        }
    }];
}
+ (NSValueTransformer *)imagesJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSDictionary *dic,BOOL *success, NSError *__autoreleasing *error) {
        Cover *cover = [MTLJSONAdapter modelOfClass:[Cover class] fromJSONDictionary:dic error:nil];
        return cover;
    } reverseBlock:^id(Cover *cover, BOOL *success, NSError *__autoreleasing *error) {
        if(cover){
            return [MTLJSONAdapter JSONDictionaryFromModel:cover error:nil];
        }else{
            return @"";
        }
    }];
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
    } reverseBlock:^id(NSString *string, BOOL *success, NSError *__autoreleasing *error) {
        if(string&&![string isEmpty]){
            return @[string];
        }else{
            return @[];
        }
    }];
}
+ (NSValueTransformer *)photosJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSArray *array,BOOL *success, NSError *__autoreleasing *error) {
        NSMutableArray *mArray = [NSMutableArray array];
        for(int i=0;i<[array count];i++){
            NSDictionary *dic = array[i];
            Photo *photo = [MTLJSONAdapter modelOfClass:[Photo class] fromJSONDictionary:dic error:nil];
            if(photo){
                [mArray addObject:photo];
            }
        }
        return mArray;
    } reverseBlock:^id(NSArray *photos, BOOL *success, NSError *__autoreleasing *error) {
        if(photos){
            return [MTLJSONAdapter JSONArrayFromModels:photos error:nil];
        }else{
            return @[];
        }
    }];
}
+ (NSValueTransformer *)popularReviewsJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSArray *array,BOOL *success, NSError *__autoreleasing *error) {
        NSMutableArray *mArray = [NSMutableArray array];
        for(int i=0;i<[array count];i++){
            NSDictionary *dic = array[i];
            Review *review = [MTLJSONAdapter modelOfClass:[Review class] fromJSONDictionary:dic error:nil];
            if(review){
                [mArray addObject:review];
            }
        }
        return mArray;
    } reverseBlock:^id(NSArray *reviews, BOOL *success, NSError *__autoreleasing *error) {
        if(reviews){
            return [MTLJSONAdapter JSONArrayFromModels:reviews error:nil];
        }else{
            return @[];
        }
    }];
}
+ (NSValueTransformer *)popularCommentsJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSArray *array,BOOL *success, NSError *__autoreleasing *error) {
        NSMutableArray *mArray = [NSMutableArray array];
        for(int i=0;i<[array count];i++){
            NSDictionary *dic = array[i];
            Comment *comment = [MTLJSONAdapter modelOfClass:[Comment class] fromJSONDictionary:dic error:nil];
            if(comment){
                [mArray addObject:comment];
            }
        }
        return mArray;
    } reverseBlock:^id( NSArray *comments, BOOL *success, NSError *__autoreleasing *error) {
        if(comments){
            return [MTLJSONAdapter JSONArrayFromModels:comments error:nil];
        }else{
            return @[];
        }
    }];
}
@end
