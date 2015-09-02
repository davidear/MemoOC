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
#import "MMPhotoData.h"
/*
 表结构：
 对一个品类有三个表：
 以Note为例：
 表一：notebook信息表
 结构：id, name
 表二：note信息表
 结构：id, name, topic...
 表三：note与notebook关系表
 结构：noteid notebookid
 */
#define kNotebookKeyArray       @[@"noteId", @"topic", @"creatDate", @"editDate", @"article",@"tags"]
typedef enum{
    NoteType = 0,
    PhotoType,
}DataType;
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
        NSLog(@"\n%@",_dbPath);
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
/*
 @property (assign, nonatomic) NSNumber *photoId;
 @property (strong, nonatomic) NSString *photoAlbum;
 //@property (strong, nonatomic) NSString *photoAlbumId;
 @property (strong, nonatomic) NSDate *creatDate;
 @property (strong, nonatomic) NSDate *editDate;
 @property (strong, nonatomic) NSArray *tags;
 @property (strong, nonatomic) NSString *topic;
 @property (strong, nonatomic) NSString *article;
 //@property (strong, nonatomic) 地址
 @property (strong, nonatomic) NSString *toPhotoAlbum;//仅用于处理过程中，从一个photoAlbum换到另一个
 */
#pragma mark - Common
- (BOOL)insertTable:(NSString *)tableName type:(DataType)type{
    BOOL flag = NO;
    if (![self openDB]) {
        return flag;
    }
    if (![self.db tableExists:tableName]) {
        NSString *tempStr;
        switch (type) {
            case NoteType:
                tempStr = [NSString stringWithFormat:@"CREATE TABLE %@ (noteId INTEGER PRIMARY KEY, topic text, creatDate text, editDate text, article text, tags text)", tableName];
                break;
            case PhotoType:
                tempStr = [NSString stringWithFormat:@"CREATE TABLE %@ (photoId INTEGER PRIMARY KEY, imageUrl text, thumbUrl text, topic text, creatDate text, editDate text, article text, tags text)", tableName];
                break;
            default:
                break;
        }
        flag = [self.db executeUpdate:tempStr];
    }else flag = YES;
    [self closeDB];
    return flag;
}

- (BOOL)renameTable:(NSString *)oldName newName:(NSString *)newName {
    BOOL flag = NO;
    if (![self openDB]) {
        return flag;
    }
    if ([self.db tableExists:oldName]) {
        NSString *tempStr = [NSString stringWithFormat:@"ALTER TABLE %@ RENAME TO %@", oldName, newName];
        flag = [self.db executeUpdate:tempStr];
    }
    [self closeDB];
    return flag;
}

- (BOOL)deleteTable:(NSString *)tableName {
    BOOL flag = NO;
    if (![self openDB]) {
        return flag;
    }
    if ([self.db tableExists:tableName]) {
        NSString *tempStr = [NSString stringWithFormat:@"DROP TABLE %@", tableName];
        flag = [self.db executeUpdate:tempStr];
    }
    [self closeDB];
    return flag;
}

- (BOOL)insertObject:(id)object table:(NSString *)tableName type:(DataType)type {
    BOOL flag = NO;
    if (![self openDB]) {
        return flag;
    }
    if ([self.db tableExists:tableName]) {
        NSString *str;
        switch (type) {
            case NoteType:
            {
                MMNote *note = (MMNote *)object;
                str = [NSString stringWithFormat:@"INSERT INTO %@ (topic, creatDate, editDate, article, tags) VALUES (?,?,?,?,?)", tableName];
                flag = [self.db executeUpdate:str, note.topic, note.creatDate, @"2015.8.6", note.article, @"郊游"];
            }
                break;
            case PhotoType:
            {
                MMPhoto *photo = (MMPhoto *)object;
                str = [NSString stringWithFormat:@"INSERT INTO %@ (imageUrl, thumbUrl, topic, creatDate, editDate, article, tags) VALUES (?,?,?,?,?)", tableName];
                flag = [self.db executeUpdate:str, photo.imageUrl, photo.thumbUrl, photo.topic, photo.creatDate, @"2015.8.6", photo.article, @"郊游"];
            }
                break;
            default:
                break;
        }
    }
    [self closeDB];
    return flag;
}

