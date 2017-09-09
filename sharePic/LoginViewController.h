//
//  LoginViewController.h
//  sharePic
//
//  Created by etta cai on 2017/8/26.
//  Copyright © 2017年 johnqzheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlLiteUtil.h"

@interface LoginViewController : UIViewController {
    NSString *userName;
    NSString *userPassword;
}

@property(strong,readonly) sqlLiteUtil * sqlUtil;

@end
