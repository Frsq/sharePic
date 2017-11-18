//
//  sharePicUtil.m
//  sharePic
//
//  Created by etta cai on 2017/10/29.
//  Copyright © 2017年 johnqzheng. All rights reserved.
//

#import "sharePicUtil.h"

@implementation sharePicUtil

//获取当地时间
+ (NSString *)getCurrentTime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-ddHHMMSS"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}

@end
