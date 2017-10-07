//
//  LoginViewController.m
//  sharePic
//
//  Created by etta cai on 2017/8/26.
//  Copyright © 2017年 johnqzheng. All rights reserved.
//

#import "LoginViewController.h"
#import "RandomPicViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"timg1.jpg"]];
    _sqlUtil = [sqlLiteUtil shareInstance];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
    //if (userName && userPassword) {
    //    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    //    UITabBarController *mainTabVC = [story instantiateViewControllerWithIdentifier:@"mainTabBarVC"];
     //   dispatch_async(dispatch_get_main_queue(), ^{
     //       [self presentViewController:mainTabVC animated:YES completion:nil];
     //   });
    //}else{
    //    [self loginAlertMessage:@"输入密码错误，请重新输入"];
    //}

}
- (IBAction)shareRegister:(UIButton *)sender {
    [self registerIn];
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
