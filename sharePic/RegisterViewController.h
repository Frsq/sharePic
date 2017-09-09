//
//  RegisterViewController.h
//  sharePic
//
//  Created by etta cai on 2017/8/27.
//  Copyright © 2017年 johnqzheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlLiteUtil.h"

@interface RegisterViewController : UIViewController {
    NSString *userName;
    NSString *userPassword;
    NSString *userPasswordConfirm;
}

@property(strong, readonly) sqlLiteUtil *sqlUtil;

@end
