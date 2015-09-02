//
//  MYDDBManager.h
//  MemoOC
//
//  Created by dfy on 15/1/9.
//  Copyright (c) 2015年 childrenAreOurFuture. All rights reserved.
//
//在LoginResult表中存一个dataVersion，自建一个单独的dataVersion来存本地数据对应的版本号，每次登录或者取dataVersion就更新LoginResult中的dataVersion，然后根据两个dataVersion是否一致来决定是否需要更新数据

/*
    表结构：
    对一个品类有两个表：
    以Note为例：
    表一：notebook信息表
    结构：id, name
    表二：note信息表
    结构：id, name, topic...
    表三：note与notebook关系表
    结构：noteid notebookid
 */
#import <Foundation/Foundation.h>
#import "Singleton.h"
@class MMNotebook;
@class MMNote;
@class MMPhoto;
@class MMPhotoAlbum;
@interface FMDBHelper : NSObject
single_interface(FMDBHelper);
#pragma mark - Note
- (BOOL)insertNotebook:(NSString *)notebookName;
- (BOOL)renameNotebook:(NSString *)oldName newName:(NSString *)newName;
- (BOOL)deleteNotebook:(NSString *)notebookName;
- (BOOL)insertNote:(MMNote *)note notebook:(NSString *)notebookName;
- (BOOL)modifyNote:(MMNote *)note notebook:(NSString *)notebookName;
- (BOOL)deleteNoteWithNoteId:(NSNumber *)noteId notebook:(NSString *)notebookName;
- (NSArray *)readAllNotebook;
- (NSArray *)readNoteInNotebook:(NSString *)name;
//- (NSArray *)readNoteWithNoteId:(int)noteId;

#pragma mark - Photo
- (BOOL)insertPhotoAlbum:(NSString *)photoAlbumName;
- (BOOL)renamePhotoAlbum:(NSString *)oldName newName:(NSString *)newName;
- (BOOL)deletePhotoAlbum:(NSString *)photoAlbumName;
- (BOOL)insertPhoto:(MMPhoto *)note photoAlbum:(NSString *)photoAlbumName;
- (BOOL)modifyPhoto:(MMPhoto *)note photoAlbum:(NSString *)photoAlbumName;
- (BOOL)deletePhotoWithPhotoId:(NSNumber *)photoId photoAlbum:(NSString *)photoAlbumName;
- (NSArray *)readAllPhotoAlbum;
- (NSArray *)readPhotoInPhotoAlbum:(NSString *)name;
/*
//登录
- (void)saveLoginResultWithDataVersion:(int)dataVersion DepartmentId:(NSString *)departmentId;
//查dataVersion
- (void)saveDataVersionWithDataVersion:(int)dataVersion;
//查baseData
////存LoginUser
- (void)saveLoginUserWithDic:(NSMutableDictionary *)dic keyArrayForDic:(NSArray *)keyArray;
////存MaterialCatalogEntity
- (void)saveMaterialCatalogsWithDicArray:(NSMutableArray *)dicArray keyArrayForDic:(NSArray *)keyArray;
////存MaterialEntity
- (void)saveMaterialsWithDicArray:(NSMutableArray *)dicArray keyArrayForDic:(NSArray *)keyArray;
////存PictureEntity
- (void)saveMaterialPicturesWithDicArray:(NSMutableArray *)dicArray keyArrayForDic:(NSArray *)keyArray;
////存PlanCatalogEntity
- (void)savePlanCatalogsWithDicArray:(NSMutableArray *)dicArray keyArrayForDic:(NSArray *)keyArray;
////存PlanEntity
- (void)savePlansWithDicArray:(NSMutableArray *)dicArray keyArrayForDic:(NSArray *)keyArray;
////存PictureEntity
- (void)savePlanPicturesWithDicArray:(NSMutableArray *)dicArray keyArrayForDic:(NSArray *)keyArray;
////存PictureEntity
- (void)saveScrollPicturesWithDicArray:(NSMutableArray *)dicArray keyArrayForDic:(NSArray *)keyArray;
////存PartyEntity
- (void)savePartiesWithDicArray:(NSMutableArray *)dicArray keyArrayForDic:(NSArray *)keyArray;
////存IntroductionCatalogEntity
- (void)saveIntroductionCatalogsWithDicArray:(NSMutableArray *)dicArray keyArrayForDic:(NSArray *)keyArray;
////存IntroductionEntity
- (void)saveIntroductionsWithDicArray:(NSMutableArray *)dicArray keyArrayForDic:(NSArray *)keyArray;
////存WritingCatalogEntity
- (void)saveWritingCatalogsWithDicArray:(NSMutableArray *)dicArray keyArrayForDic:(NSArray *)keyArray;
////存WritingEntity
- (void)saveWritingsWithDicArray:(NSMutableArray *)dicArray keyArrayForDic:(NSArray *)keyArray;
////存PictureEntity
- (void)saveWritingPicturesWithDicArray:(NSMutableArray *)dicArray keyArrayForDic:(NSArray *)keyArray;
////存AnnouncementEntity
- (void)saveAnnouncementsWithDicArray:(NSMutableArray *)dicArray keyArrayForDic:(NSArray *)keyArray;
////存ProjectCatalogEntity
- (void)saveProjectCatalogsWithDicArray:(NSMutableArray *)dicArray keyArrayForDic:(NSArray *)keyArray;
////存ProjectEntity
- (void)saveProjectsWithDicArray:(NSMutableArray *)dicArray keyArrayForDic:(NSArray *)keyArray;
////存ProjectPictureEntity
- (void)saveProjectPicturesWithDicArray:(NSMutableArray *)dicArray keyArrayForDic:(NSArray *)keyArray;
////存baseData中的DataVersion
- (void)saveDataVersionWithDicArray:(NSMutableArray *)dicArray keyArrayForDic:(NSArray *)keyArray;
////存TeamEntity
- (void)saveTeamsWithDicArray:(NSMutableArray *)dicArray keyArrayForDic:(NSArray *)keyArray;
////存TeamPictureEntity
- (void)saveTeamPicturesWithDicArray:(NSMutableArray *)dicArray keyArrayForDic:(NSArray *)keyArray;

//下载Picture
//读数据库数据
- (int)readDataVersionFromLoginResult;
- (NSMutableArray *)readLoginUser;
- (NSMutableArray *)readMaterialCatalogs;
- (NSMutableArray *)readMaterials;
- (NSMutableArray *)readMaterialPictures;
- (NSMutableArray *)readPlanCatalogs;
- (NSMutableArray *)readPlans;
- (NSMutableArray *)readPlanPictures;
- (NSMutableArray *)readScrollPictures;
- (NSMutableArray *)readParties;
- (NSMutableArray *)readIntroductionCatalogs;
- (NSMutableArray *)readIntroductions;
- (NSMutableArray *)readWritingCatalogs;
- (NSMutableArray *)readWritings;
- (NSMutableArray *)readWritingPictures;
- (NSMutableArray *)readAnnouncements;
- (NSMutableArray *)readProjectCatalogs;
- (NSMutableArray *)readProjects;
- (NSMutableArray *)readProjectPictures;
- (NSMutableArray *)readTeams;
- (NSMutableArray *)readTeamPictures;
- (int)readDataVersionFromBaseData;//baseData表中的DataVersion
 */
@end
