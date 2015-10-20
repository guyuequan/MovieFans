//
//  LEOWebViewController.h
//  TVFans
//
//  Created by Leo Gao on 2/21/15.
//  Copyright (c) 2015 LeoCode. All rights reserved.
//

#import "BaseViewController.h"
@interface LEOWebViewController : BaseViewController<UIWebViewDelegate>
@property (nonatomic,strong) UIWebView *webView;
 
- (void)forward:(UIBarButtonItem*)sender;
- (void)back:(UIBarButtonItem*)sender;
- (void)refresh:(UIBarButtonItem*)sender;
  
@end
