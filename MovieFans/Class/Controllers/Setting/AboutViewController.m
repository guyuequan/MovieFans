//
//  AboutViewController.m
//  MovieFans
//
//  Created by Leo Gao on 15/10/20.
//  Copyright © 2015年 LeoCode. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UITextView *aboutTextView;
@property (weak, nonatomic) IBOutlet UIImageView *IconView;
@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"关于";
    self.IconView.layer.cornerRadius = 10.f;
    self.IconView.layer.masksToBounds = YES;
    self.versionLabel.text = [NSString stringWithFormat:@"V%@",kAppVersion];
    self.aboutTextView.textColor = [ThemeManager themeColorWithKey:THEME_COLOR_LABEL_DARK];
    NSString *about = [[NSUserDefaults standardUserDefaults]valueForKey:KEY_ABOUT_TEXT];
    if(about){
        self.aboutTextView.text = about;
    }else{
        self.aboutTextView.text = @"本软件是作者因个人兴趣所作，相关建议或意见可以发送邮件到:develop4ios@163.com进行反馈交流。同时，欢迎到AppStore对此软件进行打分与评价，无论是吐槽还是褒奖都可以啊，只要能看到你的反馈，我就会很开心。。。。。。\n\n感谢支持！！！^_^";
    }
}

- (void)applyTheme{
    [super applyTheme];
    self.aboutTextView.textColor = [ThemeManager themeColorWithKey:THEME_COLOR_LABEL_DARK];
}
@end
