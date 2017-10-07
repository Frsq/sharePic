//
//  RegisterViewController.m
//  sharePic
//
//  Created by etta cai on 2017/8/27.
//  Copyright © 2017年 johnqzheng. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
- (IBAction)backLoginVIew:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)userSigChanged:(UITextField *)sender {
    
    NSString *inputUser = sender.text;
    if (![self checkFormat:inputUser]) {
        [SVProgressHUD showErrorWithStatus:@"账号只能由6~8位字母或数字组成"];
    }else{
        NSDictionary *dict = [_sqlUtil selectSql:inputUser];
        NSLog(@"register inputUser is :%@", inputUser);
        id username = [dict objectForKey:@"username"];
        if ([username isEqualToString:inputUser]) {
            [self registerFailMessage:@"账号已存在，请先重新输入"];
        }else {
            userName = inputUser;
        }
    }
}

- (IBAction)userPassChanged:(UITextField *)sender {
    userPassword = sender.text;
    if (![self checkFormat:userPassword]) {
        [SVProgressHUD showErrorWithStatus:@"密码只能由6~8位字母或数字组成"];
    }
}

- (IBAction)userPassChangedPerform:(UITextField *)sender {
    userPasswordConfirm = sender.text;
}

- (BOOL)checkFormat:(NSString*)str{
    NSString *regex = @"^[A-Za-z0-9]{6,8}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL isMatch = [pred evaluateWithObject:str];
    return isMatch;
}

- (IBAction)registerBtn:(UIButton *)sender {
    if (![userPasswordConfirm isEqualToString:userPassword]) {
        [SVProgressHUD showErrorWithStatus:@"两次输入密码不一致,请重新输入"];
    } else {
        if (userName && [_sqlUtil insertSql:userName pass:userPasswordConfirm]) {
            [self registerSuccMessage:@"注册成功,点击确定返回登录。"];
        } else {
            [SVProgressHUD showErrorWithStatus:@"注册失败，请重新输入"];
        }
    }
//    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)registerSuccMessage:(NSString*)msg {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:msg preferredStyle:UIAlertControllerStyleAlert];
    //添加确定到UIAlertController中
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertController addAction:OKAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)registerFailMessage:(NSString*)msg {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:msg preferredStyle:UIAlertControllerStyleAlert];
    //添加确定到UIAlertController中
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        userName = nil;
    }];
    [alertController addAction:OKAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)cleanInputText:(NSString *)inputName{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *registerVC = [story instantiateViewControllerWithIdentifier:@"registerVC"];
    
    UILabel *randomNum = [self.view viewWithTag:1000];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:registerVC animated:YES completion:nil];
    });
}

@end
