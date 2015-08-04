//
//  MMSettingTableViewController.m
//  MemoOC
//
//  Created by dai.fengyi on 15/8/2.
//  Copyright (c) 2015年 childrenOurFuture. All rights reserved.
//

#import "MMSettingTableViewController.h"
#import "VENTouchLock.h"
#import "MMNavigationController.h"
@interface MMSettingSwitchCell: UITableViewCell

@end
@implementation MMSettingSwitchCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UISwitch *switchButton = [[UISwitch alloc] init];
        self.accessoryView = switchButton;
    }
    return self;
}

@end
@interface MMSettingTableViewController ()
@property (strong, nonatomic) NSMutableArray *dataArray;
@end

@implementation MMSettingTableViewController
static NSString * const reuseIdentifier = @"Cell";
static NSString * const SwitchReuseIdentifier = @"SwitchCell";

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self loadData];
    }
    return self;
}

//- (void)awakeFromNib {
//    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(dismissVC)];
//    [left setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorFromHexString:kColorDark]} forState:UIControlStateNormal];
//    self.navigationItem.leftBarButtonItem = left;
//
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

- (void)loadData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"SettingList" ofType:@"plist"];
    self.dataArray = [NSMutableArray arrayWithContentsOfFile:path];
}
- (void)setUI {
    [self.tableView registerClass:[MMSettingSwitchCell class] forCellReuseIdentifier:SwitchReuseIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//#pragma mark - Button action
//- (void)dismissVC {
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    }else {
        cell = [tableView dequeueReusableCellWithIdentifier:SwitchReuseIdentifier forIndexPath:indexPath];
        UISwitch *switchButton = (UISwitch *)cell.accessoryView;
        [switchButton addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    
    
    // Configure the cell...
    cell.textLabel.text = self.dataArray[indexPath.row][@"title"];
    return cell;
}
#pragma mark - Button Action
- (void)switchValueChanged:(UISwitch *)sender {
    
}
#pragma mark - Table View Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([[VENTouchLock sharedInstance] isPasscodeSet]) {
        VENTouchLockEnterPasscodeViewController *vc = [[VENTouchLockEnterPasscodeViewController alloc] init];
        __weak typeof(vc) weakself = vc;
        vc.willFinishWithResult = ^void(BOOL success) {
            if (success) {
                VENTouchLockCreatePasscodeViewController *createVC = [[VENTouchLockCreatePasscodeViewController alloc] init];
                [weakself.navigationController pushViewController:createVC animated:YES];
            }
        };
        MMNavigationController *nvc = [[MMNavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nvc animated:YES completion:nil];

    }else {
        VENTouchLockCreatePasscodeViewController *vc = [[VENTouchLockCreatePasscodeViewController alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
        MMNavigationController *nvc = [[MMNavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nvc animated:YES completion:nil];
    }

}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        return NO;
    }
    return YES;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
