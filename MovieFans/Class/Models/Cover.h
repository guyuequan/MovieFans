//
//  Cover.h
//  MovieFans
//
//  Created by Leo Gao on 15/9/16.
//  Copyright (c) 2015年 LeoCode. All rights reserved.
//

#import "MTLModel.h"
/**
 *  封面、头像
 */
@interface Cover : MTLModel<MTLJSONSerializing>
@property (nonatomic,copy) NSString *large;
@property (nonatomic,copy) NSString *medium;
@property (nonatomic,copy) NSString *small;
@end
