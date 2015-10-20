//
//  Work.m
//  MovieFans
//
//  Created by Leo Gao on 15/9/22.
//  Copyright © 2015年 LeoCode. All rights reserved.
//

#import "Work.h"
#import "MovieSubject.h"

@implementation Work

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"roles": @"roles",
             @"subject": @"subject",
             };
}

+ (NSValueTransformer *)subjectJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSDictionary *dic,BOOL *success, NSError *__autoreleasing *error) {
        MovieSubject *subject = [MTLJSONAdapter modelOfClass:[MovieSubject class] fromJSONDictionary:dic error:nil];
        return subject;
    } reverseBlock:^id(MovieSubject *subject , BOOL *success, NSError *__autoreleasing *error) {
        if(subject){
            return [MTLJSONAdapter JSONDictionaryFromModel:subject error:nil];
        }else{
            return @"";
        }
    }];
}
@end
