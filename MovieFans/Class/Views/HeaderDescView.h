//
//  HeaderDescView.h
//  Ban
//
//  Created by Leo Gao on 15/7/9.
//  Copyright (c) 2015年 LeoCode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderDescView : UICollectionReusableView
@property (nonatomic,strong) TLabel *colorLbl;
@property (nonatomic,strong) TLabel *descLbl;
@property (nonatomic,strong) TLabel *moreLbl;

//-(instancetype)initWithDesc:(NSString *)desc andShowMoreLabelWithText:(NSString *)moreTxt;
//-(instancetype)initWithDesc:(NSString *)desc;
@end
