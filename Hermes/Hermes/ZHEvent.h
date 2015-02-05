//
//  ZHEvent.h
//  Hermes
//
//  Created by XuanXie on 2/4/15.
//  Copyright (c) 2015 XuanXie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ZHEvent : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSDate * endTime;
@property (nonatomic, retain) NSString * fullAddress;
@property (nonatomic, retain) NSString * groupName;
@property (nonatomic, retain) NSString * groupUrl;
@property (nonatomic, retain) NSString * guid;
@property (nonatomic, retain) NSString * iconUrlLarge;
@property (nonatomic, retain) NSString * iconUrlMedium;
@property (nonatomic, retain) NSString * iconUrlSmall;
@property (nonatomic, retain) NSNumber * isFeatured;
@property (nonatomic, retain) NSString * ownerName;
@property (nonatomic, retain) NSString * ownerUrl;
@property (nonatomic, retain) NSDate * startTime;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * zip;

@end
