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
//+ (NSArray *)readAllNotes {
//    [FMDBHelper sharedFMDBHelper] readNotebook:<#(MMNotebook *)#>
//}
+ (NSArray *)readNoteBook:(MMNotebook *)notebook {
    NSArray *array = [[FMDBHelper sharedFMDBHelper] readNotebook:notebook];
    NSMutableArray *mutArray = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        MMNote *note = [MMNote objectWithKeyValues:dic];
        [mutArray addObject:note];
    }
    return [NSArray arrayWithArray:mutArray];
}
@end