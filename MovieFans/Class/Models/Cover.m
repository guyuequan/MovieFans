//
//  Cover.m
//  MovieFans
//
//  Created by Leo Gao on 15/9/16.
//  Copyright (c) 2015年 LeoCode. All rights reserved.
//

#import "Cover.h"

@implementation Cover
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"large": @"large",
             @"medium": @"medium",
             @"small": @"small"
             };
}
@end
