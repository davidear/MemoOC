//
//  MMPhotoData.h
//  MemoOC
//
//  Created by dai.fengyi on 15/9/1.
//  Copyright (c) 2015年 childrenOurFuture. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMPhoto : NSObject<NSCopying>
@property (assign, nonatomic) NSNumber *photoId;
@property (strong, nonatomic) NSString *imageUrl;
@property (strong, nonatomic) NSString *thumbUrl;
@property (strong, nonatomic) NSString *photoAlbum;
//@property (strong, nonatomic) NSString *photoAlbumId;
@property (strong, nonatomic) NSDate *creatDate;
@property (strong, nonatomic) NSDate *editDate;
@property (strong, nonatomic) NSArray *tags;
@property (strong, nonatomic) NSString *topic;
@property (strong, nonatomic) NSString *article;
//@property (strong, nonatomic) 地址
@property (strong, nonatomic) NSString *toPhotoAlbum;//仅用于处理过程中，从一个photoAlbum换到另一个
@end
#pragma mark -
@interface MMPhotoAlbum : NSObject
@property (strong, nonatomic) NSString *photoAlbumId;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSArray *photos;
@end
#pragma mark -
@interface MMPhotoData : NSObject
+ (BOOL)createPhotoAlbum:(NSString *)name;
+ (BOOL)deletePhotoAlbum:(NSString *)name;
+ (BOOL)savePhoto:(MMPhoto *)photo;
+ (NSArray *)readAllPhotoAlbum;
+ (NSArray *)readPhotoInPhotoAlbum:(NSString *)name;
+ (NSArray *)readAllPhoto;

@end
