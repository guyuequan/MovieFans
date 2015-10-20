//
//  DBUtil.m
//  MovieFans
//
//  Created by Leo Gao on 15/9/21.
//  Copyright © 2015年 LeoCode. All rights reserved.
//

#import "DBUtil.h"

@implementation DBUtil

+ (instancetype)sharedUtil{
    static DBUtil *sharedInstance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] initDBWithName:DB_NAME];
    });
    return sharedInstance;
}

@end
