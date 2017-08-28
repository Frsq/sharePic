//
//  sqlLiteUtil.m
//  sharePic
//
//  Created by etta cai on 2017/8/27.
//  Copyright © 2017年 johnqzheng. All rights reserved.
//

#import "sqlLiteUtil.h"

@implementation sqlLiteUtil

#pragma mark - 设置数据库信息

+ (id)sqlLiteUtil {
    static sqlLiteUtil *sharedSqlUtil = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedSqlUtil = [[self alloc]init];
    });

    return sharedSqlUtil;
}

- (id)init {
    if (self == [super init]) {
        databaseFilePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Desktop/mydb.sqlite"];

    }

    return self;
}

#pragma mark - 数据库操作
- (void)OpenDB {
    // 打开数据库，数据库文件不存在时，自动创建文件
    
    if (sqlite3_open([databaseFilePath UTF8String], &db) == SQLITE_OK) {
        NSLog(@"sqlite dadabase is opened.");
    } else {
        NSLog(@"sqlite dadabase open fail.");
    }

}

- (void)createSql {
    /*
     sql 语句，专门用来操作数据库的语句。
     create table if not exists 是固定的，如果表不存在就创建。
     myTable() 表示一个表，myTable 是表名，小括号里是字段信息。
     字段之间用逗号隔开，每一个字段的第一个单词是字段名，第二个单词是数据类型，primary key 代表主键，autoincrement 是自增。
     */
    
    NSString *createSql = @"create table if not exists myTable(id integer primary key autoincrement, name text, age integer, address text)";
    
    if (sqlite3_exec(db, [createSql UTF8String], NULL, NULL, &error) == SQLITE_OK) {
        NSLog(@"create table is ok.");
    } else {
        NSLog(@"error: %s", error);
        
        // 每次使用完毕清空 error 字符串，提供给下一次使用
        sqlite3_free(error);
    }
}

- (void)insertSql {
    NSString *insertSql = @"insert into myTable(name, age, address) values('小新', '8', '东城区')";
    
    if (sqlite3_exec(db, [insertSql UTF8String], NULL, NULL, &error) == SQLITE_OK) {
        NSLog(@"insert operation is ok.");
    } else {
        NSLog(@"error: %s", error);
        
        // 每次使用完毕清空 error 字符串，提供给下一次使用
        sqlite3_free(error);
    }
}

- (void)updateSql {
    NSString *updateSql = @"update myTable set name = '小白', age = '10', address = '西城区' where id = 2";
    
    if (sqlite3_exec(db, [updateSql UTF8String], NULL, NULL, &error) == SQLITE_OK) {
        NSLog(@"update operation is ok.");
    } else {
        NSLog(@"error: %s", error);
        
        // 每次使用完毕清空 error 字符串，提供给下一次使用
        sqlite3_free(error);
    }
}

- (void)deleteSql {
    NSString *deleteSql = @"delete from myTable where id = 3";
    
    if (sqlite3_exec(db, [deleteSql UTF8String], NULL, NULL, &error) == SQLITE_OK) {
        NSLog(@"delete operation is ok.");
    } else {
        NSLog(@"error: %s", error);
        
        // 每次使用完毕清空 error 字符串，提供给下一次使用
        sqlite3_free(error);
    }
}

- (void)selectSql {
    sqlite3_stmt *statement;
    
    // @"select * from myTable"  查询所有 key 值内容
    NSString *selectSql = @"select id, name, age, address from myTable";
    
    if (sqlite3_prepare_v2(db, [selectSql UTF8String], -1, &statement, nil) == SQLITE_OK) {
        
        while(sqlite3_step(statement) == SQLITE_ROW) {
            
            // 查询 id 的值
            int _id = sqlite3_column_int(statement, 0);
            
            // 查询 name 的值
            NSString *name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
            
            // 查询 age
            int age = sqlite3_column_int(statement, 2);
            
            // 查询 name 的值
            NSString *address = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
            
            NSLog(@"id: %i, name: %@, age: %i, address: %@", _id, name, age, address);
        }
    } else {
        NSLog(@"select operation is fail.");
    }
    
    sqlite3_finalize(statement);
}

- (void)closeDB {
    sqlite3_close(db);
}

@end
