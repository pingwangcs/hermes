//
//  ZHPhotoAlbumNetworkService.m
//  Hermes
//
//  Created by XuanXie on 1/27/15.
//  Copyright (c) 2015 XuanXie. All rights reserved.
//

#import "ZHModel.h"
#import "ZHModelConstants.h"
#import "ZHPhotoAlbum.h"
#import "ZHPhotoAlbumNetworkService.h"
#import "ZHUtility.h"

static NSString *BaseURLString = @"http://51zhaohu.com/services/api/rest/json/";

@interface ZHPhotoAlbumNetworkService ()

@property (nonatomic, retain) NSManagedObjectContext *context;

@end

@implementation ZHPhotoAlbumNetworkService

@synthesize context = _context;

- (id)init {
    self = [super init];
    
    if (self) {
        _context = [[ZHModel sharedModel] managedObjectContext];
    }
    return self;
}

- (void)getAllPhotoAlbums {
    NSString *string = [ZHUtility encodeString:[NSString stringWithFormat:@"%@?method=album.list", BaseURLString]];
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *response = responseObject;
        NSDictionary *result = response[@"result"];
        NSDictionary *entities = result[@"entities"];
        
        for (NSDictionary *photoAlbum in entities) {
            [self parsePhotoAlbum:photoAlbum];
        }
        [[ZHModel sharedModel] saveContext];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [ZHUtility logError:error];
    }];
    
    [operation start];
}

- (void)parsePhotoAlbum:(NSDictionary *)dictionary {
    NSString *guid = (NSString *)dictionary[@"guid"];
    ZHPhotoAlbum *photoAlbum = [[ZHModel sharedModel] getPhotoAlbumByGuid:guid];
    
    if (photoAlbum == nil) {
        photoAlbum = (ZHPhotoAlbum *)[NSEntityDescription insertNewObjectForEntityForName:entity_PhotoAlbum
                                                                   inManagedObjectContext:_context];
        
        photoAlbum.cover = (NSString *)dictionary[@"cover"];
        photoAlbum.guid = [(NSNumber *)dictionary[@"guid"] stringValue];
        photoAlbum.title = (NSString *)dictionary[@"title"];
        photoAlbum.url = (NSString *)dictionary[@"url"];
    }
}

@end
