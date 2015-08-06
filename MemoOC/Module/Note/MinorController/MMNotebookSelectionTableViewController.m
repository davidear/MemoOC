//
//  MMNotebookSelectionTableViewController.m
//  MemoOC
//
//  Created by dai.fengyi on 15/8/3.
//  Copyright (c) 2015年 childrenOurFuture. All rights reserved.
//

#import "MMNotebookSelectionTableViewController.h"
#import "MMNotebookCreateViewController.h"
#import "MMNotebookCreateTableViewController.h"
#import "MMNoteData.h"

@interface MMNotebookSelectionTableViewController ()<UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate>
@property (strong, nonatomic) UISearchController *searchController;

@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) NSMutableArray *filtedArray;
@end

@implementation MMNotebookSelectionTableViewController
static NSString * const reuseIdentifier = @"Cell";
- (void)setAddedOptionForAll:(BOOL)addedOptionForAll {
    _addedOptionForAll = addedOptionForAll;
    [self loadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self initSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadData];
}
- (void)setFiltedArray:(NSMutableArray *)filtedArray {
    _filtedArray = filtedArray;
    [self.tableView reloadData];
}
- (void)loadData {
    self.dataArray = [MMNoteData readAllNotebook];
    self.filtedArray = [self.dataArray mutableCopy];
}
- (void)initSubviews {
    UISearchController *searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    searchController.searchResultsUpdater = self;
    [searchController.searchBar sizeToFit];
    self.tableView.tableHeaderView = searchController.searchBar;
    
    searchController.delegate = self;
    searchController.dimsBackgroundDuringPresentation = NO;
    searchController.searchBar.delegate = self;

    self.definesPresentationContext = YES;
    
    self.searchController = searchController;
    

}

#pragma mark - Table view delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2 + (int)self.addedOptionForAll;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == 0) {
        return 1;
    }else if (section == 1) {
        return self.addedOptionForAll ? 1 : self.filtedArray.count;
    }else {
        return self.filtedArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    // Configure the cell...
    if (indexPath.section == 0) {
        cell.imageView.image = [UIImage imageNamed:@"iconfont-dark-xinzeng"];
        cell.textLabel.text = @"新增笔记本";
    }else if (indexPath.section == 1) {
        cell.textLabel.text = self.addedOptionForAll ? @"全部笔记" : self.filtedArray[indexPath.row];
    }else {
        cell.textLabel.text = self.filtedArray[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MMNotebookCreateViewController *vc = [[MMNotebookCreateViewController alloc] init];
//        MMNotebookCreateTableViewController *vc = [[MMNotebookCreateTableViewController alloc] init];
        vc.create = ^void(NSString *notebookName) {
            self.selection(notebookName);
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section == 1 && self.addedOptionForAll) {
        self.selection(@"全部笔记");
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }else {
        self.selection(_dataArray[indexPath.row]);
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}
#pragma mark - UISearchResultsUpdating
//david
//这个筛选需要优化
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    // update the filtered array based on the search text
//    NSString *searchText = searchController.searchBar.text;
//    NSMutableArray *searchResults = [self.dataArray mutableCopy];
//    
//    // strip out all the leading and trailing spaces
//    NSString *strippedString = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//    
//    // break up the search terms (separated by spaces)
//    NSArray *searchItems = nil;
//    if (strippedString.length > 0) {
//        searchItems = [strippedString componentsSeparatedByString:@" "];
//    }
//    
//    // build all the "AND" expressions for each value in the searchString
//    //
//    NSMutableArray *andMatchPredicates = [NSMutableArray array];
    
//    for (NSString *searchString in searchItems) {
//        // each searchString creates an OR predicate for: name, yearIntroduced, introPrice
//        //
//        // example if searchItems contains "iphone 599 2007":
//        //      name CONTAINS[c] "iphone"
//        //      name CONTAINS[c] "599", yearIntroduced ==[c] 599, introPrice ==[c] 599
//        //      name CONTAINS[c] "2007", yearIntroduced ==[c] 2007, introPrice ==[c] 2007
//        //
//        NSMutableArray *searchItemsPredicate = [NSMutableArray array];
//        
//        // Below we use NSExpression represent expressions in our predicates.
//        // NSPredicate is made up of smaller, atomic parts: two NSExpressions (a left-hand value and a right-hand value)
//        
//        // name field matching
//        NSExpression *lhs = [NSExpression expressionForKeyPath:@"title"];
//        NSExpression *rhs = [NSExpression expressionForConstantValue:searchString];
//        NSPredicate *finalPredicate = [NSComparisonPredicate
//                                       predicateWithLeftExpression:lhs
//                                       rightExpression:rhs
//                                       modifier:NSDirectPredicateModifier
//                                       type:NSContainsPredicateOperatorType
//                                       options:NSCaseInsensitivePredicateOption];
//        [searchItemsPredicate addObject:finalPredicate];
//        
//        // yearIntroduced field matching
//        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
//        numberFormatter.numberStyle = NSNumberFormatterNoStyle;
//        NSNumber *targetNumber = [numberFormatter numberFromString:searchString];
//        if (targetNumber != nil) {   // searchString may not convert to a number
//            lhs = [NSExpression expressionForKeyPath:@"yearIntroduced"];
//            rhs = [NSExpression expressionForConstantValue:targetNumber];
//            finalPredicate = [NSComparisonPredicate
//                              predicateWithLeftExpression:lhs
//                              rightExpression:rhs
//                              modifier:NSDirectPredicateModifier
//                              type:NSEqualToPredicateOperatorType
//                              options:NSCaseInsensitivePredicateOption];
//            [searchItemsPredicate addObject:finalPredicate];
//            
//            // price field matching
//            lhs = [NSExpression expressionForKeyPath:@"introPrice"];
//            rhs = [NSExpression expressionForConstantValue:targetNumber];
//            finalPredicate = [NSComparisonPredicate
//                              predicateWithLeftExpression:lhs
//                              rightExpression:rhs
//                              modifier:NSDirectPredicateModifier
//                              type:NSEqualToPredicateOperatorType
//                              options:NSCaseInsensitivePredicateOption];
//            [searchItemsPredicate addObject:finalPredicate];
//        }
//        
//        // at this OR predicate to our master AND predicate
//        NSCompoundPredicate *orMatchPredicates = [NSCompoundPredicate orPredicateWithSubpredicates:searchItemsPredicate];
//        [andMatchPredicates addObject:orMatchPredicates];
//    }
    
    // match up the fields of the Product object
//    NSCompoundPredicate *finalCompoundPredicate =
//    [NSCompoundPredicate andPredicateWithSubpredicates:andMatchPredicates];
//    searchResults = [[searchResults filteredArrayUsingPredicate:finalCompoundPredicate] mutableCopy];
    
    // hand over the filtered results to our search results table
    
//    _filtedArray = [self.dataArray mutableCopy];
//    NSMutableArray *tempArr = [NSMutableArray array];
//    if (searchController.searchBar.text.length != 0) {
//        for (NSString *str in self.dataArray) {
//            BOOL contain = [str containsString:searchController.searchBar.text];
//            if (!contain) {
//                [tempArr addObject:str];
//            }
//        }
//        [_filtedArray removeObjectsInArray:tempArr];
//    [self.tableView reloadData];
//    }
    if (searchController.searchBar.text.length != 0) {
        NSPredicate *pre = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            return [evaluatedObject containsString:searchController.searchBar.text];
        }];
        _filtedArray = [self.dataArray filteredArrayUsingPredicate:pre];
    }else {
        _filtedArray = [self.dataArray mutableCopy];
    }
    [self.tableView reloadData];
    
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
