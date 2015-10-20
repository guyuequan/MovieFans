//
//  DoubanBrowseViewController.m
//  TVFans
//
//  Created by Leo Gao on 2/21/15.
//  Copyright (c) 2015 LeoCode. All rights reserved.
//

#import "DoubanBrowseViewController.h"

@interface DoubanBrowseViewController ()<UIWebViewDelegate>
//@property (nonatomic,strong) UIWebView *webView;
@end

@implementation DoubanBrowseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(self.url){
        [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
    }
}
@end
