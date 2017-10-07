//
//  sqlLiteUtil.m
//  sharePic
//
//  Created by etta cai on 2017/8/27.
//  Copyright © 2017年 johnqzheng. All rights reserved.
//

#import "sqlLiteUtil.h"
#import "SpiderRecord.h"
static sqlLiteUtil *sharedIntance = nil;

@implementation sqlLiteUtil

#pragma mark - 设置数据库信息
+ (id)shareInstance {
    static sqlLiteUtil *sharedSqlUtil = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedSqlUtil = [[self alloc]init];
    });

    return sharedSqlUtil;
}

- (id)init {
    if (self == [super init]) {
        NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        databaseFilePath = [documentPath stringByAppendingPathComponent:@"sharePic.sqlite"];
        [self OpenDB];
    }

    return self;
}

#pragma makr - 另外一种创建单例的方式
+ (sqlLiteUtil *)getSharedInstance {
    if (!sharedIntance) {
        sharedIntance = [[super allocWithZone:NULL]init];
    }
    return sharedIntance;
}

#pragma mark - 数据库操作
- (BOOL)OpenDB {
    // 打开数据库，数据库文件不存在时，自动创建文件
    
    if (sqlite3_open([databaseFilePath UTF8String], &db) == SQLITE_OK) {
        NSLog(@"sqlite dadabase is opened.");
        return YES;
    } else {
        NSLog(@"sqlite dadabase open fail.");
        return NO;
    }

}

- (BOOL)createSql:(NSString*)sql {
    /*
     sql 语句，专门用来操作数据库的语句。
     create table if not exists 是固定的，如果表不存在就创建。
     myTable() 表示一个表，myTable 是表名，小括号里是字段信息。
     字段之间用逗号隔开，每一个字段的第一个单词是字段名，第二个单词是数据类型，primary key 代表主键，autoincrement 是自增。
     */
    
    NSString *createSql = @"create table if not exists sharePic(id integer primary key autoincrement, username text, userpass text)";
    
    if (sqlite3_exec(db, [createSql UTF8String], NULL, NULL, &error) == SQLITE_OK) {
        NSLog(@"create table is ok.");
        return YES;
    } else {
        NSLog(@"error: %s", error);

        // 每次使用完毕清空 error 字符串，提供给下一次使用
        sqlite3_free(error);
        return NO;
    }
}

- (BOOL)execSql:(NSString *)sqlstring {
    NSLog(@"do sql:%@",sqlstring);
    if (sqlite3_exec(db, [sqlstring UTF8String], NULL, NULL, &error) == SQLITE_OK) {
        NSLog(@"exec sql succ.");
        return YES;
    }else{
        NSLog(@"exec sql error: %s", error);
        return NO;
    }
}

- (BOOL)insertSql:(NSString*)name pass:(NSString*)pass {
    NSString *insertSql = [NSString stringWithFormat:@"insert into sharePic(username, userpass) values('%@', '%@')", name, pass];
    
    if (sqlite3_exec(db, [insertSql UTF8String], NULL, NULL, &error) == SQLITE_OK) {
        NSLog(@"insert operation is ok.");
        return YES;
    } else {
        NSLog(@"error: %s", error);
        
        // 每次使用完毕清空 error 字符串，提供给下一次使用
        sqlite3_free(error);
        return NO;
    }
}

- (BOOL)updateSql:(NSString *)name pass:(NSString *)pass id:(int)id {
    NSString *updateSql = [NSString stringWithFormat:@"update sharePic set username = '%@', userpass = '%@' where id = %d", name, pass, id];
    
    if (sqlite3_exec(db, [updateSql UTF8String], NULL, NULL, &error) == SQLITE_OK) {
        NSLog(@"update operation is ok.");
        return YES;
    } else {
        NSLog(@"error: %s", error);
        
        // 每次使用完毕清空 error 字符串，提供给下一次使用
        sqlite3_free(error);
        return NO;
    }
}

