//
//  JiandanRequest.m
//  sharePic
//
//  Created by etta cai on 2017/9/10.
//  Copyright © 2017年 johnqzheng. All rights reserved.
//

#import "JiandanRequest.h"

@implementation JiandanRequest: NSObject {

}

//不需要Post
- (NSString *)urlString:(NSString*)strurl {
    NSURL *url = [NSURL URLWithString:strurl];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSString *retStr = [[NSString alloc] initWithData:data encoding:nil];
    
//    NSLog(@"html = %@", retStr);
    [self subUrlsByRegular:retStr regular:@""];
    
    return  retStr;
}

//需要Post
+ (void)getPostResult:(NSString*)startqi {
    //使用第三发post请求方式也可
}

- (void)spidlerJiandanTody {
    NSString *url = @"https://jandan.net/ooxx";
    [self urlString:url];
}

- (NSString *)BaseUrl {
    return @"https://jandan.net/ooxx";
}

- (NSMutableArray *)subUrlsByRegular:(NSString*)srcContxt regular:(NSString *)regular {
    
    NSString *regex = [NSString stringWithFormat:@"\"//w.*?\/large\/.*?\.jpg\""];//匹配//wx1.sinaimg.cn/large/bf406845gy1fjqcwg9u4mj20in0bkjsd.jpg
//    NSLog(@"subUrlsByRegular : %@", regex);
    NSMutableArray *array = [self matchLinkWithStr:srcContxt withMatchStr:regex];
    for (int i=0; i< array.count; i++) {
        NSString * str = [array objectAtIndex:i];
        NSString *httpstr = [@"http:" stringByAppendingString:str];
        [self insert2DB:httpstr];//没做去重处理，后续再优化
        NSLog(@"str %@",httpstr);
    }
    NSLog(@"匹配结果:%@",array);//存入数据库
    return array;
}

- (NSMutableArray *)matchLinkWithStr:(NSString *)str withMatchStr:(NSString *)matchRegex {
    
    NSError *error = NULL;
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:matchRegex options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *match = [reg matchesInString:str options:NSMatchingReportCompletion range:NSMakeRange(0, [str length])];
    NSMutableArray *rangeArr = [NSMutableArray array];
    // 取得所有的NSRange对象
    if(match.count != 0)
    {
        for (NSTextCheckingResult *matc in match)
        {
            NSRange range = [matc range];
            NSRange range1 = NSMakeRange(range.location+1, range.length-2);
            NSValue *value = [NSValue valueWithRange:range1];
            [rangeArr addObject:value];
        }}
    
    // 将要匹配的值取出来,存入数组当中
    __block NSMutableArray *mulArr = [NSMutableArray array];
    [rangeArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSValue *value = (NSValue *)obj;
        NSRange range = [value rangeValue];
        [mulArr addObject:[str substringWithRange:NSMakeRange(range.location,range.length)]];}];
    return mulArr;
    
}

- (void)insert2DB:(NSString *)urlstring {
    sqlutil = [[sqlLiteUtil alloc]init];
    NSString *createSql = @"create table if not exists Jiandan(id integer primary key autoincrement, url text, localurl text, isdownload int)";
    if([sqlutil execSql:createSql] && ![sqlutil isExist:urlstring]){
        NSLog(@"insert into db:%@", urlstring);
        NSString *insertSql = [NSString stringWithFormat:@"insert into Jiandan(url, localurl, isdownload) values('%@', '%@', '%d')", urlstring, @"", 0];
        [sqlutil execSql:insertSql];
    }
    [sqlutil closeDB];
}

@end
