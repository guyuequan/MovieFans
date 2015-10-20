//
//  celebrity.m
//  MovieFans
//
//  Created by Leo Gao on 15/9/16.
//  Copyright (c) 2015年 LeoCode. All rights reserved.
//

#import "Celebrity.h"
#import "Photo.h"
#import "Work.h"

@implementation Celebrity
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"cId": @"id",
             @"name": @"name",
             @"nameEn": @"name_en",
             @"alt": @"alt",
             @"aka": @"aka",
             @"mobileUrl": @"mobile_url",
             @"mobileUrl": @"mobile_url",
             @"avatars": @"avatars",
             @"summary": @"summary",
             @"gender": @"gender",
             @"birthday": @"birthday",
             @"bornPlace": @"born_place",
             @"professions": @"professions",
             @"website": @"website",
             @"photos": @"photos",
             @"works": @"works"
             };
}
+ (NSValueTransformer *)avatarsJSONTransformer {
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
+ (NSValueTransformer *)worksJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSArray *array,BOOL *success, NSError *__autoreleasing *error) {
        NSMutableArray *mArray = [NSMutableArray array];
        if([array isKindOfClass:[NSArray class]]){
            for(int i=0;i<[array count];i++){
                Work *work = [MTLJSONAdapter modelOfClass:[Work class] fromJSONDictionary:array[i] error:nil];
                if(work){
                    [mArray addObject:work];
                }
            }
        }
        return mArray;
    } reverseBlock:^id(NSArray *works, BOOL *success, NSError *__autoreleasing *error) {
        if(works){
            return [MTLJSONAdapter JSONArrayFromModels:works error:nil];
        }else{
            return @[];
        }
    }];
}
@end
