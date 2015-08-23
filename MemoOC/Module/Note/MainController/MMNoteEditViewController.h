//
//  MMNoteEditViewController.h
//  MemoOC
//
//  Created by dai.fengyi on 15/7/31.
//  Copyright (c) 2015年 childrenOurFuture. All rights reserved.
//
//  次级页面（详情页面，编辑页面）
#import "MMViewController.h"
@class MMNote;
typedef void(^EditBlock)(NSString *notebookName);
@interface MMNoteEditViewController : MMViewController
@property (strong, nonatomic) EditBlock afterEdit;
@property (copy, nonatomic) MMNote *note;
@end
