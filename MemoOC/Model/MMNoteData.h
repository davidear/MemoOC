//
//  MMNote.h
//  MemoOC
//
//  Created by dai.fengyi on 15/8/1.
//  Copyright (c) 2015年 childrenOurFuture. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface MMNote : NSObject<NSCopying>
@property (assign, nonatomic) NSNumber *noteId;
@property (strong, nonatomic) NSString *notebook;
//@property (strong, nonatomic) NSString *notebookId;
@property (strong, nonatomic) NSDate *creatDate;
@property (strong, nonatomic) NSDate *editDate;
@property (strong, nonatomic) NSArray *tags;
@property (strong, nonatomic) NSString *topic;
@property (strong, nonatomic) NSString *article;
//@property (strong, nonatomic) 地址
@property (strong, nonatomic) NSString *toNotebook;//仅用于处理过程中，从一个notebook换到另一个
@end
#pragma mark -
@interface MMNotebook : NSObject
@property (strong, nonatomic) NSString *notebookId;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSArray *notes;
@end
#pragma mark -
@interface MMNoteData : NSObject
+ (BOOL)createNotebook:(NSString *)name;
+ (BOOL)deleteNotebook:(NSString *)name;
+ (BOOL)saveNote:(MMNote *)note;
+ (NSArray *)readAllNotebook;
+ (NSArray *)readNoteInNotebook:(NSString *)name;
+ (NSArray *)readAllNote;
@end
