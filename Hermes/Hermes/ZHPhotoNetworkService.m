//
//  ZHPhotoNetworkService.m
//  Hermes
//
//  Created by XuanXie on 1/28/15.
//  Copyright (c) 2015 XuanXie. All rights reserved.
//

#import "ZHModel.h"
#import "ZHModelConstants.h"
#import "ZHPhoto.h"
#import "ZHPhotoAlbum.h"
#import "ZHPhotoNetworkService.h"
#import "ZHUtility.h"

static NSString *BaseURLString = @"http://51zhaohu.com/services/api/rest/json/";

@interface ZHPhotoNetworkService ()

@property (nonatomic, retain) NSManagedObjectContext *context;

@end

@implementation ZHPhotoNetworkService

@synthesize context = _context;

- (id)init {
    self = [super init];
    
    if (self) {
        _context = [[ZHModel sharedModel] managedObjectContext];
    }
    return self;
}

- (void)getAllPhotosByPhotoAlbum:(ZHPhotoAlbum *)photoAlbum {
    NSString *string = [ZHUtility encodeString:[NSString stringWithFormat:@"%@?method=photo.list&album_guid=%@", BaseURLString, photoAlbum.guid]];
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *response = responseObject;
        NSDictionary *result = response[@"result"];
        NSDictionary *entities = result[@"entities"];
        
        NSLog(@"%@", responseObject);
        
        for (NSDictionary *photo in entities) {
            [self parsePhoto:photo withPhotoAlbum:photoAlbum];
        }
        [[ZHModel sharedModel] saveContext];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [ZHUtility logError:error];
    }];
    
    [operation start];
}

- (void)parsePhoto:(NSDictionary *)dictionary withPhotoAlbum:(ZHPhotoAlbum *)photoAlbum{
    NSString *guid = (NSString *)dictionary[@"guid"];
    ZHPhoto *photo = [[ZHModel sharedModel] getPhotoByGuid:guid];
    
    if (photo == nil) {
        photo = (ZHPhoto *)[NSEntityDescription insertNewObjectForEntityForName:entity_Photo
                                                         inManagedObjectContext:_context];
        
        photo.guid = [(NSNumber *)dictionary[@"guid"] stringValue];
        photo.photoAlbumGuid = (NSString *)dictionary[@"album_guid"];
        photo.thumbnailLarge = (NSString *)dictionary[@"thumbnail_large"];
        photo.thumbnailMaster = (NSString *)dictionary[@"thumbnail_master"];
        photo.thumbnailSmall = (NSString *)dictionary[@"thumbnail_small"];
        photo.title = (NSString *)dictionary[@"title"];
        photo.url = (NSString *)dictionary[@"url"];
        
        photo.photoAlbum = photoAlbum;
        [photoAlbum addPhotoCollectionObject:photo];
    }
}

@end

