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

+ (NSDateFormatter *)dateFormatter
{
    if (aDateFormatter == nil)
    {
        aDateFormatter = [[NSDateFormatter alloc] init];
        [aDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    }

    return aDateFormatter;
}

+ (NSDate *)getDateFromString:(NSString *)string
{
    NSDate *date = [[ZHUtility dateFormatter] dateFromString:string];

    return date;
}

@end

