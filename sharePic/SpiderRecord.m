//
//  SpiderRecord.m
//  sharePic
//
//  Created by etta cai on 2017/10/7.
//  Copyright © 2017年 johnqzheng. All rights reserved.
//

#import "SpiderRecord.h"

@implementation SpiderRecord

-(id)initWithUrl:(NSString*)url num:(NSInteger)randomnum isdownload:(BOOL)isdownload {
    if (nil != [super init]) {
        _url = url;
        _randomNum = randomnum;
        _isdownload = isdownload;
    }
    return self;
}
- (void)setUrl:(NSString*)url{
    _url = url;
}
- (void)setRandomnum:(NSInteger)randomnum{
    _randomNum = randomnum;
}
- (void)setIsdownload:(BOOL)isdownload{
    _isdownload = isdownload;
}
- (NSString*)url{
    return _url;
}
- (NSInteger)randomnum{
    return _randomNum;
}
- (BOOL)isdownload{
    return _isdownload;
}

@end
