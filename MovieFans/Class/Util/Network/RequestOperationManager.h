//
//  BanRequestOperationManager.h
//  Ban
//
//  Created by Leo Gao on 15/7/9.
//  Copyright (c) 2015年 LeoCode. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"
#import "ApiUrl.h"

typedef NS_ENUM(NSInteger,NetworkMethod){
    NetworkMethodGet = 0,
    NetworkMethodPost,
    NetworkMethodPut,
    NetworkMethodDelete
};

@interface RequestOperationManager : AFHTTPRequestOperationManager
+ (instancetype)sharedJsonClient;

/**
 *  请求json数据
 *
 *  @param aPath         url 字符串
 *  @param params        请求参数
 *  @param NetworkMethod 请求方式（get,post,put,delegate)
 *  @param block         请求完成完成回调
 */
- (void)requestJsonDataWithPath:(NSString *)aPath
                     withParams:(NSDictionary*)params
                 withMethodType:(int)NetworkMethod
                       andBlock:(void (^)(id data, NSError *error))block;

- (void)requestJsonDataWithPath:(NSString *)aPath
                     withParams:(NSDictionary*)params
                 withMethodType:(int)NetworkMethod
                  autoShowError:(BOOL)autoShowError
                       andBlock:(void (^)(id data, NSError *error))block;

@end
