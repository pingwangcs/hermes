//
//  ZHPhoto.h
//  Hermes
//
//  Created by XuanXie on 2/4/15.
//  Copyright (c) 2015 XuanXie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ZHPhotoAlbum;

@interface ZHPhoto : NSManagedObject

@property (nonatomic, retain) NSString * guid;
@property (nonatomic, retain) NSString * thumbnailLarge;
@property (nonatomic, retain) NSString * thumbnailMaster;
@property (nonatomic, retain) NSString * thumbnailSmall;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * photoAlbumGuid;
@property (nonatomic, retain) ZHPhotoAlbum *photoAlbum;

@end
