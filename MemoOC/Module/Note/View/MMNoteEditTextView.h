//
//  MMNoteEditTextView.h
//  MemoOC
//
//  Created by dai.fengyi on 15/7/31.
//  Copyright (c) 2015年 childrenOurFuture. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMNoteData.h"
@interface MMNoteEditTextView : UITextView
@property (strong, nonatomic) UITextField *topicTextField;
@property (strong, nonatomic) UIButton *notebook;
@property (strong, nonatomic) UIButton *locationButton;
//DATA
@property (weak, nonatomic) MMNote *note;
@end
