//
//  AppDelegate.m
//  sharePic
//
//  Created by etta cai on 2017/8/26.
//  Copyright © 2017年 johnqzheng. All rights reserved.
//

#import "AppDelegate.h"
#import "SYNetwork.h"
#import "sqlLiteUtil.h"
#import "JiandanRequest.h"
#import "TencentOpenAPI.framework/Headers/TencentOAuth.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // 在我们实际的项目中，请求数据慢的时候，我们手机的左上角会出现菊花的效果，他的实现只需要一句代码。AFNetworkActivityIndicatorManager 使用单例初始化 然后把enabled设置为YES
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    //设置拉取数据时，转菊花的场景，详细信息可以查看http://www.jianshu.com/p/02a0ab269422，iOS常见的四种设置方法：http://www.jianshu.com/p/1ec4dca92e71
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    
    if (![[sqlLiteUtil shareInstance]createSql:nil]) {
        NSLog(@"数据表已经存在，不再重复创建");
    }else {
        NSLog(@"数据表已经创建");
    }
    //启动定时器
    [self JiandanTimer];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    return [TencentOAuth HandleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [TencentOAuth HandleOpenURL:url];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - timeer
- (void)JiandanTimer {
    NSLog(@"start Jiandan timer");
    NSTimeInterval period = 6 * 60 * 60;//设置时间间隔
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, period * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(_timer, ^{
        NSLog(@"%@" , [NSThread currentThread]);//打印当前线程
        JiandanRequest *jr = [[JiandanRequest alloc]init];
        [jr spidlerJiandanTody];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//        });
        
    });
    dispatch_resume(_timer);
}
@end
