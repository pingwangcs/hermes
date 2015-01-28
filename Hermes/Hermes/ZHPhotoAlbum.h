//
//  ZHPhotoAlbum.h
//  Hermes
//
//  Created by XuanXie on 1/27/15.
//  Copyright (c) 2015 XuanXie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ZHPhotoAlbum : NSManagedObject

@property (nonatomic, retain) NSString * guid;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * cover;

@end
