//
//  ViewController.m
//  sharePic
//
//  Created by etta cai on 2017/8/26.
//  Copyright © 2017年 johnqzheng. All rights reserved.
//

#import "RandomPicViewController.h"
#import "JiandanRequest.h"
#import "sqlLiteUtil.h"
#import "SpiderRecord.h"

@interface RandomPicViewController ()

@end

@implementation RandomPicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [NSThread sleepForTimeInterval:3.0f];
    [self randomPic];
    // 单击的 Recognizer
    UITapGestureRecognizer* singleRecognizer;
    singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(SingleTap:)];
    //点击的次数
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    
    //给self.view添加一个手势监测；
    
    [self.view addGestureRecognizer:singleRecognizer];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)shareStartRandom:(UIButton *)sender {
    [self randomPic];
}

- (void)downloadImage {
    NSString *url = @"https://jandan.net/ooxx";
    JiandanRequest *jr = [[JiandanRequest alloc]init];
    [jr urlString:url];
}
- (IBAction)downloadHistory:(id)sender {
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *historyVC = [story instantiateViewControllerWithIdentifier:@"historyVC"];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:historyVC animated:YES completion:nil];
    });
}

- (void)randomPic {
    sqlLiteUtil *sqlutil = [sqlLiteUtil getSharedInstance];
    NSMutableArray *array = [sqlutil getAllUrl];
    
    int num = arc4random() % array.count;
    SpiderRecord *sp = array[num];
    UILabel *randomNum = [self.view viewWithTag:1000];
    [randomNum setText:[NSString stringWithFormat:@"随机数是:%ld",(long)sp.randomnum]];
    [self getImageFromURL2:sp.url];
    
//    UIImageView *randomImg = [self.view viewWithTag:1001];
//    [randomImg setImage:[self getImageFromURL:sp.url]];
//    [self insert2DB:num urlString:@""];
}

- (void)insert2DB:(NSInteger)num urlString:(NSString *)urlstring {
    NSString *httpurl = [NSString stringWithFormat:@"http:%@",urlstring];
    sqlLiteUtil *sqlutil = [sqlLiteUtil getSharedInstance];
    NSString *createSql = @"create table if not exists RandmPic(id integer primary key autoincrement, randomnum int, url text, recordtime text)";
    if([sqlutil execSql:createSql]){
        NSString *insertSql = [NSString stringWithFormat:@"insert into RandomPic(randomnum, url, recordtime) values('%ld','%@', '%@')", (long)num,httpurl, @""];
        [sqlutil execSql:insertSql];
    }
    [sqlutil closeDB];
}

//下载图片
-(UIImage *) getImageFromURL:(NSString *)fileURL {
    NSLog(@"执行图片下载函数");
    UIImage * result;
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    //下面是一句话搞定，上面是分开来做得。
    //UIImage * result = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]]];
    return result;
}

//下面是定义ImageView的方法
-(void) initImageView{
    NSString * urlWeb=@"http://simg.sinajs.cn/blog7newtpl/image/30/30_1/images/sinablogb.jpg";
    
    UIImageView * imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0 , 200, 400)];
    imageView.backgroundColor=[UIColor blueColor];
    
    //两种方法，用imageNamed可以把图片放入内存，重复使用。但是太多会挂掉，一般重复使用的图片用imageNamed
    [imageView setImage:[self getImageFromURL:urlWeb]];
    
    //[imageView setImage:[UIImage imageNamed:@"desc_bn.png"]];
    [self.view addSubview:imageView];
}

- (void)getImageFromURL2:(NSString*)url {
    NSURL *httpurl = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:httpurl];
    request.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
//    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
//        if (data) {
//            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//            NSLog(@"%@", dict);
//         }
//    }];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"response is %@, error is:%@", response, error);
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage * result = [UIImage imageWithData:data];
            UIImageView *randomImg = [self.view viewWithTag:1001];
            [randomImg setImage:result];
        });
//        // NSLog(@"%@ %tu", response, data.length);
//        // 类型转换（如果将父类设置给子类，需要强制转换）
//        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
//        NSLog(@"statusCode == %@", @(httpResponse.statusCode));
//        // 判断响应的状态码是否是 304 Not Modified （更多状态码含义解释： https://github.com/ChenYilong/iOSDevelopmentTips）
//        if (httpResponse.statusCode == 304) {
//            NSLog(@"加载本地缓存图片");
//            // 如果是，使用本地缓存
//            // 根据请求获取到`被缓存的响应`！
//            NSCachedURLResponse *cacheResponse =  [[NSURLCache sharedURLCache] cachedResponseForRequest:request];
//            // 拿到缓存的数据
//            data = cacheResponse.data;
//        }
    }];
    [task resume];
}

-(void)SingleTap:(UITapGestureRecognizer*)recognizer{
    //处理单击操作
    [self randomPic];
}

@end
