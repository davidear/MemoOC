//
//  MMNotebookCreateViewController.h
//  MemoOC
//
//  Created by dai.fengyi on 15/8/5.
//  Copyright (c) 2015年 childrenOurFuture. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^CreateBlock)(NSString *notebookName);
@interface MMNotebookCreateViewController : UIViewController
@property (strong, nonatomic)CreateBlock create;
@end
