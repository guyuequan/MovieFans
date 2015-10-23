//
//  SettingViewController.m
//  MovieFans
//
//  Created by Leo Gao on 2/22/15.
//  Copyright (c) 2015 LeoCode. All rights reserved.
//

#import "SettingViewController.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <sys/utsname.h>
#import <StoreKit/StoreKit.h>
#import "TTableViewCell.h"
#import "AboutViewController.h"

#define kClearCacheAlertViewTag 1000
@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource,MFMailComposeViewControllerDelegate,SKStoreProductViewControllerDelegate,MFMessageComposeViewControllerDelegate>{
    BOOL _bugEmailFlag;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,copy) NSString *tmpSizeString;
@end

@implementation SettingViewController
#pragma - mark LifeCycle
- (void)viewDidLoad{
    [super viewDidLoad];
    self.navigationItem.title = @"程序设置";
    [self setupTableView];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refreshCacheInfo];
}

#pragma mark - Private
- (void)setupTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    if(isPad){
        self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    }
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = [UIView new];

    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
- (void)refreshCacheInfo{
    [[SDImageCache sharedImageCache] clearMemory];
    float tmpSize = [[SDImageCache sharedImageCache] getSize]/1024.f;
    self.tmpSizeString = tmpSize/1024.f>1?[NSString stringWithFormat:@"%.2f MB",tmpSize/1024.f ]:[NSString stringWithFormat:@"%.0f KB",tmpSize];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}
- (void)pasteboardSwitchChange:(UISwitch *)sender{
    [MobClick event:@"UMEVentClickPasteSwitch"];
    //保存主题到本地
    [[NSUserDefaults standardUserDefaults] setObject:sender.on?@1:@0 forKey:KEY_PASTEBOARD_SWITCH];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
- (void)nightSwitchChange:(UISwitch*)sender{
    [MobClick event:@"UMEVentClickNightSwitch"];
    //取出选中的主题名称
    [ThemeManager shareInstance].themeType = sender.on?ThemeTypeNight:ThemeTypeDefault;
}
- (void)sendMail{
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass != nil){
        // We must always check whether the current device is configured for sending emails
        if ([mailClass canSendMail]){
            [self displayComposerSheet];
            return;
        }
    }
    __AlertTip(@"该设备不支持发送邮件!\n请通过其他方式反馈,谢谢!(develop4ios@163.com)");
}

- (void)displayComposerSheet{
    
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    [picker setSubject:@"电影迷ios客户端意见反馈"];/*emailpicker标题主题行*/
    picker.navigationBar.barTintColor = [UIColor whiteColor];
    
    // Set up recipients
    NSArray *toRecipients = [NSArray arrayWithObject:@"develop4ios@163.com"];
    [picker setToRecipients:toRecipients];
    // Fill out the email body text
    struct utsname device_info;
    uname(&device_info);
    NSString *emailBody = [NSString
                           stringWithFormat:@"\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nModel: %s\nVersion: %@\nApp: %@\n",device_info.machine,
                           [[UIDevice currentDevice] systemVersion],
                           kAppVersion];
    if(!_bugEmailFlag){
        emailBody = @"";
        [picker setSubject:@"电影迷ios用户交流"];/*emailpicker标题主题行*/
    }
    [picker setMessageBody:emailBody isHTML:NO];
    [self presentViewController:picker animated:YES completion:^{}];
    
}

-(void)evaluateApp{
    SKStoreProductViewController * storeProductViewController = [[SKStoreProductViewController alloc] init];
    [storeProductViewController setDelegate:self];
    [self presentViewController:storeProductViewController animated:YES completion:^{
        [SVProgressHUD showWithStatus:@""];
    }];
    
    [storeProductViewController loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier:@"970057582"} completionBlock:^(BOOL result, NSError *error) {
        [SVProgressHUD dismiss];
        if(error)
        {
            NSLog(@"Error %@ with user info %@",error,[error userInfo]);
        }
        else
        {
//            [self presentViewController:storeProductViewController animated:YES completion:nil];
        }
    }];
    
}

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//发送短信
- (void)showSMSPicker {
    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
    if (messageClass != nil) {
        if ([messageClass canSendText]) {
            [self displaySMSComposerSheet];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"设备没有短信功能" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil];
            [alert show];
        }
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"iOS版本过低,iOS4.0以上才支持程序内发送短信" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil];
        [alert show];
    }
}
- (void)displaySMSComposerSheet {
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    picker.messageComposeDelegate = self;
    NSString *msg = [NSString stringWithFormat:@"Hi...分享你一个小应用(%@)\n内容不错，找电影挺方便的！(%@)",kAppName,kAppDetailURL];
    picker.body = [[NSString alloc] initWithString:msg];
    [self presentViewController:picker animated:YES completion:nil];
    
}

