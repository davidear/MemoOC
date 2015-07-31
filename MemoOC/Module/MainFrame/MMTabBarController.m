//
//  MMTabBarController.m
//  MemoOC
//
//  Created by dai.fengyi on 15/7/31.
//  Copyright (c) 2015年 childrenOurFuture. All rights reserved.
//

#import "MMTabBarController.h"
#import "MMNoteCollectionViewController.h"
@interface MMTabBarController ()

@end

@implementation MMTabBarController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initSubControllers];
    }
    return self;
}

- (void)awakeFromNib {
    [self initSubControllers];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initSubControllers];
}
- (void)initSubControllers {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Note" bundle:nil];
    MMNoteCollectionViewController *vc = [storyboard instantiateInitialViewController];
    [self setViewControllers:@[vc]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
