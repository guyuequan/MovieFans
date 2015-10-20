//
//  ApiUrl.h
//  Ban
//
//  Created by Leo Gao on 15/7/9.
//  Copyright (c) 2015年 LeoCode. All rights reserved.
//

#ifndef ApiUrl_h
#define ApiUrl_h

/**
 *  豆瓣api基址
 */
#define kBaseUrl @"https://api.douban.com"

/**
 *  正在热映
 */
#define kUrlGetMoviesNowPlaying @"/v2/movie/nowplaying"

/**
 *  即将上映
 */
#define kUrlGetMoviesComing @"/v2/movie/coming"

/**
 *  新片榜
 */
#define kUrlGetMoviesNew @"/v2/movie/new_movies"

/**
 *  口碑榜
 */
#define kUrlGetMoviesWeekly @"/v2/movie/weekly"

/**
 *  北美票房榜
 */
#define kUrlGetMoviesUSBox @"/v2/movie/us_box"

/**
 *  Top250
 */
#define kUrlGetMoviesTop250 @"/v2/movie/top250"

/**
 *  电影条目信息 /v2/movie/subject/:id
 */
#define kUrlGetMovieInfo(id) [NSString stringWithFormat:@"/v2/movie/subject/%@",id]

/**
 *  电影检索 /v2/movie/search?q=张艺谋 GET /v2/movie/search?tag=喜剧
 */
#define kUrlSearchMovies @"/v2/movie/search"

/**
 *  影人条目 /v2/movie/celebrity/:id
 */
#define kUrlGetMovieCelebrity(id) [NSString stringWithFormat:@"/v2/movie/celebrity/%@",id]

/**
 *  影人剧照
 */
#define kUrlGetCelebrityPhotos(id) [NSString stringWithFormat:@"/v2/movie/celebrity/%@/photos",id]
/**
 *  电影剧照 /v2/movie/subject/:id/photos
 */
#define kUrlGetMoviePhotos(id) [NSString stringWithFormat:@"/v2/movie/subject/%@/photos",id]

/**
 *  电影短评
 */
#define kUrlGetMovieShortReviews(id) [NSString stringWithFormat:@"/v2/movie/subject/%@/comments",id]

/**
 *  电影长评
 */
#define kUrlGetMovieLongReviews(id) [NSString stringWithFormat:@"/v2/movie/subject/%@/reviews",id]

#endif
