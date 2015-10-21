//
//  AppDelegate.m
//  TVFans
//
//  Created by Leo Gao on 2/17/15.
//  Copyright (c) 2015 LeoCode. All rights reserved.
//

#import "AppDelegate.h"
#import "RootTabViewController.h"
#import "RankViewController.h"
#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "MobClick.h"

#define kAlertTagReview 10001
#define kAlertTagUpdate 10000

//启动次数key
#define kUseTimeKey [NSString stringWithFormat:@"UseTimeKey_%@",kAppVersion]
#define kNeveiRemindKey [NSString stringWithFormat:@"NeveiRemindKey_%@",kAppVersion]
@interface AppDelegate ()

@property (nonatomic,strong) NSString *remindMessage;
@property (nonatomic,strong) NSString *updateMassage;
@property (nonatomic,assign) NSInteger remindFrequency;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    //图片缓存
    [[SDImageCache sharedImageCache] setMaxCacheAge:3600*24*7];
    [[SDImageCache sharedImageCache] setMaxCacheSize:1024*1024*1024];
    
    [self setupDataBase];
    
    //网络
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    //友盟统计分析
    [MobClick startWithAppkey:kApiKey4UMeng reportPolicy:BATCH   channelId:nil];
    [MobClick setAppVersion:kAppVersion];
    [MobClick setLogEnabled:YES];
    
    [MobClick updateOnlineConfig];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlineConfigCallBack:) name:UMOnlineConfigDidFinishedNotification object:nil];

    [self customerInterface];
    
    self.window.rootViewController = [[RootTabViewController alloc] init];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)onlineConfigCallBack:(NSNotification *)notification {
    
    //评价提醒文案
    self.remindMessage = notification.userInfo[@"reviewRemindMessage"];
    //更新提醒文案
    self.updateMassage = notification.userInfo[@"updateMassage"];
    //关于文案
    NSString *about = notification.userInfo[@"aboutText"];
    //其他提醒
    NSString *msg = notification.userInfo[@"otherMssage"];
    //是否显示所有标签(搜索模块）
    NSString *ifshowAllTag = notification.userInfo[@"showAllTag"];
    
    //提醒频率
    self.remindFrequency = [notification.userInfo[@"remindFrequency"] integerValue];
    
    if(ifshowAllTag){
        [[NSUserDefaults standardUserDefaults]setValue:ifshowAllTag forKey:KEY_IF_SHOW_ALL_TAG];
    }
    if(about){
        [[NSUserDefaults standardUserDefaults]setValue:about forKey:KEY_ABOUT_TEXT];
    }
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    //其他提醒
    if(msg&&[msg length]>1){
        [[[UIAlertView alloc] initWithTitle:@"提醒" message:msg delegate:self cancelButtonTitle:@"知道了"otherButtonTitles:nil] show];
    }
    
    [self checkAppUpdate];
    [self showReviewAlert];
}

- (void)customerInterface{
    [SVProgressHUD setBackgroundColor:[UIColor clearColor]];
    //....
}
- (void)setupDataBase{
    NSArray *tbNames = @[TABLE_MOVIE,TABLE_REVIEW,TABLE_CELEBRITY];
    for(int i=0;i<[tbNames count];i++){
        [[DBUtil sharedUtil] createTableWithName:tbNames[i]];
    }
}
- (void)checkAppUpdate{

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@", kStoreAppId]];
    NSString * file =  [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    
    NSRange substr = [file rangeOfString:@"\"version\":\""];
    NSRange range1 = NSMakeRange(substr.location+substr.length,10);
    NSRange substr2 =[file rangeOfString:@"\"" options:NSCaseInsensitiveSearch range:range1];
    NSRange range2 = NSMakeRange(substr.location+substr.length, substr2.location-substr.location-substr.length);
    NSString *newVersion =[file substringWithRange:range2];
    
    if([kAppVersion floatValue] < [newVersion floatValue]){
        if(self.updateMassage&&[self.updateMassage length]>1){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:self.updateMassage delegate:self cancelButtonTitle:@"取消"otherButtonTitles:@"更新",nil];
            alert.tag = kAlertTagUpdate;
            [alert show];
        }
    }
}
- (void)showReviewAlert{
    
    NSNumber *useTimeValue = [[NSUserDefaults standardUserDefaults]valueForKey:kUseTimeKey];
    NSNumber *neverRemind = [[NSUserDefaults standardUserDefaults]valueForKey:kNeveiRemindKey];
    NSInteger freequency = self.remindFrequency?:5;
    if(![neverRemind boolValue]&&([useTimeValue integerValue]%freequency)==2){
        if(self.remindMessage&&[self.remindMessage length]>1){
            UIAlertView *reviewAlert = [[UIAlertView alloc]initWithTitle:@"评价应用" message:self.remindMessage delegate:self cancelButtonTitle:@"以后再说" otherButtonTitles:@"立即评价", nil];
            reviewAlert.tag = kAlertTagReview;
            [reviewAlert show];
        }
    }
    useTimeValue = [NSNumber numberWithInteger:[useTimeValue integerValue]+1];
    [[NSUserDefaults standardUserDefaults]setValue:useTimeValue forKey:kUseTimeKey];
    
}
- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==kAlertTagUpdate){
        if(buttonIndex==1){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kAppDetailURL]];
            [MobClick event:@"UMEventUpdate"];
        }
    }else if(alertView.tag==kAlertTagReview){
        if(buttonIndex==1){
            //评价应用
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kAppReviewURL]];
            [[NSUserDefaults standardUserDefaults]setValue:[NSNumber numberWithBool:YES] forKey:kNeveiRemindKey];
        }else{
            [MobClick event:@"UMEventNotReview"];
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
