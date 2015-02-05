//
//  ZHModel.h
//  Hermes
//
//  Created by XuanXie on 1/15/15.
//  Copyright (c) 2015 XuanXie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ZHEvent;
@class ZHPhoto;
@class ZHPhotoAlbum;

@interface ZHModel : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (id)sharedModel;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

- (ZHEvent *)getEventByGuid:(NSString *)guid;
- (ZHPhoto *)getPhotoByGuid:(NSString *)guid;
- (ZHPhotoAlbum *)getPhotoAlbumByGuid:(NSString *)guid;

@end
