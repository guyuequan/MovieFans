//
//  NSMutableAttributedString+Common.h
//  Ban
//
//  Created by Leo Gao on 15/7/10.
//  Copyright (c) 2015年 LeoCode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (Common)
- (void)addAttribute:(NSString *)name value:(id)value withString:(NSString*)string;
@end
