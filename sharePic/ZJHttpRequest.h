//
//  ZJHttpRequest.h
//  sharePic
//
//  Created by etta cai on 2017/10/14.
//  Copyright © 2017年 johnqzheng. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface SigModel : NSObject
@property (nonatomic, strong)NSArray *sig;
-(id)initWithDictionary:(NSDictionary *)dictionary;
@end

@interface ZJHttpRequest : NSObject
@property (nonatomic,strong)SigModel *rspbody;
@property (nonatomic,strong)NSString *ret;
@property (nonatomic,strong)NSString *msg;

-(id)initWithDictionary:(NSDictionary *)dictionary; 
@end
