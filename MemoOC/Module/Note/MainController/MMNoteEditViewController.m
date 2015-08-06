//
//  MMNoteEditViewController.m
//  MemoOC
//
//  Created by dai.fengyi on 15/7/31.
//  Copyright (c) 2015年 childrenOurFuture. All rights reserved.
//

#import "MMNoteEditViewController.h"
#import "MMNoteEditTextView.h"
#import "MMNotebookSelectionTableViewController.h"
#import "MMNoteData.h"
@interface MMNoteEditViewController ()
@property (strong, nonatomic) MMNoteEditTextView * editTextView;
@end

@implementation MMNoteEditViewController
- (MMNote *)note {
    if (_note == nil) {
        _note = [[MMNote alloc] init];
    }
    return _note;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initSubviews {
    MMNoteEditTextView *editTextView = [[MMNoteEditTextView alloc] init];
    editTextView.note = self.note;
    self.editTextView = editTextView;
    [self.view addSubview:self.editTextView];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveNote)];
//    [right setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorFromHexString:kColorDark]} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = right;
}
- (void)setUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [_editTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
        make.left.equalTo(self.view).offset(8);
        make.bottom.equalTo(self.view).offset(-8);
        make.right.equalTo(self.view).offset(-8);
    }];
    
    [_editTextView.notebook addTarget:self action:@selector(notebookSelection:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Button Aciton
- (void)notebookSelection:(UIButton *)sender {
    MMNotebookSelectionTableViewController *vc = [[MMNotebookSelectionTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    vc.selection = ^void(NSString *notebookName) {
        _editTextView.note.notebook = notebookName;
        [_editTextView.notebook setTitle:notebookName forState:UIControlStateNormal];
    };
    UINavigationController *naVC = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:naVC animated:YES completion:nil];
}

/*
 @property (strong, nonatomic) NSString *noteId;
 @property (strong, nonatomic) NSString *notebook;
 @property (strong, nonatomic) NSDate *creatDate;
 @property (strong, nonatomic) NSDate *editDate;
 @property (strong, nonatomic) NSArray *tags;
 @property (strong, nonatomic) NSString *topic;
 @property (strong, nonatomic) NSString *article;*/
- (void)saveNote {
    _editTextView.note.topic = _editTextView.topicTextField.text;
    _editTextView.note.article = _editTextView.text;
    if ([MMNoteData saveNote:_editTextView.note]) {
        self.afterEdit(_editTextView.note.notebook);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Keyboard Notification
- (void)keyboardWillChangeFrameNotification:(NSNotification *)aNotification {
    NSDictionary *userInfo = aNotification.userInfo;
    //    double animationDuration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    float keyboardHeight = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    _editTextView.contentInset = UIEdgeInsetsMake(0, 0, keyboardHeight, 0);
    [_editTextView scrollRangeToVisible:_editTextView.selectedRange];
}
@end
