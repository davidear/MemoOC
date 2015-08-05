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
@end
#pragma mark - 
@implementation MMNoteData
+ (BOOL)createNotebook:(NSString *)name {
    return [[FMDBHelper sharedFMDBHelper] insertNotebook:name];
}
+ (BOOL)saveNote:(MMNote *)note {
    return [[FMDBHelper sharedFMDBHelper] insertNote:note];
}
+ (NSArray *)readAllNotebook {
    return [[FMDBHelper sharedFMDBHelper] readAllNotebook];
}
+ (NSArray *)readNoteInNotebook:(NSString *)name {
    NSArray *array = [[FMDBHelper sharedFMDBHelper] readNoteInNotebook:name];
    NSMutableArray *mutArray = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        MMNote *note = [MMNote objectWithKeyValues:dic];
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
