//
//  MovieSubject.h
//  MovieFans
//
//  Created by Leo Gao on 15/9/22.
//  Copyright © 2015年 LeoCode. All rights reserved.
//

#import "MTLModel.h"
@class Cover;

@interface MovieSubject : MTLModel<MTLJSONSerializing>

@property (nonatomic,copy) NSString *mId;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *originalTitle;
@property (nonatomic,copy) NSString *year;
@property (nonatomic,strong) NSNumber *rating;
@property (nonatomic,copy) NSString *pubdateStr;
@property (nonatomic,copy) NSString *alt;
@property (nonatomic,copy) NSString *duration;
@property (nonatomic,strong) NSArray *genres;
@property (nonatomic,strong) Cover *images;

@end
