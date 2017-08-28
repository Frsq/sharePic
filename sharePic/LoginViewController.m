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
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"loginbackground.jpg"]];
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
}
- (IBAction)shareLogin:(UIButton *)sender {
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UITabBarController *mainTabVC = [story instantiateViewControllerWithIdentifier:@"mainTabBarVC"];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:mainTabVC animated:YES completion:nil];
    });
}
- (IBAction)shareRegister:(UIButton *)sender {
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *registerVC = [story instantiateViewControllerWithIdentifier:@"registerVC"];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:registerVC animated:YES completion:nil];
    });
}

@end
