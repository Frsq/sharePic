//
//  SpiderRecord.h
//  sharePic
//
//  Created by etta cai on 2017/10/7.
//  Copyright © 2017年 johnqzheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpiderRecord : NSObject{
    @public
    NSString *_url;
    NSString *_localurl;
    BOOL _isdownload;
    int _sqlid;
}
- (id)initWithUrl:(NSString*)url localurl:(NSString*)localurl isdownload:(BOOL)isdownload sqlid:(int)sqlid;
- (void)setUrl:(NSString*)url;
- (void)setIsdownload:(BOOL)isdownload;
- (NSString*)url;
- (NSString*)localurl;
- (BOOL)isdownload;
- (int)sqlid;


@end
