//
//  Work.h
//  MovieFans
//
//  Created by Leo Gao on 15/9/22.
//  Copyright © 2015年 LeoCode. All rights reserved.
//

#import "MTLModel.h"
#import "MovieSubject.h"

@interface Work : MTLModel<MTLJSONSerializing>

@property (nonatomic,strong) NSArray *roles;
@property (nonatomic,strong) MovieSubject *subject;
@end
