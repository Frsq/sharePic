//
//  JiandanRequest.h
//  sharePic
//
//  Created by etta cai on 2017/9/10.
//  Copyright © 2017年 johnqzheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "sqlLiteUtil.h"

@interface JiandanRequest : NSObject {
    sqlLiteUtil *sqlutil;
}

- (void)spidlerJiandanTody;
- (NSString *)urlString:(NSString*)strurl;
- (NSMutableArray *)subUrlsByRegular:(NSString*)srcContxt regular:(NSString *)regular;
@end
