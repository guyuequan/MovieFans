//
//  SearchTagCell.h
//  MovieFans
//
//  Created by Leo Gao on 15/10/18.
//  Copyright © 2015年 LeoCode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchTagCell : UICollectionViewCell
@property (nonatomic,strong) UILabel *label;

+ (CGSize)sizeWithTag:(NSString *)tag;
@end
