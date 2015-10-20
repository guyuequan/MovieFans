//
//  BaseViewController.h
//  Ban
//
//  Created by Leo Gao on 15/7/8.
//  Copyright (c) 2015年 LeoCode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UpdateThemeProtocol.h"

@interface BaseViewController : UIViewController<UpdateThemeProtocol>
@property (nonatomic,strong) UILabel *blankLabel;

//应用主题，子类覆盖时须调用一次父类方法
- (void)applyTheme;

@end
