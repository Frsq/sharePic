//
//  SpiderRecord.m
//  sharePic
//
//  Created by etta cai on 2017/10/7.
//  Copyright © 2017年 johnqzheng. All rights reserved.
//

#import "SpiderRecord.h"

@implementation SpiderRecord

-(id)initWithUrl:(NSString*)url localurl:(NSString*)localurl isdownload:(BOOL)isdownload sqlid:(int)sqlid{
    if (nil != [super init]) {
        _url = url;
        _localurl = localurl;
        _isdownload = isdownload;
        _sqlid = sqlid;
    }
    //test
    return self;
}
- (void)setUrl:(NSString*)url{
    _url = url;
}
- (void)setIsdownload:(BOOL)isdownload{
    _isdownload = isdownload;
}
- (NSString*)url{
    return _url;
}
- (NSString*)localurl{
    return _localurl;
}
- (BOOL)isdownload{
    return _isdownload;
}
-(int)sqlid{
    return _sqlid;
}
@end
