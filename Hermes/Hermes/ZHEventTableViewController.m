//
//  ZHEventTableViewController.m
//  Hermes
//
//  Created by XuanXie on 1/14/15.
//  Copyright (c) 2015 XuanXie. All rights reserved.
//

#import "ZHEvent.h"
#import "ZHEventDetailsViewController.h"
#import "ZHEventNetworkService.h"
#import "ZHEventTableViewCell.h"
#import "ZHEventTableViewController.h"
#import "ZHModel.h"
#import "ZHModelConstants.h"
#import "ZHUtility.h"

static NSString *CellIdentifier = @"ZHEventTableViewCell";
static NSUInteger BatchSize = 20;
static CGFloat TableCellHeight = 70.0f;

@interface ZHEventTableViewController ()

@end

@implementation ZHEventTableViewController

@synthesize managedObjectContext = _managedObjectContext;
@synthesize fetchedResultsController = _fetchedResultsController;

- (id)initWithCoder:(NSCoder*)coder {
    self = [super initWithCoder:coder];
    
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    ZHEventNetworkService *events = [[ZHEventNetworkService alloc] init];
    [events getAllEvents];
    [self setTitle:@"主页"];
}

- (NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext == nil) {
        _managedObjectContext = [[ZHModel sharedModel] managedObjectContext];
    }
    return _managedObjectContext;
}

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entity_Event
                                              inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"endTime" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    [fetchRequest setFetchBatchSize:BatchSize];
    
    NSFetchedResultsController *aFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:[self managedObjectContext]
                                          sectionNameKeyPath:nil
                                                   cacheName:@"Home"];
    
    self.fetchedResultsController = aFetchedResultsController;
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}

- (NSString *)getCellIdentifier {
    return CellIdentifier;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.tableView registerClass:[ZHEventTableViewCell class] forCellReuseIdentifier:[self getCellIdentifier]];
    
    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error]) {
        [ZHUtility logError:error];
        abort();
    }
}

- (void)viewDidUnload {
    self.fetchedResultsController = nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZHEvent *event = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    ZHEventDetailsViewController *detailsViewController = [[ZHEventDetailsViewController alloc] initWithEvent:event];
    [self.navigationController pushViewController:detailsViewController animated:true];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return TableCellHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[[self fetchedResultsController] sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[[self fetchedResultsController] sections] objectAtIndex:section] numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZHEventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ZHEventTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[self getCellIdentifier]];
    }
    ZHEvent *event = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    [cell updateWithEvent:event];
    return cell;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
