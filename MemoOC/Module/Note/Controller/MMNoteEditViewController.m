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
@interface MMNoteEditViewController ()
@property (strong, nonatomic) MMNoteEditTextView * editTextView;
@end

@implementation MMNoteEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initSubviews {
    self.editTextView = [[MMNoteEditTextView alloc] init];
    [self.view addSubview:self.editTextView];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveNote)];
    [right setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorFromHexString:kColorDark]} forState:UIControlStateNormal];
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
    UINavigationController *naVC = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:naVC animated:YES completion:nil];
}

- (void)saveNote {
    
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
