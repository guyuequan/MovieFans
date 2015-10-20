//
//  NSMutableAttributedString+Common.m
//  Ban
//
//  Created by Leo Gao on 15/7/10.
//  Copyright (c) 2015年 LeoCode. All rights reserved.
//

#import "NSMutableAttributedString+Common.h"

@implementation NSMutableAttributedString (Common)
- (void)addAttribute:(NSString *)name value:(id)value withString:(NSString*)string{
    if(string){
        NSRange range=[self.string rangeOfString:string];
        if(range.location!=NSNotFound){
            [self addAttribute:name value:value range:range];
        }
    }
}
@end
