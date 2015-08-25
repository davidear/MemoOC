//
//  MMTabBarController.m
//  MemoOC
//
//  Created by dai.fengyi on 15/7/31.
//  Copyright (c) 2015年 childrenOurFuture. All rights reserved.
//

#import "MMTabBarController.h"
#import "MMNoteListViewController.h"
#import "MMPhotoListViewController.h"
//#import "MMSettingTableViewController.h"
#import "MMNavigationController.h"
@interface MMTabBarController ()

@end

@implementation MMTabBarController
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initSubControllers];
        [self setUI];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initSubControllers];
    }
    return self;
}

- (void)awakeFromNib {

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

}
- (void)initSubControllers {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Note" bundle:nil];
    MMNoteListViewController *noteVC = [storyboard instantiateInitialViewController];
    
    MMPhotoListViewController *photoVC = [[MMPhotoListViewController alloc] init];
    [self setViewControllers:@[noteVC, photoVC]];
}

- (void)setUI {
    UITabBarItem *item1 = [self.tabBar.items objectAtIndex:0];
    [item1 setImage:[UIImage imageNamed:@"iconfont-bijiben"]];
    UITabBarItem *item2 = [self.tabBar.items objectAtIndex:1];
    [item2 setImage:[UIImage imageNamed:@"iconfont-bijiben"]];
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
    MMNavigationController *settingNVC = [[UIStoryboard storyboardWithName:@"Setting" bundle:nil] instantiateInitialViewController];
    [self presentViewController:settingNVC animated:YES completion:nil];
}
- (void)postAddNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationAdd object:nil];
}

@end