#pragma mark - Protocol
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:{
            return 3;
        }
            break;
        case 1:{
            return 2;
        }
            break;
        case 2:{
            return 1;
        }
            break;
        default:
            break;
    }
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger row = indexPath.row;
    static NSString *CellIdentifier = @"Cell";

    TTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[TTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    switch (indexPath.section) {
        case 0:
            if(row == 0)
            {
                cell.textLabel.text =  @"清除缓存";
                cell.detailTextLabel.text = self.tmpSizeString;
                
            }else if(row==1){
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.textLabel.text =  @"点击短评复制到剪切板";
                UISwitch *sw=[[UISwitch alloc]init];
                [sw addTarget:self action:@selector(pasteboardSwitchChange:) forControlEvents:UIControlEventValueChanged];
                cell.accessoryView=sw;
                NSNumber *num = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_PASTEBOARD_SWITCH];
                if([num isEqual:@1]){
                    [sw setOn:YES];
                }else{
                    [sw setOn:NO];
                }

            }else if (row==2){
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.textLabel.text =  @"夜间模式";
                UISwitch *sw=[[UISwitch alloc]init];
                [sw addTarget:self action:@selector(nightSwitchChange:) forControlEvents:UIControlEventValueChanged];
                cell.accessoryView=sw;
                if([ThemeManager shareInstance].themeType==ThemeTypeNight){
                    [sw setOn:YES];
                }else{
                    [sw setOn:NO];
                }
            }
            break;
        case 1:
            if(row == 0)
            {
                cell.textLabel.text =  @"意见反馈";
            }else if(row==1)
            {
                cell.textLabel.text =  @"评价应用";
                cell.detailTextLabel.text = @"感谢您的支持!!!";
            }
            else if(row==2)
            {
                cell.textLabel.text =  @"短信分享";
                cell.detailTextLabel.text = @"仅限iPhone联系人";
            }
            break;
        case 2:
            if(row == 0)
            {
                cell.textLabel.text =  @"关于软件";
            }
            break;
            
        default:
            break;
    }
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12.f];
    cell.backgroundColor = [UIColor clearColor];
    cell.themeTitleColorKey = THEME_COLOR_CELL_TITLE;
    cell.themeDetailColorKey = THEME_COLOR_CELL_CONTENT;
    cell.themeBackgroundColorKey = THEME_COLOR_CELL_BACKGROUND_LIGHT;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSInteger row = indexPath.row;
    switch (indexPath.section) {
        case 0:
            if(row == 0){
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"确认清除图片缓存？\n(收藏夹数据不受影响)" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alert.tag = kClearCacheAlertViewTag;
                [alert show];
                [MobClick event:@"UMEVentClearCache"];
            }
            break;
        case 1:
            if(row == 0)
            {
                //意见反馈
                _bugEmailFlag = YES;
                [self sendMail];
            }else if(row==1)
            {
//                评价应用
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kAppReviewURL]];
                [MobClick event:@"UMEVentReviewApp"];
            }else if(row==2)
            {
               //联系作者
//                [self sendMail];
                [self showSMSPicker];//短信分享
            }
            break;
        case 2:
            if(row == 0){
              //关于
                AboutViewController *about = [[AboutViewController alloc]initWithNibName:@"AboutViewController" bundle:[NSBundle mainBundle]];
//                AboutAppViewController *about = [[AboutAppViewController alloc]init];
                about.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:about animated:YES];
                [MobClick event:@"UMEventClickAboutButton"];
            }
            break;
            
        default:
            break;

    }
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag==kClearCacheAlertViewTag){
        if(buttonIndex==1){
            [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
                [self refreshCacheInfo];
            }];
        }
    }
}
#pragma mark - MFMessageComposeViewControllerDelegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    NSString *msg;
    switch (result)
    {
        case MessageComposeResultCancelled:
            msg = @"已取消发送!";
            break;
        case MessageComposeResultSent:
            msg = @"发送成功!";
            break;
        case MessageComposeResultFailed:
            msg = @"发送失败!";
            break;
        default:
            break;
    }
    [kKeyWindow makeToast:msg duration:kDefaultTipDuration position:CSToastPositionBottom];
    [self dismissViewControllerAnimated:YES completion:nil];
}
// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error{
        NSString *msg;
        switch (result)
        {
            case MFMailComposeResultCancelled:
                msg = @"邮件已取消!";//@"邮件发送取消";
                break;
            case MFMailComposeResultSaved:
                msg = @"邮件已保存!";//@"邮件保存成功"
                    break;
            case MFMailComposeResultSent:
                msg = @"邮件发送成功!";//@"邮件发送成功";
                break;
            case MFMailComposeResultFailed:
                msg = @"邮件发送失败!";//@"邮件发送失败";
                break;
            default:
                msg = @"邮件未发送!";
                break;
        }
//    [SVProgressHUD showSuccessWithStatus:msg];
    [kKeyWindow makeToast:msg duration:kDefaultTipDuration position:CSToastPositionBottom];
    [self  dismissViewControllerAnimated:YES completion:^{}];
    
}
@end
