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
#import "sharePicUtil.h"

@interface RandomPicViewController (){
    NSMutableArray *url_array;
}

@end

@implementation RandomPicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    url_array = [self getUrl];
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

- (NSMutableArray*)getUrl {
    sqlLiteUtil *sqlutil = [sqlLiteUtil getSharedInstance];
    NSMutableArray *array = [sqlutil getAllUrl];
//    [sqlutil closeDB];
    return array;
}

-(void)SingleTap:(UITapGestureRecognizer*)recognizer{
    //处理单击操作
    [self randomPic];
}

- (void)insert2DB:(NSInteger)num urlString:(NSString *)urlstring{
    NSString *httpurl = [NSString stringWithFormat:@"http:%@",urlstring];
    sqlLiteUtil *sqlutil = [sqlLiteUtil getSharedInstance];
    NSString *createSql = @"create table if not exists Jiandan(id integer primary key autoincrement, url text, localurl text, isdownload int)";
    if([sqlutil execSql:createSql]){
        NSString *insertSql = [NSString stringWithFormat:@"insert into RandomPic(url, localurl, isdownload) values('%ld','%@','%@')", (long)num,httpurl,@""];
        [sqlutil execSql:insertSql];
    }
//    [sqlutil closeDB];
}

- (void)updateJiandan:(NSString*)url localUrl:(NSString*)localurl sqlid:(int)sqlid{
    NSString *updateSql = [NSString stringWithFormat:@"update Jiandan set localurl = '%@', isdownload = %d where id = %d", localurl, 1, sqlid];
    sqlLiteUtil *sqlutil = [sqlLiteUtil getSharedInstance];
    [sqlutil execSql:updateSql];
//    [sqlutil closeDB];
}

- (NSString *)saveDataTwoFile:(UIImage *)image{
    //拿到图片
//    UIImage *image2 = [UIImage imageNamed:@"1.png"];
    NSString *documentPath = NSHomeDirectory();
    //设置一个图片的存储路径
    NSString *currentTime = [sharePicUtil getCurrentTime];
    NSString *imagePath = [documentPath stringByAppendingFormat:@"/Documents/%@.png",currentTime];
    //把图片直接保存到指定的路径（同时应该把图片的路径imagePath存起来，下次就可以直接用来取）
    [UIImagePNGRepresentation(image) writeToFile:imagePath atomically:YES];
    return imagePath;
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

- (void)getImageFromURL2:(NSString*)url sqlid:(int)sqlid{
    NSURL *httpurl = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:httpurl];
    request.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"response is %@, error is:%@", response, error);
        UIImage * result = [UIImage imageWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImageView *randomImg = [self.view viewWithTag:1001];
            [randomImg setImage:result]; //直接将数据显示在页面上
        });
        dispatch_async(dispatch_get_main_queue(),^{
            NSString *localurl = [self saveDataTwoFile:result];
            [self updateJiandan:url localUrl:localurl sqlid:sqlid];
        });
    }];
    [task resume];
}



- (void)randomPic {
    if (url_array.count != 0) {
        int num = arc4random() % url_array.count;
        SpiderRecord *sp = url_array[num];
        if ([sp.localurl isEqualToString:@""]) {
            [self getImageFromURL2:sp.url sqlid:sp.sqlid];
        }else{
            UIImage *image = [UIImage imageWithContentsOfFile:sp.localurl];
            UIImageView *randomImg = [self.view viewWithTag:1001];
            [randomImg setImage:image];
        }
    }
}

@end
