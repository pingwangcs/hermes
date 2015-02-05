//
//  ZHFeatureEventTableViewController.m
//  Hermes
//
//  Created by XuanXie on 2/2/15.
//  Copyright (c) 2015 XuanXie. All rights reserved.
//

#import "ZHEvent.h"
#import "ZHEventNetworkService.h"
#import "ZHFeatureEventTableViewController.h"
#import "ZHModel.h"
#import "ZHModelConstants.h"
#import "ZHUtility.h"

static NSString *CellIdentifier = @"ZHFeatureEventTableViewCell";
static NSUInteger BatchSize = 20;

@interface ZHEventTableViewController ()

@end

@implementation ZHFeatureEventTableViewController

@synthesize fetchedResultsController = _fetchedResultsController;

- (void)setup {
    ZHEventNetworkService *events = [[ZHEventNetworkService alloc] init];
    [events getAllFeaturedEvents];
    [self setTitle:@"推荐"];
}

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entity_Event
                                              inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isFeatured == %@", [NSNumber numberWithBool:YES]];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"endTime" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    [fetchRequest setFetchBatchSize:BatchSize];
    
    NSFetchedResultsController *aFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:[self managedObjectContext]
                                          sectionNameKeyPath:nil
                                                   cacheName:@"Feature"];
    
    self.fetchedResultsController = aFetchedResultsController;
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}

@end