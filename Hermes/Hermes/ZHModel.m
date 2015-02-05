//
//  ZHModel.m
//  Hermes
//
//  Created by XuanXie on 1/15/15.
//  Copyright (c) 2015 XuanXie. All rights reserved.
//

#import "ZHModel.h"
#import "ZHModelConstants.h"
#import "ZHUtility.h"

static ZHModel *sharedModel = nil;

@implementation ZHModel

@synthesize managedObjectModel = _managedObjectModel;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+ (id)sharedModel {
    @synchronized (self) {
        if (sharedModel == nil) {
            sharedModel = [[self alloc] init];
        }
    }
    return sharedModel;
}

- (id)init {
    self = [super init];
    return self;
}

- (NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }

    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel == nil) {
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Hermes" withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }

    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Hermes.sqlite"];
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];

    NSError *error = nil;
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                   configuration:nil
                                                             URL:storeURL
                                                         options:nil
                                                           error:&error]) {
        [ZHUtility logError:error];
        abort();
    }
    
    return _persistentStoreCoordinator;
}

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];

    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            [ZHUtility logError:error];
            abort();
        }
    }
}

- (ZHEvent *)getEventByGuid:(NSString *)guid {
    ZHEvent *event = nil;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entity_Event
                                              inManagedObjectContext:[self managedObjectContext]];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"guid == %@", guid];
    [request setPredicate:predicate];
    
    [request setResultType:NSManagedObjectResultType];
    
    NSArray *object = [[self managedObjectContext] executeFetchRequest:request error:nil];
    
    if ([object count] > 0) {
        event = (ZHEvent *)[object objectAtIndex:0];
    }
    
    return event;
}

- (ZHPhoto *)getPhotoByGuid:(NSString *)guid {
    ZHPhoto *photo = nil;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entity_Photo
                                              inManagedObjectContext:[self managedObjectContext]];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"guid == %@", guid];
    [request setPredicate:predicate];
    
    [request setResultType:NSManagedObjectResultType];
    
    NSArray *object = [[self managedObjectContext] executeFetchRequest:request error:nil];
    
    if ([object count] > 0) {
        photo = (ZHPhoto *)[object objectAtIndex:0];
    }
    
    return photo;
}

- (ZHPhotoAlbum *)getPhotoAlbumByGuid:(NSString *)guid {
    ZHPhotoAlbum *photoAlbum = nil;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entity_PhotoAlbum
                                              inManagedObjectContext:[self managedObjectContext]];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"guid == %@", guid];
    [request setPredicate:predicate];
    
    [request setResultType:NSManagedObjectResultType];
    
    NSArray *object = [[self managedObjectContext] executeFetchRequest:request error:nil];
    
    if ([object count] > 0) {
        photoAlbum = (ZHPhotoAlbum *)[object objectAtIndex:0];
    }
    
    return photoAlbum;
}

@end
