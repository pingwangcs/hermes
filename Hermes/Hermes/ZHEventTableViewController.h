//
//  ZHEventTableViewController.h
//  Hermes
//
//  Created by XuanXie on 1/14/15.
//  Copyright (c) 2015 XuanXie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>


@interface ZHEventTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@end

