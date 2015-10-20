//
//  MTLModel+MTLNullableScalar.m
//  Ban
//
//  Created by Leo Gao on 15/7/28.
//  Copyright (c) 2015年 Leo Gao. All rights reserved.
//

#import "MTLModel+MTLNullableScalar.h"

@implementation MTLModel (MTLNullableScalar)
- (void)setNilValueForKey:(NSString *)key {
    [self setValue:@0 forKey:key];  // For NSInteger/CGFloat/BOOL
}
@end
