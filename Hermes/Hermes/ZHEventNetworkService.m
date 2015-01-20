//
//  ZHEventNetworkService.m
//  Hermes
//
//  Created by XuanXie on 1/14/15.
//  Copyright (c) 2015 XuanXie. All rights reserved.
//

#import "ZHEventNetworkService.h"
#import "ZHEvent.h"
#import "ZHModel.h"
#import "ZHModelConstants.h"
#import "ZHUtility.h"

NSString * const BaseURLString = @"http://51zhaohu.com/services/api/rest/json/";

@interface ZHEventNetworkService ()

@property (nonatomic, retain) NSManagedObjectContext *context;

@end


@implementation ZHEventNetworkService

@synthesize context = _context;

- (id)init
{
    self = [super init];
    
    if (self)
    {
        _context = [[ZHModel sharedModel] managedObjectContext];
    }
    
    return self;
}

- (void) getAllEvents
{
    NSString *string = [NSString stringWithFormat:@"%@?method=event.search&keyword=全部兴趣", BaseURLString];
    NSURL *url = [NSURL URLWithString:[string stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"Success");
        NSLog(@"%@", responseObject);
        
        NSDictionary *response = responseObject;
        
        NSDictionary *result = response[@"result"];
        NSLog(@"Count: %lu", [result count]);

        NSString *status = response[@"status"];
        NSLog(@"Status: %@", status);

        for (NSDictionary *event in result)
        {
            [self parseEvent:event];
        }
        [[ZHModel sharedModel] saveContext];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failed");
    }];

    [operation start];
}

- (void) parseEvent:(NSDictionary *)dictionary
{
    NSString *guid = (NSString *)dictionary[@"guid"];

    ZHEvent *event = [[ZHModel sharedModel] getEventByGuid:guid];
    
    if (event == nil)
    {
        event = (ZHEvent *)[NSEntityDescription insertNewObjectForEntityForName:entity_Event
                                                         inManagedObjectContext:_context];

        event.address = (NSString *)dictionary[@"address"];
        event.city = (NSString *)dictionary[@"city"];
        event.country = (NSString *)dictionary[@"country"];
        event.endTime = [ZHUtility getDateFromString:(NSString *)dictionary[@"end_date"]];
        event.groupName = (NSString *)dictionary[@"group_name"];
        event.groupUrl = (NSString *)dictionary[@"group_url"];
        event.guid = [(NSNumber *)dictionary[@"guid"] stringValue];
        event.ownerName = (NSString *)dictionary[@"owner_name"];
        event.ownerUrl = (NSString *)dictionary[@"owner_url"];
        event.startTime = [ZHUtility getDateFromString:(NSString *)dictionary[@"start_date"]];
        event.state = (NSString *)dictionary[@"state"];
        event.title = (NSString *)dictionary[@"title"];
        event.zip = (NSString *)dictionary[@"zip"];
    }
}

@end
