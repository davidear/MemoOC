//
//  MMPhotoViewController.m
//  MemoOC
//
//  Created by dai.fengyi on 15/8/25.
//  Copyright (c) 2015年 childrenOurFuture. All rights reserved.
//

#import "MMPhotoViewController.h"

@interface MMPhotoViewController ()<MWPhotoBrowserDelegate>
@property (strong, nonatomic) NSMutableArray *photos;
@end

@implementation MMPhotoViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.delegate = self;
        self.photos = [NSMutableArray array];
        for (int i = 0; i < 20; i++) {
            NSString *name = [NSString stringWithFormat:@"%d.jpg", i];
            MWPhoto *p = [MWPhoto photoWithImage:[UIImage imageNamed:name]];
            [self.photos addObject:p];
        }
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Set options
    self.displayActionButton = YES; // Show action button to allow sharing, copying, etc (defaults to YES)
    self.displayNavArrows = NO; // Whether to display left and right nav arrows on toolbar (defaults to NO)
    self.displaySelectionButtons = NO; // Whether selection buttons are shown on each image (defaults to NO)
    self.zoomPhotosToFill = YES; // Images that almost fill the screen will be initially zoomed to fill (defaults to YES)
    self.alwaysShowControls = NO; // Allows to control whether the bars and controls are always visible or whether they fade away to show the photo full (defaults to NO)
    self.enableGrid = YES; // Whether to allow the viewing of all the photo thumbnails on a grid (defaults to YES)
    self.startOnGrid = NO; // Whether to start on the grid of thumbnails instead of the first photo (defaults to NO)
    self.autoPlayOnAppear = NO; // Auto-play first video
    
    // Customise selection images to change colours if required
    self.customImageSelectedIconName = @"ImageSelected.png";
    self.customImageSelectedSmallIconName = @"ImageSelectedSmall.png";
    
    // Optionally set the current visible photo before displaying
    [self setCurrentPhotoIndex:1];
    
    // Manipulate
    [self showNextPhotoAnimated:YES];
    [self showPreviousPhotoAnimated:YES];
    [self setCurrentPhotoIndex:10];
}


#pragma mark - MWPhotoselfDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.photos.count;
}
- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    return [self.photos objectAtIndex:index];
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
  return [self.photos objectAtIndex:index];
}
@end
