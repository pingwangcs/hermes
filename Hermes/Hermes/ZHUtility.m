//
//  ZHUtility.m
//  Hermes
//
//  Created by XuanXie on 1/19/15.
//  Copyright (c) 2015 XuanXie. All rights reserved.
//

#import "ZHUtility.h"

static NSDateFormatter *aDateFormatter = nil;

@implementation ZHUtility

+ (NSDateFormatter *)dateFormatter {    
    if (aDateFormatter == nil) {
        aDateFormatter = [[NSDateFormatter alloc] init];
        [aDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    }

    return aDateFormatter;
}

+ (NSDate *)getDateFromString:(NSString *)string {
    return [[ZHUtility dateFormatter] dateFromString:string];
}

+ (NSString *)getStringFromDate:(NSDate *)date {
    return [[ZHUtility dateFormatter] stringFromDate:date];
}

+ (NSString *)encodeString:(NSString *)string {
    return [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

+ (NSString *)decodeString:(NSString *)string {
    return [string stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

+ (void)logError:(NSError *)error {
    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
}

@end

