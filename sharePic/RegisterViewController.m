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
    NSDictionary *dict = [_sqlUtil selectSql:inputUser];
    NSLog(@"register inputUser is :%@", inputUser);
    id username = [dict objectForKey:@"username"];
    if ([username isEqualToString:inputUser]) {
        [self shareAlertMessage:@"账号已存在，请先重新输入"];
    }else {
        userName = inputUser;
    }
}

- (IBAction)userPassChanged:(UITextField *)sender {
    userPassword = sender.text;
}

- (IBAction)userPassChangedPerform:(UITextField *)sender {
    userPasswordConfirm = sender.text;
}

- (IBAction)registerBtn:(UIButton *)sender {
    if (![userPasswordConfirm isEqualToString:userPassword]) {
        [self shareAlertMessage:@"两次输入密码不一致!!!"];
    } else {
        if ([_sqlUtil insertSql:userName pass:userPasswordConfirm]) {
            [self shareAlertMessage:@"注册成功"];
        } else {
            [self shareAlertMessage:@"注册失败"];
        }
    }
//    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)shareAlertMessage:(NSString*)msg {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@""
                                                                             message:msg
                                                                      preferredStyle:UIAlertControllerStyleAlert ];
    
    //添加取消到UIAlertController中
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:cancelAction];
    
    //添加确定到UIAlertController中
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:OKAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
