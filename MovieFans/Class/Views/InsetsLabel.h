//
//  InsetsLabel.h
//  TVFans
//
//  Created by Leo Gao on 2/18/15.
//  Copyright (c) 2015 LeoCode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InsetsLabel : UILabel
@property(nonatomic) UIEdgeInsets insets;
- (id)initWithFrame:(CGRect)frame andInsets: (UIEdgeInsets) insets;
- (id)initWithInsets: (UIEdgeInsets) insets;
@end