- (BOOL)modifyObject:(id)object table:(NSString *)tableName type:(DataType)type {
    BOOL flag = NO;
    if (![self openDB]) {
        return flag;
    }
    if ([self.db tableExists:tableName]) {
        switch (type) {
            case NoteType:
            {
                MMNote *note = (MMNote *)object;
                NSString *str = [NSString stringWithFormat:@"UPDATE %@ SET topic = ?, creatDate = ?, editDate = ?, article = ?, tags = ? WHERE noteId = %@", tableName, note.noteId];
                flag = [self.db executeUpdate:str, note.topic, note.creatDate, @"2015.8.6", note.article, @"郊游"];
            }
                break;
            case PhotoType:
            {
                MMPhoto *photo = (MMPhoto *)object;
                NSString *str = [NSString stringWithFormat:@"UPDATE %@ SET imageUrl = ?, thumbUrl = ?, topic = ?, creatDate = ?, editDate = ?, article = ?, tags = ? WHERE noteId = %@", tableName, photo.photoId];
                flag = [self.db executeUpdate:str, photo.imageUrl, photo.thumbUrl, photo.topic, photo.creatDate, @"2015.8.6", photo.article, @"郊游"];
            }
                break;
            default:
                break;
        }
    }
    
    [self closeDB];
    return flag;
}

- (BOOL)deleteObjectWithObjectId:(NSNumber *)ObjectId table:(NSString *)tableName {
    BOOL flag = NO;
    if (![self openDB]) {
        return flag;
    }
    if ([self.db tableExists:tableName]) {
        NSString *str = [NSString stringWithFormat:@"DELETE FROM %@ WHERE noteId = %@", tableName, ObjectId];
        flag = [self.db executeUpdate:str];
    }
    
    [self closeDB];
    return flag;
}

- (NSArray *)readAllObject {
    if (![self openDB]) {
        return nil;
    }
    FMResultSet *rs = [self.db executeQuery:@"SELECT name FROM sqlite_master WHERE type='table'ORDER BY name"];
    NSMutableArray *mutableArray = [NSMutableArray array];
    while ([rs next]) {
        [mutableArray addObject:[rs objectForColumnName:@"name"]];
    }
    [rs close];
    [self closeDB];
    return [NSArray arrayWithArray:mutableArray];
}
#pragma mark - Note
- (BOOL)insertNotebook:(NSString *)notebookName {
//    BOOL flag = NO;
//    if (![self openDB]) {
//        return flag;
//    }
//    if (![self.db tableExists:notebookName]) {
//        NSString *tempStr = [NSString stringWithFormat:@"CREATE TABLE %@ (noteId INTEGER PRIMARY KEY, topic text, creatDate text, editDate text, article text, tags text)", notebookName];
//        flag = [self.db executeUpdate:tempStr];
//    }else flag = YES;
//    [self closeDB];
//    return flag;
    return [self insertTable:notebookName type:NoteType];
}

- (BOOL)renameNotebook:(NSString *)oldName newName:(NSString *)newName {
//    BOOL flag = NO;
//    if (![self openDB]) {
//        return flag;
//    }
//    if ([self.db tableExists:oldName]) {
//        NSString *tempStr = [NSString stringWithFormat:@"ALTER TABLE %@ RENAME TO %@", oldName, newName];
//        flag = [self.db executeUpdate:tempStr];
//    }
//    [self closeDB];
//    return flag;
    return [self renameTable:oldName newName:newName];
}

- (BOOL)deleteNotebook:(NSString *)notebookName {
//    BOOL flag = NO;
//    if (![self openDB]) {
//        return flag;
//    }
//    if ([self.db tableExists:notebookName]) {
//        NSString *tempStr = [NSString stringWithFormat:@"DROP TABLE %@", notebookName];
//        flag = [self.db executeUpdate:tempStr];
//    }
//    [self closeDB];
//    return flag;
    return [self deleteTable:notebookName];
}

- (BOOL)insertNote:(MMNote *)note notebook:(NSString *)notebookName {
//    BOOL flag = NO;
//    if (![self openDB]) {
//        return flag;
//    }
//    if ([self.db tableExists:notebookName]) {
////    flag = [self.db executeUpdate:@"INSERT INTO ? (id, topic, creatDate, editDate, article, tags) VALUES (?,?,?,?,?,?)" withArgumentsInArray:@[note.notebook, note.noteId, note.topic, note.creatDate, note.editDate, note.article, note.tags]];
//        NSString *str = [NSString stringWithFormat:@"INSERT INTO %@ (topic, creatDate, editDate, article, tags) VALUES (?,?,?,?,?)", notebookName];
//        flag = [self.db executeUpdate:str, note.topic, note.creatDate, @"2015.8.6", note.article, @"郊游"];
//    }
//    
//    [self closeDB];
//    return flag;
    return [self insertObject:note table:notebookName type:NoteType];
}

