//
//  NSDictionary+Common.m
//  LvBan
//
//  Created by Leo Gao on 15/8/17.
//  Copyright (c) 2015年 LeoCode. All rights reserved.
//

#import "NSDictionary+Common.h"

@implementation NSDictionary (Common)

- (NSString *)JSONString{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&parseError];
    if (parseError){
        return @"";
    }
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
@end
