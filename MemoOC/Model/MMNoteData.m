//
//  MMNote.m
//  MemoOC
//
//  Created by dai.fengyi on 15/8/1.
//  Copyright (c) 2015年 childrenOurFuture. All rights reserved.
//

#import "MMNoteData.h"
#import "FMDBHelper.h"
#import "MJExtension.h"
@implementation MMNote
/*
 @property (strong, nonatomic) NSString *noteId;
 @property (strong, nonatomic) NSString *notebook;
 //@property (strong, nonatomic) NSString *notebookId;
 @property (strong, nonatomic) NSDate *creatDate;
 @property (strong, nonatomic) NSDate *editDate;
 @property (strong, nonatomic) NSArray *tags;
 @property (strong, nonatomic) NSString *topic;
 @property (strong, nonatomic) NSString *article;
 //@property (strong, nonatomic) 地址
 @property (strong, nonatomic) NSString *toNotebook;//仅用于处理过程中，从一个notebook换到另一个
 */
-(id)copyWithZone:(NSZone *)zone {
    MMNote *note = [[[self class] allocWithZone:zone] init];
    note.noteId = self.noteId;
    note.notebook = [self.notebook copy];
    note.creatDate = [self.creatDate copy];
    note.editDate = [self.editDate copy];
    note.tags = [self.tags copy];
    note.topic = [self.topic copy];
    note.article = [self.article copy];
    note.toNotebook = [self.toNotebook copy];
    return note;
}
@end
#pragma mark - 
@implementation MMNoteData
+ (BOOL)createNotebook:(NSString *)name {
    return [[FMDBHelper sharedFMDBHelper] insertNotebook:name];
}

+ (BOOL)deleteNotebook:(NSString *)name {
    return [[FMDBHelper sharedFMDBHelper] deleteNotebook:name];
}

+ (BOOL)saveNote:(MMNote *)note {
    if (note.noteId == nil) {//新增的note
        return [[FMDBHelper sharedFMDBHelper] insertNote:note notebook:note.toNotebook];
    }else if ([note.notebook isEqualToString:note.toNotebook ] || note.toNotebook == nil) {//修改note，不改动note的所属
        return [[FMDBHelper sharedFMDBHelper] modifyNote:note notebook:note.notebook];
    }else {//修改note，并且改动其所属notebook
        if ([[FMDBHelper sharedFMDBHelper] deleteNoteWithNoteId:note.noteId notebook:note.notebook]) {
            return [[FMDBHelper sharedFMDBHelper] insertNote:note notebook:note.toNotebook];
        }else return NO;
    }
}
+ (NSArray *)readAllNotebook {
    return [[FMDBHelper sharedFMDBHelper] readAllNotebook];
}
+ (NSArray *)readNoteInNotebook:(NSString *)name {
    NSArray *array = [[FMDBHelper sharedFMDBHelper] readNoteInNotebook:name];
    NSMutableArray *mutArray = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        MMNote *note = [MMNote objectWithKeyValues:dic];
        note.notebook = name;
        [mutArray addObject:note];
    }
    return [NSArray arrayWithArray:mutArray];
}
+ (NSArray *)readAllNote {
    NSArray *notebookArray = [self readAllNotebook];
    NSMutableArray *mutArray = [NSMutableArray array];
    for (NSString *notebookName in notebookArray) {
        NSArray *noteArray = [self readNoteInNotebook:notebookName];
        [mutArray addObjectsFromArray:noteArray];
    }
    return [NSArray arrayWithArray:mutArray];
}
@end
