//
//  CacheSizeLable+Manager.m
//  sharePic
//
//  Created by etta cai on 2017/10/7.
//  Copyright © 2017年 johnqzheng. All rights reserved.
//

#import "CacheSizeLable+Manager.h"
#import "CacheSizeLabel.h"

@implementation CacheSizeLabel (Manager)

- (void)reloadCacheSize {
    __weak typeof(self) weakSelf = self;
    [[SDImageCache sharedImageCache] calculateSizeWithCompletionBlock:^(NSUInteger fileCount, NSUInteger totalSize) {
        weakSelf.text = [NSString stringWithFormat:@"%.2f M", totalSize/1024.0/1024.0];
    }];
}

- (void)clearCache {
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD show];
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        [SVProgressHUD showSuccessWithStatus:@"清理完成"];
        [weakSelf reloadCacheSize];
    }];
}

@end
