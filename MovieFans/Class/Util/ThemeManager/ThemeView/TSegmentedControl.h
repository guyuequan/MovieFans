//
//  TSegmentedControl.h
//  MovieFans
//
//  Created by Leo Gao on 15/9/24.
//  Copyright © 2015年 LeoCode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UpdateThemeProtocol.h"

@interface TSegmentedControl : UISegmentedControl<UpdateThemeProtocol>

@property (nonatomic,copy) NSString *themeBackgroundSelectedColorKey;
@property (nonatomic,copy) NSString *themeTitleNormalColorKey;
@property (nonatomic,copy) NSString *themeTitleSelectedColorKey;
@end
