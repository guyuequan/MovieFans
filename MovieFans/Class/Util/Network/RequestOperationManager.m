//
//  BanRequestOperationManager.m
//  Ban
//
//  Created by Leo Gao on 15/7/9.
//  Copyright (c) 2015年 LeoCode. All rights reserved.
//

#import "RequestOperationManager.h"

@implementation RequestOperationManager
+ (instancetype)sharedJsonClient {
    static RequestOperationManager *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[RequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
    [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    return self;
}


- (void)requestJsonDataWithPath:(NSString *)aPath
                     withParams:(NSDictionary*)params
                 withMethodType:(int)NetworkMethod
                       andBlock:(void (^)(id data, NSError *error))block{
    [self requestJsonDataWithPath:aPath withParams:params withMethodType:NetworkMethod autoShowError:YES andBlock:block];
}

- (void)requestJsonDataWithPath:(NSString *)aPath
                     withParams:(NSDictionary*)params
                 withMethodType:(int)NetworkMethod
                  autoShowError:(BOOL)autoShowError
                       andBlock:(void (^)(id data, NSError *error))block{
    if (!aPath || aPath.length <= 0) {
        return;
    }
    
    
    //检查网络是否接通
    
     //log请求数据
    DebugLog(@"\n===========request===========\n%@%@?apikey=%@\n%@",kBaseUrl,aPath,kApiKey4Douban,params);
    aPath = [aPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //发起请求
    switch (NetworkMethod) {
        case NetworkMethodGet:{
            [self GET:aPath parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                DebugLog(@"\n===========response===========\n%@:\n%@", aPath, responseObject);
                id error = [self handleResponse:responseObject autoShowError:autoShowError];
                if (error) {
                    block(nil, error);
                }else{
                    block(responseObject,nil);
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                DebugLog(@"\n===========response===========\n%@:\n%@", aPath, error);
                [self showNetworkWithError:error];
                block(nil, error);
            }];
            break;}
        case NetworkMethodPost:{
            [self POST:aPath parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                DebugLog(@"\n===========response===========\n%@:\n%@", aPath, responseObject);
                id error = [self handleResponse:responseObject autoShowError:autoShowError];
                if (error) {
                    block(nil, error);
                }else{
                     block(responseObject,nil);
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                DebugLog(@"\n===========response===========\n%@:\n%@", aPath, error);
                [self showNetworkWithError:error];
                block(nil, error);
            }];
            break;}
        case NetworkMethodPut:{
            [self PUT:aPath parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                DebugLog(@"\n===========response===========\n%@:\n%@", aPath, responseObject);
                id error = [self handleResponse:responseObject autoShowError:autoShowError];
                if (error) {
                    block(nil, error);
                }else{
                     block(responseObject,nil);
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                DebugLog(@"\n===========response===========\n%@:\n%@", aPath, error);
                [self showNetworkWithError:error];
                block(nil, error);
            }];
            break;}
        case NetworkMethodDelete:{
            [self DELETE:aPath parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                DebugLog(@"\n===========response===========\n%@:\n%@", aPath, responseObject);
                id error = [self handleResponse:responseObject autoShowError:autoShowError];
                if (error) {
                    block(nil, error);
                }else{
                     block(responseObject,nil);
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                DebugLog(@"\n===========response===========\n%@:\n%@", aPath, error);
                [self showNetworkWithError:error];
                block(nil, error);
            }];}
        default:
            break;
    }
    
}
- (void)showNetworkWithError:(NSError*)error{
    [[[UIApplication sharedApplication] keyWindow] makeToast:error.localizedDescription duration:2 position:CSToastPositionCenter];
    
}
-(id)handleResponse:(id)responseJSON autoShowError:(BOOL)autoShowError{
    NSError *error = nil;

    //网络请求错误统一处理
//     if([responseJSON isKindOfClass:[NSDictionary class]]&&[responseJSON[@"state"] integerValue]!=0){
//         if(autoShowError){
//             [[[UIApplication sharedApplication] keyWindow] makeToast:@"网络请求出错!" duration:2 position:CSToastPositionBottom];
//         }
//         error = [NSError errorWithDomain:kBaseUrl code:[responseJSON[@"state"] integerValue] userInfo:responseJSON];
//     }
    
    //example:code为非0值时，表示有错
//    NSNumber *resultCode = [responseJSON valueForKeyPath:@"code"];
//    
//    if (resultCode.intValue != 0) {
//        error = [NSError errorWithDomain:kUrlServerBase code:resultCode.intValue userInfo:responseJSON];
//        if (autoShowError) {
////            [self showError:error];
//        }
////        if (resultCode.intValue == 1000) {//用户未登录
////            [Login doLogout];
////            [((AppDelegate *)[UIApplication sharedApplication].delegate) setupIntroductionViewController];
////        }
//    }
    return error;
}
@end
