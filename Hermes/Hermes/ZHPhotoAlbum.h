//
//  ZHPhotoAlbum.h
//  Hermes
//
//  Created by XuanXie on 2/4/15.
//  Copyright (c) 2015 XuanXie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ZHPhoto;

@interface ZHPhotoAlbum : NSManagedObject

@property (nonatomic, retain) NSString * cover;
@property (nonatomic, retain) NSString * guid;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSSet *photoCollection;
@end

@interface ZHPhotoAlbum (CoreDataGeneratedAccessors)

- (void)addPhotoCollectionObject:(ZHPhoto *)value;
- (void)removePhotoCollectionObject:(ZHPhoto *)value;
- (void)addPhotoCollection:(NSSet *)values;
- (void)removePhotoCollection:(NSSet *)values;

@end
