//
//  MMNoteCollectionViewController.m
//  MemoOC
//
//  Created by dai.fengyi on 15/7/31.
//  Copyright (c) 2015年 childrenOurFuture. All rights reserved.
//

#import "MMNoteCollectionViewController.h"
#import "MMNoteEditViewController.h"
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
    CGFloat bottomMaxY = MAX(self.collectionView.contentSize.height + self.collectionView.contentInset.bottom - [UIScreen mainScreen].bounds.size.height, 0);
    
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
                frame.origin.y = cv.contentSize.height + cv.contentInset.bottom - 10 - deltaY * (cv.numberOfSections - attrs.indexPath.section) - 20 * (cv.numberOfSections - attrs.indexPath.section - 1) - 44 * cv.numberOfSections - attrs.indexPath.section;
                attrs.frame = frame;
            }
        }
    }
    return attrsArray;
}
@end

@interface MMNoteCollectionViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *amount;

@property (strong, nonatomic) NSMutableArray *dataArray;
@end

@implementation MMNoteCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.

    [self setUI];
}

- (void)loadData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"NoteList" ofType:@"plist"];
    _dataArray = [NSMutableArray arrayWithContentsOfFile:path];
}
- (void)setUI {
//    noteLayout.itemSize = CGSizeMake(UIScreen.mainScreen().bounds.width - 40, 44)
//    //    noteLayout.headerReferenceSize = CGSizeMake(UIScreen.mainScreen().bounds.width - 40, <#height: CGFloat#>)
//    noteLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
#warning Incomplete method implementation -- Return the number of sections
    return self.dataArray.count;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
#warning Incomplete method implementation -- Return the number of items in the section
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    
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