- (BOOL)modifyNote:(MMNote *)note notebook:(NSString *)notebookName {
//    BOOL flag = NO;
//    if (![self openDB]) {
//        return flag;
//    }
//    if ([self.db tableExists:notebookName]) {
//        //    flag = [self.db executeUpdate:@"INSERT INTO ? (id, topic, creatDate, editDate, article, tags) VALUES (?,?,?,?,?,?)" withArgumentsInArray:@[note.notebook, note.noteId, note.topic, note.creatDate, note.editDate, note.article, note.tags]];
//        NSString *str = [NSString stringWithFormat:@"UPDATE %@ SET topic = ?, creatDate = ?, editDate = ?, article = ?, tags = ? WHERE noteId = %@", notebookName, note.noteId];
//        flag = [self.db executeUpdate:str, note.topic, note.creatDate, @"2015.8.6", note.article, @"郊游"];
//    }
//    
//    [self closeDB];
//    return flag;
    return [self modifyObject:note table:notebookName type:NoteType];
}

- (BOOL)deleteNoteWithNoteId:(NSNumber *)noteId notebook:(NSString *)notebookName {
//    BOOL flag = NO;
//    if (![self openDB]) {
//        return flag;
//    }
//    if ([self.db tableExists:notebookName]) {
//        //    flag = [self.db executeUpdate:@"INSERT INTO ? (id, topic, creatDate, editDate, article, tags) VALUES (?,?,?,?,?,?)" withArgumentsInArray:@[note.notebook, note.noteId, note.topic, note.creatDate, note.editDate, note.article, note.tags]];
//        NSString *str = [NSString stringWithFormat:@"DELETE FROM %@ WHERE noteId = %@", notebookName, noteId];
//        flag = [self.db executeUpdate:str];
//    }
//    
//    [self closeDB];
//    return flag;
    return [self deleteObjectWithObjectId:noteId table:notebookName];
}

- (NSArray *)readAllNotebook {
    if (![self openDB]) {
        return nil;
    }
    FMResultSet *rs = [self.db executeQuery:@"SELECT name FROM sqlite_master WHERE type='table'ORDER BY name"];
    NSMutableArray *mutableArray = [NSMutableArray array];
    while ([rs next]) {
        [mutableArray addObject:[rs objectForColumnName:@"name"]];
    }
    [rs close];
    [self closeDB];
    return [NSArray arrayWithArray:mutableArray];
}

- (NSArray *)readNoteInNotebook:(NSString *)name {
    if (![self openDB]) {
        return nil;
    }
    if (![self.db tableExists:name]) {
        return nil;
    }
    NSString *str = [NSString stringWithFormat:@"select * from %@",name];
    FMResultSet *rs = [self.db executeQuery:str withArgumentsInArray:nil];
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
#pragma mark - Photo
- (BOOL)insertPhotoAlbum:(NSString *)photoAlbumName {
    return [self insertTable:photoAlbumName type:PhotoType];
}

- (BOOL)renamePhotoAlbum:(NSString *)oldName newName:(NSString *)newName {
    return [self renameTable:oldName newName:newName];
}

- (BOOL)deletePhotoAlbum:(NSString *)photoAlbumName {
    return [self deleteTable:photoAlbumName];
}

- (BOOL)insertPhoto:(MMPhoto *)photo photoAlbum:(NSString *)photoAlbumName {
    return [self insertObject:photo table:photoAlbumName type:PhotoType];
}

- (BOOL)modifyPhoto:(MMPhoto *)photo photoAlbum:(NSString *)photoAlbumName {
    return [self modifyObject:photo table:photoAlbumName type:PhotoType];
}

- (BOOL)deletePhotoWithPhotoId:(NSNumber *)photoId photoAlbum:(NSString *)photoAlbumName {
    return [self deleteObjectWithObjectId:photoId table:photoAlbumName];
}

//- (NSArray *)readAllNotebook {
//    if (![self openDB]) {
//        return nil;
//    }
//    FMResultSet *rs = [self.db executeQuery:@"SELECT name FROM sqlite_master WHERE type='table'ORDER BY name"];
//    NSMutableArray *mutableArray = [NSMutableArray array];
//    while ([rs next]) {
//        [mutableArray addObject:[rs objectForColumnName:@"name"]];
//    }
//    [rs close];
//    [self closeDB];
//    return [NSArray arrayWithArray:mutableArray];
//}
//
//- (NSArray *)readNoteInNotebook:(NSString *)name {
//    if (![self openDB]) {
//        return nil;
//    }
//    if (![self.db tableExists:name]) {
//        return nil;
//    }
//    NSString *str = [NSString stringWithFormat:@"select * from %@",name];
//    FMResultSet *rs = [self.db executeQuery:str withArgumentsInArray:nil];
//    NSMutableArray *mutableArray = [NSMutableArray array];
//    while ([rs next]) {
//        NSMutableDictionary *mutableDic = [NSMutableDictionary dictionary];
//        for (NSString *str in kNotebookKeyArray ) {
//            [mutableDic setObject:[rs objectForColumnName:str] forKey:str];
//        }
//        [mutableArray addObject:mutableDic];
//    }
//    [rs close];
//    [self closeDB];
//    return [NSArray arrayWithArray:mutableArray];
//}
@end
