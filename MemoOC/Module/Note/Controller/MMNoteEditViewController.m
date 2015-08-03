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
}
- (void)setUI {
//    CGRect rect = [UIScreen mainScreen].applicationFrame;
    [_editTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
        make.left.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
    }];
    
    [_editTextView.notebook addTarget:self action:@selector(notebookSelection:) forControlEvents:UIControlEventTouchUpInside];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)keyboardWillChangeFrameNotification:(NSNotification *)aNotification {
    NSDictionary *userInfo = aNotification.userInfo;
//    double animationDuration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    float keyboardHeight = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    _editTextView.contentInset = UIEdgeInsetsMake(0, 0, keyboardHeight, 0);
    [_editTextView scrollRangeToVisible:_editTextView.selectedRange];
}

#pragma mark - Button Aciton
- (void)notebookSelection:(UIButton *)sender {
    MMNotebookSelectionTableViewController *vc = [[MMNotebookSelectionTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    UINavigationController *naVC = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:naVC animated:YES completion:nil];
}
@end
