//
//  MMPhotoData.m
//  MemoOC
//
//  Created by dai.fengyi on 15/9/1.
//  Copyright (c) 2015年 childrenOurFuture. All rights reserved.
//
//  个人体会：每一次抽象，都没有完全体会到他的用处，这一次真的体会到了，由于数据库方面知识的补强，发现原数据库设计有很大的问题，需要推倒重建，这个时候，由于有抽象层，我只需要动刀动到这一层足矣，不影响上层，至少把损失降到最小了

#import "MMPhotoData.h"
#import "FMDBHelper.h"
#import "MJExtension.h"

@implementation MMPhoto
-(id)copyWithZone:(NSZone *)zone {
//    MMPhoto *photo = [[[self class] allocWithZone:zone] init];
//    photo.photoId = self.photoId;
//    photo.PhotoAlbum = [self.PhotoAlbum copy];
//    photo.creatDate = [self.creatDate copy];
//    photo.editDate = [self.editDate copy];
//    photo.tags = [self.tags copy];
//    photo.topic = [self.topic copy];
//    photo.article = [self.article copy];
//    photo.toPhotoAlbum = [self.toPhotoAlbum copy];
    MMPhoto *photo = [[[self class] allocWithZone:zone] init];
    return photo;
}
@end
#pragma mark -
@implementation MMPhotoData
+ (BOOL)createPhotoAlbum:(NSString *)name {
    return [[FMDBHelper sharedFMDBHelper] insertPhotoAlbum:name];
}

+ (BOOL)deletePhotoAlbum:(NSString *)name {
    return [[FMDBHelper sharedFMDBHelper] deletePhotoAlbum:name];
}

+ (BOOL)savePhoto:(MMPhoto *)photo {
    if (photo.photoId == nil) {//新增的photo
        return [[FMDBHelper sharedFMDBHelper] insertPhoto:photo photoAlbum:photo.toPhotoAlbum];
    }else if ([photo.photoAlbum isEqualToString:photo.toPhotoAlbum ] || photo.toPhotoAlbum == nil) {//修改photo，不改动photo的所属
        return [[FMDBHelper sharedFMDBHelper] modifyPhoto:photo photoAlbum:photo.photoAlbum];
    }else {//修改photo，并且改动其所属PhotoAlbum
        if ([[FMDBHelper sharedFMDBHelper] deletePhotoWithPhotoId:photo.photoId photoAlbum:photo.photoAlbum]) {
            return [[FMDBHelper sharedFMDBHelper] insertPhoto:photo photoAlbum:photo.toPhotoAlbum];
        }else return NO;
    }
}
+ (NSArray *)readAllPhotoAlbum {
    return [[FMDBHelper sharedFMDBHelper] readAllPhotoAlbum];
}
+ (NSArray *)readPhotoInPhotoAlbum:(NSString *)name {
    NSArray *array = [[FMDBHelper sharedFMDBHelper] readPhotoInPhotoAlbum:name];
    NSMutableArray *mutArray = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        MMPhoto *photo = [MMPhoto objectWithKeyValues:dic];
        photo.photoAlbum = name;
        [mutArray addObject:photo];
    }
    return [NSArray arrayWithArray:mutArray];
}
+ (NSArray *)readAllPhoto {
    NSArray *PhotoAlbumArray = [self readAllPhotoAlbum];
    NSMutableArray *mutArray = [NSMutableArray array];
    for (NSString *PhotoAlbumName in PhotoAlbumArray) {
        NSArray *photoArray = [self readPhotoInPhotoAlbum:PhotoAlbumName];
        [mutArray addObjectsFromArray:photoArray];
    }
    return [NSArray arrayWithArray:mutArray];
}

@end
