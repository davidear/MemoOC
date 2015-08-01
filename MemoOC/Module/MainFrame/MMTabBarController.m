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
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    [button setImage:[UIImage imageNamed:@"iconfont-shezhi"] forState:UIControlStateNormal];
    [button setTitle:@"设置" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorFromHexString:kColorLight] forState:UIControlStateNormal];
//    [button setTintColor:[UIColor colorFromHexString:kColorDark]];
    [button addTarget:self action:@selector(setting:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = left;
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-xinzeng"] style:UIBarButtonItemStylePlain target:self action:@selector(postAddNotification)];
    self.navigationItem.rightBarButtonItem = right;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

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
#pragma mark - NOTIFICATION
- (void)setting:(UIButton *)sender {
    
}
- (void)postAddNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationAdd object:nil];
}

@end
