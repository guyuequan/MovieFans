//
//  TLabel.h
//  MovieFans
//
//  Created by Leo Gao on 15/9/24.
//  Copyright © 2015年 LeoCode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UpdateThemeProtocol.h"

@interface TLabel : UILabel<UpdateThemeProtocol>
@property (nonatomic,copy) NSString *themeTextColorKey;
@property (nonatomic,copy) NSString *themeBackgroundColorKey;
@end
