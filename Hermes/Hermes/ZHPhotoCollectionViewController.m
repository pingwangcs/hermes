//
//  ZHPhotoCollectionViewController.m
//  Hermes
//
//  Created by XuanXie on 1/28/15.
//  Copyright (c) 2015 XuanXie. All rights reserved.
//

#import "ZHModel.h"
#import "ZHModelConstants.h"
#import "ZHPhoto.h"
#import "ZHPhotoCollectionViewCell.h"
#import "ZHPhotoCollectionViewController.h"
#import "ZHPhotoDetailsViewController.h"
#import "ZHPhotoNetworkService.h"
#import "ZHUtility.h"

static NSString *CellIdentifier = @"ZHPhotoCollectionViewCell";
static NSUInteger BatchSize = 20;

@interface ZHPhotoCollectionViewController ()

@property (nonatomic, strong) ZHPhotoAlbum *photoAlbum;
@property NSMutableArray *sectionChanges;
@property NSMutableArray *itemChanges;

@end

@implementation ZHPhotoCollectionViewController

@synthesize managedObjectContext = _managedObjectContext;
@synthesize fetchedResultsController = _fetchedResultsController;

- (void)updateWithPhotoAlbum:(ZHPhotoAlbum *)photoAlbum {
    self.photoAlbum = photoAlbum;
    
    ZHPhotoNetworkService *photos = [[ZHPhotoNetworkService alloc] init];
    [photos getAllPhotosByPhotoAlbum:self.photoAlbum];
    [self setTitle:self.photoAlbum.title];
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
    NSEntityDescription *entity = [NSEntityDescription entityForName:entity_Photo
                                              inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entity];

    [NSFetchedResultsController deleteCacheWithName:@"PhotoCollection"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"photoAlbumGuid == %@", self.photoAlbum.guid];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setResultType:NSManagedObjectResultType];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"guid" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    [fetchRequest setFetchBatchSize:BatchSize];
    
    NSFetchedResultsController *aFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:[self managedObjectContext]
                                          sectionNameKeyPath:nil
                                                   cacheName:@"PhotoCollection"];
    
    self.fetchedResultsController = aFetchedResultsController;
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    [self.collectionView registerClass:[ZHPhotoCollectionViewCell class] forCellWithReuseIdentifier:CellIdentifier];
    
    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error]) {
        [ZHUtility logError:error];
        abort();
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ZHPhoto *photo = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    ZHPhotoDetailsViewController *detailsViewController = [[ZHPhotoDetailsViewController alloc] initWithPhoto:photo];
    [self.navigationController pushViewController:detailsViewController animated:true];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [[[self fetchedResultsController] sections] count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[[[self fetchedResultsController] sections] objectAtIndex:section] numberOfObjects];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZHPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[ZHPhotoCollectionViewCell alloc] init];
    }
    ZHPhoto *photo = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    [cell updateWithPhoto:photo];
    return cell;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    _sectionChanges = [[NSMutableArray alloc] init];
    _itemChanges = [[NSMutableArray alloc] init];
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type {
    NSMutableDictionary *change = [[NSMutableDictionary alloc] init];
    change[@(type)] = @(sectionIndex);
    [_sectionChanges addObject:change];
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    NSMutableDictionary *change = [[NSMutableDictionary alloc] init];
    switch(type) {
        case NSFetchedResultsChangeInsert:
            change[@(type)] = newIndexPath;
            break;
        case NSFetchedResultsChangeDelete:
            change[@(type)] = indexPath;
            break;
        case NSFetchedResultsChangeUpdate:
            change[@(type)] = indexPath;
            break;
        case NSFetchedResultsChangeMove:
            change[@(type)] = @[indexPath, newIndexPath];
            break;
    }
    [_itemChanges addObject:change];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.collectionView performBatchUpdates:^{
        for (NSDictionary *change in _sectionChanges) {
            [change enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                NSFetchedResultsChangeType type = [key unsignedIntegerValue];
                switch(type) {
                    case NSFetchedResultsChangeInsert:
                        [self.collectionView insertSections:[NSIndexSet indexSetWithIndex:[obj unsignedIntegerValue]]];
                        break;
                    case NSFetchedResultsChangeDelete:
                        [self.collectionView deleteSections:[NSIndexSet indexSetWithIndex:[obj unsignedIntegerValue]]];
                        break;
                    case NSFetchedResultsChangeUpdate:
                        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:[obj unsignedIntegerValue]]];
                        break;
                    case NSFetchedResultsChangeMove:
                        [self.collectionView deleteSections:[NSIndexSet indexSetWithIndex:[obj unsignedIntegerValue]]];
                        [self.collectionView insertSections:[NSIndexSet indexSetWithIndex:[obj unsignedIntegerValue]]];
                }
            }];
        }
        for (NSDictionary *change in _itemChanges) {
            [change enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                NSFetchedResultsChangeType type = [key unsignedIntegerValue];
                switch(type) {
                    case NSFetchedResultsChangeInsert:
                        [self.collectionView insertItemsAtIndexPaths:@[obj]];
                        break;
                    case NSFetchedResultsChangeDelete:
                        [self.collectionView deleteItemsAtIndexPaths:@[obj]];
                        break;
                    case NSFetchedResultsChangeUpdate:
                        [self.collectionView reloadItemsAtIndexPaths:@[obj]];
                        break;
                    case NSFetchedResultsChangeMove:
                        [self.collectionView moveItemAtIndexPath:obj[0] toIndexPath:obj[1]];
                        break;
                }
            }];
        }
    } completion:^(BOOL finished) {
        _sectionChanges = nil;
        _itemChanges = nil;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end