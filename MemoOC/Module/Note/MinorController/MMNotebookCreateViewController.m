//
//  MMNotebookCreateViewController.m
//  MemoOC
//
//  Created by dai.fengyi on 15/8/5.
//  Copyright (c) 2015年 childrenOurFuture. All rights reserved.
//

#import "MMNotebookCreateViewController.h"
#import "MMNoteData.h"
@interface MMNotebookCreateViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) UITextField *textField;
@end

@implementation MMNotebookCreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initSubviews];
    [self setUI];
}
#pragma mark - COMMON OPERATION
- (void)setUI {
    
}
- (void)initSubviews {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.bounces = YES;
    scrollView.scrollEnabled = YES;
    [self.view addSubview:scrollView];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 44)];
    textField.backgroundColor = [UIColor colorFromHexString:@"0xEFEFF4"];
    UIView *leftBlank = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, textField.bounds.size.height)];
    textField.leftView = leftBlank;
    textField.placeholder = @"请输入笔记本名称";
    textField.clearButtonMode = UITextFieldViewModeAlways;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.returnKeyType = UIReturnKeyDone;
    textField.delegate = self;
    [textField becomeFirstResponder];
    [scrollView addSubview:textField];
    self.textField = textField;
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveNotebook)];
//    [right setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorFromHexString:kColorDark]} forState:UIControlStateNormal];
    right.enabled = NO;
    self.navigationItem.rightBarButtonItem = right;
}
#pragma mark - Button Action
- (void)saveNotebook {
//    [CommonHelper showMsg:[MMNoteData createNotebook:self.textField.text] ? @"创建成功" : @"创建失败"];
    if ([MMNoteData createNotebook:self.textField.text]) {
        self.create(self.textField.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - TextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.text.length != 0) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self saveNotebook];
    return YES;
}
@end
