//
//  LoginViewController.m
//  sharePic
//
//  Created by etta cai on 2017/8/26.
//  Copyright © 2017年 johnqzheng. All rights reserved.
//

#import "LoginViewController.h"
#import "RandomPicViewController.h"
#import "ZJHttpRequest.h"
#import "TencentOpenAPI.framework/Headers/TencentOAuth.h"

@interface LoginViewController ()<TencentSessionDelegate,TencentLoginDelegate>

@end

@implementation LoginViewController {
    TencentOAuth *_tencentOAuth;
    NSArray *_permissions;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroud.jpg"]];
    _sqlUtil = [sqlLiteUtil shareInstance];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark 选择QQ或者TIM登录
- (TencentAuthShareType)getAuthType
{
    BOOL flag = [[[NSUserDefaults standardUserDefaults] objectForKey:@"sdkSwitchFlag"] boolValue];
    return flag? AuthShareType_TIM :AuthShareType_QQ;
}

#pragma mark TencentSessionDelegate回调协议注册
- (void)tencentDidLogin {
    NSLog(@"--- %s ---",__func__);//__func__打印方法名
//    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//    UITabBarController *mainTabVC = [story instantiateViewControllerWithIdentifier:@"mainTabBarVC"];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self presentViewController:mainTabVC animated:YES completion:nil];
//    });
    if (_tencentOAuth.accessToken && 0 != [_tencentOAuth.accessToken length])
    {
        // 记录登录用户的OpenID、Token以及过期时间
//        _labelAccessToken.text = _tencentOAuth.accessToken;
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        UITabBarController *mainTabVC = [story instantiateViewControllerWithIdentifier:@"mainTabBarVC"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:mainTabVC animated:YES completion:nil];
        });
        NSLog(@"token is %@",_tencentOAuth.accessToken);
    }
    else
    {
//        _labelAccessToken.text = @"登录不成功 没有获取accesstoken";
    }
}

- (void)tencentDidNotLogin:(BOOL)cancelled {
    NSLog(@"--- %s ---",__func__);//__func__打印方法名
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"结果" message:@"登录失败,请重新登录" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
    [alertView show];
}

- (void)tencentDidNotNetWork {
    NSLog(@"--- %s ---",__func__);//__func__打印方法名
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"无网络" message:@"网络连接失败" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
    [alertView show];
}


#pragma mark 登录注册逻辑
- (IBAction)userSigChanged:(UITextField *)sender {
    
    NSString *inputUser = sender.text;
    NSDictionary *dict = [_sqlUtil selectSql:inputUser];
    id username = [dict objectForKey:@"username"];
    if ([username isEqualToString:inputUser]) {
        userName = inputUser;
    }else{
        [self regisgerAlertMessage:@"账号不存在，请先注册"];
    }
}

- (IBAction)userPasswordChanged:(UITextField *)sender {
    NSString *inputPass = sender.text;
    userPassword = inputPass;
    NSLog(@"inputPass is :%@", inputPass);
}
- (IBAction)shareLogin:(UIButton *)sender {
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UITabBarController *mainTabVC = [story instantiateViewControllerWithIdentifier:@"mainTabBarVC"];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:mainTabVC animated:YES completion:nil];
    });
    //    if (userName && userPassword) {
    //        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    //        UITabBarController *mainTabVC = [story instantiateViewControllerWithIdentifier:@"mainTabBarVC"];
    //        dispatch_async(dispatch_get_main_queue(), ^{
    //            [self presentViewController:mainTabVC animated:YES completion:nil];
    //        });
    //    }else{
    //        [self loginAlertMessage:@"输入密码错误，请重新输入"];
    //    }
    
}
- (IBAction)shareRegister:(UIButton *)sender {
    [self registerIn];
}

#pragma mark - test for everything,just for test
- (IBAction)testLogic:(id)sender {
    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"1111" andDelegate:self];
    _permissions = [NSArray arrayWithObjects:
                            kOPEN_PERMISSION_GET_USER_INFO,
                            kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                            kOPEN_PERMISSION_ADD_ALBUM,
                            kOPEN_PERMISSION_ADD_ONE_BLOG,
                            kOPEN_PERMISSION_ADD_SHARE,
                            kOPEN_PERMISSION_ADD_TOPIC,
                            kOPEN_PERMISSION_CHECK_PAGE_FANS,
                            kOPEN_PERMISSION_GET_INFO,
                            kOPEN_PERMISSION_GET_OTHER_INFO,
                            kOPEN_PERMISSION_LIST_ALBUM,
                            kOPEN_PERMISSION_UPLOAD_PIC,
                            kOPEN_PERMISSION_GET_VIP_INFO,
                            kOPEN_PERMISSION_GET_VIP_RICH_INFO,
                            nil];
    [_tencentOAuth setAuthShareType:[self getAuthType]];
    [_tencentOAuth authorize:_permissions inSafari:NO];
}

#pragma mark - register
- (void)registerIn {
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *registerVC = [story instantiateViewControllerWithIdentifier:@"registerVC"];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:registerVC animated:YES completion:nil];
    });
}

#pragma mark - register alert message
- (void)regisgerAlertMessage:(NSString*)msg {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:msg preferredStyle:UIAlertControllerStyleAlert ];
    
    //添加取消到UIAlertController中
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:cancelAction];
    
    //添加确定到UIAlertController中
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self registerIn];
    }];
    [alertController addAction:OKAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)loginAlertMessage:(NSString*)msg {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:msg preferredStyle:UIAlertControllerStyleAlert ];
    //添加确定到UIAlertController中
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:OKAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
