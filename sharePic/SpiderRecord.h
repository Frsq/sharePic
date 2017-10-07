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
    NSInteger _randomNum;
    BOOL _isdownload;
}
- (id)initWithUrl:(NSString*)url num:(NSInteger)randomnum isdownload:(BOOL)isdownload;
- (void)setUrl:(NSString*)url;
- (void)setRandomnum:(NSInteger)randomnum;
- (void)setIsdownload:(BOOL)isdownload;
- (NSString*)url;
- (NSInteger)randomnum;
- (BOOL)isdownload;


@end
