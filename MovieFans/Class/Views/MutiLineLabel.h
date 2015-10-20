//
//  MutiLineLabel.h
//  BoncBaseSys
//
//  Created by Leo Gao on 15/4/7.
//
//

#import <UIKit/UIKit.h>

typedef enum
{
    VerticalAlignmentTop = 0, // default
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
} VerticalAlignment;

@interface MutiLineLabel : UILabel
@property (nonatomic) VerticalAlignment verticalAlignment;
@end
