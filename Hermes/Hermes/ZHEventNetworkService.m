//
//  ZHEventNetworkService.m
//  Hermes
//
//  Created by XuanXie on 1/14/15.
//  Copyright (c) 2015 XuanXie. All rights reserved.
//

#import "ZHEvent.h"
#import "ZHEventNetworkService.h"
#import "ZHModel.h"
#import "ZHModelConstants.h"
#import "ZHUtility.h"

static NSString *BaseURLString = @"http://51zhaohu.com/services/api/rest/json/";

@interface ZHEventNetworkService ()

@property (nonatomic, retain) NSManagedObjectContext *context;

@end

@implementation ZHEventNetworkService

@synthesize context = _context;

- (id)init {
    self = [super init];
    
    if (self) {
        _context = [[ZHModel sharedModel] managedObjectContext];
    }
    return self;
}

- (void)getAllEvents {
    NSString *string = [ZHUtility encodeString:[NSString stringWithFormat:@"%@?method=event.search&keyword=全部兴趣", BaseURLString]];
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSDictionary *response = responseObject;
        NSDictionary *result = response[@"result"];
        NSDictionary *entities = result[@"entities"];
        
        for (NSDictionary *event in entities) {
            [self parseEvent:event withIsFeatured:NO];
        }
        [[ZHModel sharedModel] saveContext];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [ZHUtility logError:error];
    }];

    [operation start];
}

- (void)getAllFeaturedEvents {
    NSString *string = [ZHUtility encodeString:[NSString stringWithFormat:@"%@?method=event.search&featured=y", BaseURLString]];
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *response = responseObject;
        NSDictionary *result = response[@"result"];
        NSDictionary *entities = result[@"entities"];
        
        for (NSDictionary *event in entities) {
            [self parseEvent:event withIsFeatured:YES];
        }
        [[ZHModel sharedModel] saveContext];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [ZHUtility logError:error];
    }];
    
    [operation start];
}

- (void)parseEvent:(NSDictionary *)dictionary withIsFeatured:(Boolean)isFeatured {
    NSString *guid = (NSString *)dictionary[@"guid"];
    ZHEvent *event = [[ZHModel sharedModel] getEventByGuid:guid];
    
    if (event == nil) {
        event = (ZHEvent *)[NSEntityDescription insertNewObjectForEntityForName:entity_Event
                                                         inManagedObjectContext:_context];

        event.address = (NSString *)dictionary[@"address"];
        event.city = (NSString *)dictionary[@"city"];
        event.country = (NSString *)dictionary[@"country"];
        event.endTime = [ZHUtility getDateFromString:(NSString *)dictionary[@"end_date"]];
        event.fullAddress = (NSString *)dictionary[@"full_address"];
        event.groupName = (NSString *)dictionary[@"group_name"];
        event.groupUrl = (NSString *)dictionary[@"group_url"];
        event.guid = [(NSNumber *)dictionary[@"guid"] stringValue];
        event.iconUrlLarge = (NSString *)dictionary[@"icon_url_large"];
        event.iconUrlMedium = (NSString *)dictionary[@"icon_url_medium"];
        event.iconUrlSmall = (NSString *)dictionary[@"icon_url_small"];
        event.ownerName = (NSString *)dictionary[@"owner_name"];
        event.ownerUrl = (NSString *)dictionary[@"owner_url"];
        event.startTime = [ZHUtility getDateFromString:(NSString *)dictionary[@"start_date"]];
        event.state = (NSString *)dictionary[@"state"];
        event.title = (NSString *)dictionary[@"title"];
        event.url = (NSString *)dictionary[@"url"];
        event.zip = (NSString *)dictionary[@"zip"];
    }
    
    if (event != nil) {
        event.isFeatured = [NSNumber numberWithBool:isFeatured];
    }
}

@end
