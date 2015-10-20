//
//  TButton.h
//  MovieFans
//
//  Created by Leo Gao on 15/9/24.
//  Copyright © 2015年 LeoCode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TButton : UIButton<UpdateThemeProtocol>
@property (nonatomic,copy) NSString *themeTextColorNormalKey;
@property (nonatomic,copy) NSString *themeTextColorHighlightedKey;
@property (nonatomic,copy) NSString *themeBackgroundColorKey;
@end