- (BOOL)deleteSql:(int)id {
    NSString *deleteSql = [NSString stringWithFormat:@"delete from sharePic where id = %d", id];
    
    if (sqlite3_exec(db, [deleteSql UTF8String], NULL, NULL, &error) == SQLITE_OK) {
        NSLog(@"delete operation is ok.");
        return YES;
    } else {
        NSLog(@"error: %s", error);
        
        // 每次使用完毕清空 error 字符串，提供给下一次使用
        sqlite3_free(error);
        return NO;
    }
}

- (NSDictionary *)selectSql:(NSString *)name {
    sqlite3_stmt *statement;
//    NSInteger id;
    NSString *username;
    NSString *userpass;
    // @"select * from myTable"  查询所有 key 值内容
    NSString *selectSql = [NSString stringWithFormat:@"select id, username, userpass from sharePic where username='%@'",name];
    
    if (sqlite3_prepare_v2(db, [selectSql UTF8String], -1, &statement, nil) == SQLITE_OK) {
        
        while(sqlite3_step(statement) == SQLITE_ROW) {
            
            // 查询 id 的值
            int id = sqlite3_column_int(statement, 0);
            
            // 查询 username 的值
            username = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
            
            // 查询 userpass
            userpass = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
            
            NSLog(@"id: %i, username: %@, userpass: %@", id, username, userpass);
        }
    } else {
        NSLog(@"select operation is fail.");
    }
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:username,@"username",userpass,@"userpass", nil];
    sqlite3_finalize(statement);
    return dict;
}

- (void)closeDB {
    sqlite3_close(db);
}

- (BOOL)isExist:(NSString *)url {
    sqlite3_stmt *statement;
    NSInteger randomnum;
    BOOL isexist = 0;
    // @"select * from myTable"  查询所有 key 值内容
    NSString *selectSql = [NSString stringWithFormat:@"select id, randomnum, url, isdownload from Jiandan where url='%@'",url];
    
    if (sqlite3_prepare_v2(db, [selectSql UTF8String], -1, &statement, nil) == SQLITE_OK) {
        
        while(sqlite3_step(statement) == SQLITE_ROW) {
            
            // 查询 id 的值
            int id = sqlite3_column_int(statement, 0);
            if (sqlite3_column_int(statement, 0)) {
                isexist = YES;
            }
            // 查询 randomnum 的值
            randomnum = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
            NSLog(@"id: %d, randomum: %ld, url: %@", id, (long)randomnum, url);
        }
    } else {
        NSLog(@"select operation is fail.");
    }
    sqlite3_finalize(statement);
    return isexist;
}

- (NSMutableArray*)getAllUrl {
    NSMutableArray *urlArray = [NSMutableArray array];
    sqlite3_stmt *statement=nil;
    //    NSInteger id;
    NSString *url;
    NSInteger randomnum;
    BOOL isdownload = NO;
    // @"select * from myTable"  查询所有 key 值内容
    NSString *selectSql = [NSString stringWithFormat:@"select randomnum, url, isdownload from Jiandan;"];
    
    if (sqlite3_prepare_v2(db, [selectSql UTF8String], -1, &statement, nil) == SQLITE_OK) {
        
        while(sqlite3_step(statement) == SQLITE_ROW) {
            
            // 查询 randomnum 的值
            randomnum = sqlite3_column_int(statement, 0);
            
            // 查询 url 的值
            url = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
            
            // 查询 isdownload
            if (sqlite3_column_int(statement, 2)) {
                isdownload = YES;
            }
            SpiderRecord *sp = [[SpiderRecord alloc]initWithUrl:url num:randomnum isdownload:isdownload];
            [urlArray addObject:sp];
            NSLog(@"randomnum: %ld, url: %@, isdownload: %@",(long)randomnum, url, isdownload);
        }
    } else {
        NSLog(@"select operation is fail.");
    }
    
    sqlite3_finalize(statement);
    return urlArray;
}

@end
