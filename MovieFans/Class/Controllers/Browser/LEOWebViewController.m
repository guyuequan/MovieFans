//
//  LEOWebViewController.m
//  TVFans
//
//  Created by Leo Gao on 2/21/15.
//  Copyright (c) 2015 LeoCode. All rights reserved.
//

#import "LEOWebViewController.h"

@interface LEOWebViewController ()
@property (nonatomic,strong) UIToolbar *toolbar;
@end

@implementation LEOWebViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [SVProgressHUD showWithStatus:@""];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat toolbarHeight = 44.f;
    
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0.f, 0.f, kScreenWidth,kScreenHeight-kStateBarHeight-kNavigationBarHeight-toolbarHeight)];
    _webView.delegate = self;
    [self.view addSubview:_webView];
    [self.webView setScalesPageToFit:YES];
    
    UIImage *backImg = [UIImage imageNamed:@"go_back"];
    backImg = [backImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIImage *forwardImg = [UIImage imageNamed:@"go_forward"];
    forwardImg = [forwardImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIImage *refreshImg = [UIImage imageNamed:@"refresh"];
    refreshImg = [refreshImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    _toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0.f, kScreenHeight-kStateBarHeight-kNavigationBarHeight-toolbarHeight,kScreenWidth,toolbarHeight)];
    UIBarButtonItem *back =  [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    UIBarButtonItem *forward = [[UIBarButtonItem alloc] initWithImage:forwardImg style:UIBarButtonItemStylePlain target:self action:@selector(forward:)];
    UIBarButtonItem *refresh =  [[UIBarButtonItem alloc] initWithImage:refreshImg style:UIBarButtonItemStylePlain target:self action:@selector(refresh:)];
    
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [self.toolbar setItems:@[flexible,back,flexible,refresh,flexible,forward,flexible]];
    [self.view addSubview:self.toolbar];
    
    [self configSubTheme];
}
- (void)configSubTheme{
//    UIImage *backgroundImage = [[ThemeManager shareInstance] get:@"tabbar_background.png"];
    [self.toolbar setBackgroundImage:[UIImage imageWithColor:[UIColor darkGrayColor]] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
}
- (void)forward:(UIBarButtonItem*)sender{
    if([self.webView canGoForward]){
        [self.webView goForward];
    }
}
- (void)back:(UIBarButtonItem*)sender{
    if([self.webView canGoBack]){
        [self.webView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)refresh:(UIBarButtonItem*)sender{
    [self.webView reload];
}

#pragma mark - UIWebView Delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
//    NSLog(@"should start load request:%@",request.URL.absoluteString);
    return YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"Load Did finished:%@",webView.request.URL.absoluteString);

    if([SVProgressHUD isVisible]){
        [SVProgressHUD dismiss];
    }
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"remove_ad_banner" ofType:@"js"];
    NSString *jsString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
//    NSLog(@"jsstring:%@",jsString);
    [webView stringByEvaluatingJavaScriptFromString:jsString];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    if([SVProgressHUD isVisible]){
        [SVProgressHUD dismiss];
    }
    NSLog(@"Load Data failed!:%@",webView.request.URL.absoluteString);
}
@end
