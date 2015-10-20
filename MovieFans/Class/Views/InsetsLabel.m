//
//  InsetsLabel.m
//  TVFans
//
//  Created by Leo Gao on 2/18/15.
//  Copyright (c) 2015 LeoCode. All rights reserved.
//

#import "InsetsLabel.h"

@implementation InsetsLabel

- (id)initWithFrame:(CGRect)frame andInsets:(UIEdgeInsets)insets {
    self = [super initWithFrame:frame];
    if(self){
        self.insets = insets;
    }
    return self;
}

- (id)initWithInsets:(UIEdgeInsets)insets {
    self = [super init];
    if(self){
        self.insets = insets;
    }
    return self;
}

- (void)drawTextInRect:(CGRect)rect {
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.insets)];
}

@end
