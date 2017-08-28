//
//  sqlLiteUtil.h
//  sharePic
//
//  Created by etta cai on 2017/8/27.
//  Copyright © 2017年 johnqzheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"

@interface sqlLiteUtil : NSObject {
    NSString * databaseFilePath;
    sqlite3 *db;
    char *error;
}


//@property NSString * databaseFilePath;
//@property sqlite3 *db;
//@property char *error;

+ (id)sqlLiteUtil;

@end
