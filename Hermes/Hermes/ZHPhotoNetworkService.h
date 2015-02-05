//
//  ZHPhotoNetworkService.h
//  Hermes
//
//  Created by XuanXie on 1/28/15.
//  Copyright (c) 2015 XuanXie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "ZHPhotoAlbum.h"

@interface ZHPhotoNetworkService : NSObject

- (void)getAllPhotosByPhotoAlbum:(ZHPhotoAlbum *)photoAlbum;

@end