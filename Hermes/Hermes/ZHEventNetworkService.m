//
//  ZHEventNetworkService.m
//  Hermes
//
//  Created by XuanXie on 1/14/15.
//  Copyright (c) 2015 XuanXie. All rights reserved.
//

#import "ZHEventNetworkService.h"

NSString * const BaseURLString = @"http://51zhaohu.com/services/api/rest/json/";

@interface ZHEventNetworkService ()

@end


@implementation ZHEventNetworkService

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
            NSString *title = event[@"title"];
            NSLog(@"title: %@", title);
            
            NSInteger offset = [[NSTimeZone defaultTimeZone] secondsFromGMT];
            NSString *start = event[@"start_ts"];
            NSTimeInterval timeInterval = start.doubleValue;
            NSDate* date = [[NSDate dateWithTimeIntervalSince1970:timeInterval] dateByAddingTimeInterval:offset];
            NSLog(@"start time: %@", date);
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failed");
    }];

    [operation start];
}

@end
