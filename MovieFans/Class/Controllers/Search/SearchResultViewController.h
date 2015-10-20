//
//  SearchResultViewController.h
//  MovieFans
//
//  Created by Leo Gao on 15/9/8.
//  Copyright (c) 2015年 LeoCode. All rights reserved.
//

#import "BaseViewController.h"

@interface SearchResultViewController : BaseViewController
@property (nonatomic,assign) BOOL pushFlag;

- (void)loadDataWithTag:(NSString *)tag question:(NSString *)question;
@end
