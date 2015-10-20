//
//  DBUtil.h
//  MovieFans
//
//  Created by Leo Gao on 15/9/21.
//  Copyright © 2015年 LeoCode. All rights reserved.
//

#import "YTKKeyValueStore.h"

@interface DBUtil : YTKKeyValueStore

+ (instancetype)sharedUtil;
@end
