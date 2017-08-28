//
//  ViewController.m
//  sharePic
//
//  Created by etta cai on 2017/8/26.
//  Copyright © 2017年 johnqzheng. All rights reserved.
//

#import "RandomPicViewController.h"

@interface RandomPicViewController ()

@end

@implementation RandomPicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [NSThread sleepForTimeInterval:3.0f];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)shareStartRandom:(UIButton *)sender {
    UILabel *randomNum = [self.view viewWithTag:1000];
    [randomNum setText:@"1"];
    
    UIImageView *randomImg = [self.view viewWithTag:1001];
    [randomImg setImage:[UIImage imageNamed:@"loginbackground.jpg"]];
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

@end
