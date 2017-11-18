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
    //拿到urlString
    NSString *urlString = @"http://avtest.qq.com/tlscgi/cgi-bin/gensig?appid=1400035750&id=14827&acctype=14181";
    NSURLSession *session = [NSURLSession sharedSession];
    //编码
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    //转换成NSURL
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //    //Json数据格式解析，利用系统提供的API进行Jison数据解析
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"dictionary is %@", dictionary);
        ZJHttpRequest *weibo = [[ZJHttpRequest alloc]initWithDictionary:dictionary];
        SigModel *sig = [[SigModel alloc]initWithDictionary:weibo.rspbody];
        NSLog(@"sig is %@", sig.sig);
    }];
    [task resume];

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
