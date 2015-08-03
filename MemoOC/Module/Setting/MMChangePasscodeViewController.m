//
//  MMChangePasscodeViewController.m
//  MemoOC
//
//  Created by dai.fengyi on 15/8/3.
//  Copyright (c) 2015年 childrenOurFuture. All rights reserved.
//

#import "MMChangePasscodeViewController.h"

@interface MMChangePasscodeViewController ()

@end

@implementation MMChangePasscodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - 继承
- (void)finishWithResult:(BOOL)success animated:(BOOL)animated {
//    [self.invisiblePasscodeField resignFirstResponder];
    [self.view resignFirstResponder];
    if (self.willFinishWithResult) {
        self.willFinishWithResult(success);
    } else {
        [self dismissViewControllerAnimated:animated completion:nil];
    }
}
@end
