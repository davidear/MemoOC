//
//  MMNotebookSelectionTableViewController.h
//  MemoOC
//
//  Created by dai.fengyi on 15/8/3.
//  Copyright (c) 2015年 childrenOurFuture. All rights reserved.
//

#import "MMTableViewController.h"
typedef void(^SelectionBlock)(NSString *notebookName);
@interface MMNotebookSelectionTableViewController : MMTableViewController
@property (strong, nonatomic)SelectionBlock selection;
@end
