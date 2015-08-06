//
//  MMNoteListViewController.m
//  MemoOC
//
//  Created by dai.fengyi on 15/8/1.
//  Copyright (c) 2015年 childrenOurFuture. All rights reserved.
//

#import "MMNoteListViewController.h"
#import "MMNoteEditViewController.h"
#import "MMNotebookSelectionTableViewController.h"
#import "MMNavigationController.h"
#import "MMNoteData.h"
@interface MMNoteLayout: UICollectionViewFlowLayout
@end

@implementation MMNoteLayout
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    CGPoint offset = self.collectionView.contentOffset;
    NSArray *attrsArray = [super layoutAttributesForElementsInRect:rect];
    CGFloat topMinY = -self.collectionView.contentInset.top;
    CGFloat bottomMaxY = MAX(self.collectionView.contentSize.height + self.collectionView.contentInset.bottom - self.collectionView.bounds.size.height, 0);
    
    if (offset.y < topMinY) {
        CGFloat deltaY = fabs((offset.y - topMinY) / 10);
        for (UICollectionViewLayoutAttributes *attrs in attrsArray) {
            if (attrs.representedElementKind == nil) {
                CGRect frame = attrs.frame;
                frame.origin.y = frame.origin.y + deltaY * attrs.indexPath.section;
                attrs.frame = frame;
            }
        }
    }
    
    if (offset.y > bottomMaxY) {
        CGFloat deltaY = fabs((offset.y - bottomMaxY) / 10);
        for (UICollectionViewLayoutAttributes *attrs in attrsArray) {
            if (attrs.representedElementKind == nil) {
                CGRect frame = attrs.frame;
                UICollectionView *cv = self.collectionView;
                frame.origin.y = cv.contentSize.height + cv.contentInset.bottom - 10 - deltaY * (cv.numberOfSections - attrs.indexPath.section) - 20 * (cv.numberOfSections - attrs.indexPath.section - 1) - 44 * (cv.numberOfSections - attrs.indexPath.section);
                attrs.frame = frame;
            }
        }
    }
    return attrsArray;
}
@end
#pragma mark -
@interface MMnoteCollectionCell: UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *amount;
@end

@implementation MMnoteCollectionCell
@end

#pragma mark -
@interface MMNoteListViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UINavigationBar *naviBar;//尽为UI服务，实际的navigaitonbar已经被隐藏
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *notebookButton;
@property (weak, nonatomic) IBOutlet MMNoteLayout *noteLayout;

@property (strong, nonatomic) NSString *selectedNotebook;
@property (strong, nonatomic) NSArray *dataArray;

@end

@implementation MMNoteListViewController
static NSString * const reuseIdentifier = @"Cell";
- (void)setSelectedNotebook:(NSString *)selectedNotebook {
    _selectedNotebook = selectedNotebook;
    [self loadData];
    [self.notebookButton setTitle:selectedNotebook forState:UIControlStateNormal];
    [self.collectionView reloadData];
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createNote:) name:kNotificationAdd object:nil];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)loadData {
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"NoteList" ofType:@"plist"];
//    self.dataArray = [NSMutableArray arrayWithContentsOfFile:path];
    if ([self.selectedNotebook isEqualToString:@"全部笔记"]) {
        self.dataArray = [MMNoteData readAllNote];
    }else {
        self.dataArray = [MMNoteData readNoteInNotebook:self.selectedNotebook];
    }
}
- (void)setUI {
    [self.naviBar setBackgroundImage:[UIImage imageNamed:@"navi-dark-bg"] forBarMetrics:UIBarMetricsDefault];

    self.noteLayout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 40, 44);
    //    noteLayout.headerReferenceSize = CGSizeMake(UIScreen.mainScreen().bounds.width - 40, <#height: CGFloat#>)
    self.noteLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    self.selectedNotebook = @"全部笔记";
}
#pragma mark Button Action
- (void)createNote:(UIButton *)sender {
    MMNoteEditViewController *vc = [[MMNoteEditViewController alloc] init];
    __weak typeof(self) weakSelf = self;
    vc.afterEdit = ^(NSString *notebookName) {
        weakSelf.selectedNotebook = notebookName;
    };
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)selectNotebook:(UIButton *)sender {
    MMNotebookSelectionTableViewController *vc = [[MMNotebookSelectionTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    vc.addedOptionForAll = YES;
    __weak typeof(self) weakSelf = self;
    vc.selection = ^void(NSString *notebookName) {
        weakSelf.selectedNotebook = notebookName;
    };
    UINavigationController *naVC = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:naVC animated:YES completion:nil];
}
- (IBAction)selectLocation:(UIButton *)sender {
}
#pragma mark - NOTIFICATION
- (IBAction)setting:(UIButton *)sender {
    MMNavigationController *settingNVC = [[UIStoryboard storyboardWithName:@"Setting" bundle:nil] instantiateInitialViewController];
    [self presentViewController:settingNVC animated:YES completion:nil];
}
- (IBAction)postAddNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationAdd object:nil];
}
#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MMnoteCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    // Configure the cell
//    cell.logo.image = [UIImage imageNamed:self.dataArray[indexPath.section][@"logo"]];]
    MMNote *note = self.dataArray[indexPath.section];
    cell.name.text = note.topic;
//    cell.amount.text = @"5";
    return cell;
}

#pragma mark <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.navigationController pushViewController:[[MMNoteEditViewController alloc] init] animated:YES];
}
/*
 // Uncomment this method to specify if the specified item should be highlighted during tracking
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
 }
 */

/*
 // Uncomment this method to specify if the specified item should be selected
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
 return YES;
 }
 */

/*
 // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
 }
 
 - (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
 }
 
 - (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
 }
 */

@end
