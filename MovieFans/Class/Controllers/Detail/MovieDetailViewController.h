//
//  MovieDetailViewController.h
//  MovieFans
//
//  Created by Leo Gao on 15/9/10.
//  Copyright (c) 2015年 LeoCode. All rights reserved.
//

#import "BaseViewController.h"
#import "MovieSimple.h"

@interface MovieDetailViewController : BaseViewController
@property (nonatomic,copy) NSString *movieId;
@property (nonatomic,copy) NSString *movieName;

- (instancetype)initWithMovieModel:(Movie *)movie;

@end
