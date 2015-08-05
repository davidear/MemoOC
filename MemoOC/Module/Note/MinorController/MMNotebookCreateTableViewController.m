//
//  MMNotebookCreateTableViewController.m
//  MemoOC
//
//  Created by dai.fengyi on 15/8/5.
//  Copyright (c) 2015年 childrenOurFuture. All rights reserved.
//

#import "MMNotebookCreateTableViewController.h"

@interface MMNotebookCreateTableViewController ()

@end

@implementation MMNotebookCreateTableViewController
static NSString * const reuseIdentifier = @"Cell";
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
    [self.view addSubview:scrollView];
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 44)];
    textField.backgroundColor = [UIColor colorFromHexString:@"0xEFEFF4"];
    [scrollView addSubview:textField];
    self.tableView.tableHeaderView = textField;
}

#pragma mark - Table view delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }

    return cell;
}

@end
