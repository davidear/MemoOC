//
//  MYDDBManager.m
//  MemoOC
//
//  Created by dfy on 15/1/9.
//  Copyright (c) 2015年 childrenAreOurFuture. All rights reserved.
//

#import "FMDBHelper.h"
#import "FMDB.h"
#import "MMNoteData.h"
#define kNotebookKeyArray       @[@"id", @"topic", @"creatDate", @"editDate", @"article",@"tags"]

@interface FMDBHelper ()
@property (strong, nonatomic) NSString *dbPath;
@property (strong, nonatomic) FMDatabase *db;
@property (strong, nonatomic) FMDatabaseQueue *queue;
@end
@implementation FMDBHelper
single_implementation(FMDBHelper);

- (id)init{
    self = [super init];
    if (self) {
        //操作数据库
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDirectory = [paths objectAtIndex:0];
        //调试期先写死
//        NSString *dataBaseName = [NSString stringWithFormat:@"%@_Database.db",[[NSUserDefaults standardUserDefaults] objectForKey:@"DepartmentId"]];
//        _dbPath = [documentDirectory stringByAppendingPathComponent:dataBaseName];
        _dbPath = [documentDirectory stringByAppendingPathComponent:@"MyDataBase.db"];
        _db = [FMDatabase databaseWithPath:_dbPath];
    }
    return self;
}

#pragma mark - 数据库操作
- (BOOL)openDB
{
    if (![_db open]) {
        NSLog(@"Could not open db.");
        return NO;
    }
    //为数据库设置缓存，提高查询效率
    [_db setShouldCacheStatements:YES];
    return YES;
}

- (BOOL)closeDB
{
    if (![_db close]) {
        NSLog(@"Could not close db.");
        return NO;
    }
    return YES;
}
/*
 @property (strong, nonatomic) NSString *noteId;
 @property (strong, nonatomic) NSString *notebookName;
 @property (strong, nonatomic) NSString *notebookId;
 @property (strong, nonatomic) NSDate *creatDate;
 @property (strong, nonatomic) NSDate *editDate;
 @property (strong, nonatomic) NSArray *tags;
 @property (strong, nonatomic) NSString *topic;
 @property (strong, nonatomic) NSString *article;
 */
#pragma mark 数据库public
- (BOOL)insertNotebook:(NSString *)notebookName {
    BOOL flag = NO;
    if (![self openDB]) {
        return flag;
    }
    if (![self.db tableExists:notebookName]) {
        flag = [self.db executeUpdate:@"CREATE TABLE ? (id text, topic text, creatDate text, editDate text, article text, tags text)" withArgumentsInArray:@[notebookName]];
    }else flag = YES;
    [self closeDB];
    return flag;
}

- (BOOL)insertNote:(MMNote *)note {
    BOOL flag = NO;
    if (![self openDB]) {
        return flag;
    }
    if (![self.db tableExists:note.notebook]) {
        [self.db executeUpdate:@"CREATE TABLE ? (id text, topic text, creatDate text, editDate text, article text, tags text)" withArgumentsInArray:@[note.notebook]];
    }
    flag = [self.db executeUpdate:@"INSERT INTO ? (id, topic, creatDate, editDate, article, tags)" withArgumentsInArray:@[note.notebook, note.noteId, note.topic, note.creatDate, note.editDate, note.article, note.tags]];
    
    [self closeDB];
    return flag;
}

- (NSArray *)readNotebook:(MMNotebook *)notebook {
    if (![self openDB]) {
        return nil;
    }
    if (![self.db tableExists:notebook.name]) {
        return nil;
    }
    FMResultSet *rs = [self.db executeQuery:@"select * from MaterialCatalogs" withArgumentsInArray:nil];
    NSMutableArray *mutableArray = [NSMutableArray array];
    while ([rs next]) {
        NSMutableDictionary *mutableDic = [NSMutableDictionary dictionary];
        for (NSString *str in kNotebookKeyArray ) {
            [mutableDic setObject:[rs objectForColumnName:str] forKey:str];
        }
        [mutableArray addObject:mutableDic];
    }
    [rs close];
    [self closeDB];
    return [NSArray arrayWithArray:mutableArray];
}

@end
