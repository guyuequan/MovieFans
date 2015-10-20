//
//  MTLModel+MTLNullableScalar.h
//  Ban
//
//  Created by Leo Gao on 15/7/28.
//  Copyright (c) 2015年 Leo Gao. All rights reserved.
//

#import "MTLModel.h"

@interface MTLModel (MTLNullableScalar)
- (void)setNilValueForKey:(NSString *)key;
@end
