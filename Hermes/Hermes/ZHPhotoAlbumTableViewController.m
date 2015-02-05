//
//  ZHPhotoAlbumCollectionViewController.m
//  Hermes
//
//  Created by XuanXie on 1/27/15.
//  Copyright (c) 2015 XuanXie. All rights reserved.
//

#import "ZHModel.h"
#import "ZHModelConstants.h"
#import "ZHPhotoAlbum.h"
#import "ZHPhotoAlbumTableViewCell.h"
#import "ZHPhotoAlbumTableViewController.h"
#import "ZHPhotoAlbumNetworkService.h"
#import "ZHPhotoCollectionViewController.h"
#import "ZHPhotoCollectionViewLayout.h"
#import "ZHUtility.h"

static NSString *CellIdentifier = @"ZHPhotoAlbumTableViewCell";
static NSUInteger BatchSize = 20;
static CGFloat TableCellHeight = 110.0f;

@interface ZHPhotoAlbumTableViewController ()

@end

@implementation ZHPhotoAlbumTableViewController

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
    ZHPhotoAlbumNetworkService *photoAlbums = [[ZHPhotoAlbumNetworkService alloc] init];
    [photoAlbums getAllPhotoAlbums];
    [self setTitle:@"照片墙"];
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
    NSEntityDescription *entity = [NSEntityDescription entityForName:entity_PhotoAlbum
                                              inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"guid" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    [fetchRequest setFetchBatchSize:BatchSize];
    
    NSFetchedResultsController *aFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:[self managedObjectContext]
                                          sectionNameKeyPath:nil
                                                   cacheName:@"PhotoWall"];
    
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
    
    [self.tableView registerClass:[ZHPhotoAlbumTableViewCell class] forCellReuseIdentifier:[self getCellIdentifier]];
    
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
    ZHPhotoAlbum *photoAlbum = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    ZHPhotoCollectionViewLayout *photoCollectionViewLayout = [[ZHPhotoCollectionViewLayout alloc] init];
    ZHPhotoCollectionViewController *photoCollectionViewController = [[ZHPhotoCollectionViewController alloc] initWithCollectionViewLayout:photoCollectionViewLayout];
    [photoCollectionViewController updateWithPhotoAlbum:photoAlbum];
    [self.navigationController pushViewController:photoCollectionViewController animated:true];
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
    ZHPhotoAlbumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ZHPhotoAlbumTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[self getCellIdentifier]];
    }
    ZHPhotoAlbum *photoAlbum = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    [cell updateWithPhotoAlbum:photoAlbum];
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