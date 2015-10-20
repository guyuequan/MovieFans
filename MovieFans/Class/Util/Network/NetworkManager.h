//
//  BanNetworkManager.h
//  Ban
//
//  Created by Leo Gao on 15/7/9.
//  Copyright (c) 2015年 LeoCode. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Movie;
@class Celebrity;

@interface NetworkManager : NSObject
+ (instancetype)sharedManager;

//电影排行
- (void)requestRankListWithParams:(NSDictionary*)params path:(NSString *)path andBlock:(void (^)(id data, NSError *error))block;
//电影搜索
- (void)searchMoviesWithParams:(NSDictionary*)params andBlock:(void (^)(id data, NSError *error))block;
//电影详情数据
- (void)requestMovieDetailWithParams:(NSDictionary *)params movieId:(NSString *)movieId andBlock:(void (^)(Movie *movie, NSError *error))block;
//电影短评
- (void)requestMovieCommentsWithParams:(NSDictionary *)params movieId:(NSString *)movieId andBlock:(void (^)(id data, NSError *error))block;
//电影长评
- (void)requestMovieReviewsWithParams:(NSDictionary *)params movieId:(NSString *)movieId andBlock:(void (^)(id data, NSError *error))block;
//电影剧照
- (void)requestMoviePhotosWithParams:(NSDictionary *)params movieId:(NSString *)movieId andBlock:(void (^)(id data, NSError *error))block;
//影人
- (void)requestCelebrityDataWithParams:(NSDictionary *)params celebrityId:(NSString *)cId andBlock:(void (^)(Celebrity *celebrity, NSError *error))block;
//影人剧照
- (void)requestMoviePhotosWithParams:(NSDictionary *)params celebrityId:(NSString *)celebrityId andBlock:(void (^)(id data, NSError *error))block;
@end
