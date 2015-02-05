//
//  ZHUtility.h
//  Hermes
//
//  Created by XuanXie on 1/19/15.
//  Copyright (c) 2015 XuanXie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZHUtility : NSObject

+ (NSDate *)getDateFromString:(NSString *)string;
+ (NSString *)getStringFromDate:(NSDate *)date;

+ (NSString *)encodeString:(NSString *)string;
+ (NSString *)decodeString:(NSString *)string;

+ (void)logError:(NSError *)error;

@end
