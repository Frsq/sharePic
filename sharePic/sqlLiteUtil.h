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
+ (sqlLiteUtil *)getSharedInstance;
+ (id)shareInstance;
- (BOOL)createSql:(NSString *)sql;
- (BOOL)insertSql:(NSString*)name pass:(NSString*)pass;
- (BOOL)updateSql:(NSString *)name pass:(NSString *)pass id:(int)id;
- (BOOL)deleteSql:(int)id;
- (NSDictionary*)selectSql:(NSString *)name;
- (void)closeDB;
- (BOOL)execSql:(NSString *)sqlstring;
- (BOOL)isExist:(NSString *)url;
- (NSMutableArray*)getAllUrl;

@end
