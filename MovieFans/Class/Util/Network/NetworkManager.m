//
//  BanNetworkManager.m
//  Ban
//
//  Created by Leo Gao on 15/7/9.
//  Copyright (c) 2015年 LeoCode. All rights reserved.
//

#import "NetworkManager.h"
#import "RequestOperationManager.h"
#import "Movie.h"
#import "Celebrity.h"

@implementation NetworkManager
+ (instancetype)sharedManager {
    static NetworkManager *instance = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

#pragma mark - Net Request

#pragma mark  an example

//电影排行榜
- (void)requestRankListWithParams:(NSDictionary*)params path:(NSString *)path andBlock:(void (^)(id data, NSError *error))block{
    [[RequestOperationManager sharedJsonClient] requestJsonDataWithPath:path withParams:params withMethodType:NetworkMethodGet
                                                                   andBlock:^(id data, NSError *error) {
        if (data) {
            //处理
            block(data,nil);
        }else{
            block(nil, error);
        }
    }];
}
//电影搜索
- (void)searchMoviesWithParams:(NSDictionary *)params andBlock:(void (^)(id data, NSError *error))block{
    [[RequestOperationManager sharedJsonClient] requestJsonDataWithPath:kUrlSearchMovies withParams:params withMethodType:NetworkMethodGet
                                                          andBlock:^(id data, NSError *error) {
                                                              if (data) {
                                                                  //处理
                                                                  block(data,nil);
                                                              }else{
                                                                  block(nil, error);
                                                              }
                                                          }];
}

//电影详情数据
- (void)requestMovieDetailWithParams:(NSDictionary *)params movieId:(NSString *)movieId andBlock:(void (^)(Movie *movie, NSError *error))block{
    [[RequestOperationManager sharedJsonClient] requestJsonDataWithPath:kUrlGetMovieInfo(movieId) withParams:params withMethodType:NetworkMethodGet andBlock:^(id data, NSError *error) {
                                                              if (data) {
                                                                   Movie *movie = [MTLJSONAdapter modelOfClass:[Movie class] fromJSONDictionary:data error:nil];
                                                                  block(movie,nil);
                                                              }else{
                                                                  block(nil, error);
                                                              }
                                                          }];
}
//电影短评
- (void)requestMovieCommentsWithParams:(NSDictionary *)params movieId:(NSString *)movieId andBlock:(void (^)(id data, NSError *error))block{
    [[RequestOperationManager sharedJsonClient] requestJsonDataWithPath:kUrlGetMovieShortReviews(movieId) withParams:params withMethodType:NetworkMethodGet andBlock:^(id data, NSError *error) {
                                                              if (data) {
                                                                  //处理
                                                                  block(data,nil);
                                                              }else{
                                                                  block(nil, error);
                                                              }
                                                          }];
}

//电影长评
- (void)requestMovieReviewsWithParams:(NSDictionary *)params movieId:(NSString *)movieId andBlock:(void (^)(id data, NSError *error))block{
    [[RequestOperationManager sharedJsonClient] requestJsonDataWithPath:kUrlGetMovieLongReviews(movieId) withParams:params withMethodType:NetworkMethodGet andBlock:^(id data, NSError *error) {
                                                              if (data) {
                                                                  //处理
                                                                  block(data,nil);
                                                              }else{
                                                                  block(nil, error);
                                                              }
                                                          }];
}
//电影剧照
- (void)requestMoviePhotosWithParams:(NSDictionary *)params movieId:(NSString *)movieId andBlock:(void (^)(id data, NSError *error))block{
    [[RequestOperationManager sharedJsonClient] requestJsonDataWithPath:kUrlGetMoviePhotos(movieId) withParams:params withMethodType:NetworkMethodGet andBlock:^(id data, NSError *error) {
                                                              if (data) {
                                                                  //处理
                                                                  block(data,nil);
                                                              }else{
                                                                  block(nil, error);
                                                              }
                                                          }];
}
//影人剧照
- (void)requestMoviePhotosWithParams:(NSDictionary *)params celebrityId:(NSString *)celebrityId andBlock:(void (^)(id data, NSError *error))block{
    [[RequestOperationManager sharedJsonClient] requestJsonDataWithPath:kUrlGetCelebrityPhotos(celebrityId) withParams:params withMethodType:NetworkMethodGet andBlock:^(id data, NSError *error) {
        if (data) {
            //处理
            block(data,nil);
        }else{
            block(nil, error);
        }
    }];
}

//电影详情数据
- (void)requestCelebrityDataWithParams:(NSDictionary *)params celebrityId:(NSString *)cId andBlock:(void (^)(Celebrity *celebrity, NSError *error))block{
    [[RequestOperationManager sharedJsonClient] requestJsonDataWithPath:kUrlGetMovieCelebrity(cId) withParams:params withMethodType:NetworkMethodGet andBlock:^(id data, NSError *error) {
        if (data) {
            Celebrity *celebrity = [MTLJSONAdapter modelOfClass:[Celebrity class] fromJSONDictionary:data error:nil];
            block(celebrity,nil);
        }else{
            block(nil, error);
        }
    }];
}
@end
