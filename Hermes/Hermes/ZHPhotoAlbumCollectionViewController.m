//
//  ZHPhotoAlbumCollectionViewController.m
//  Hermes
//
//  Created by XuanXie on 1/27/15.
//  Copyright (c) 2015 XuanXie. All rights reserved.
//

#import "ZHPhotoAlbumCollectionViewController.h"
#import "ZHPhotoAlbum.h"
#import "ZHModel.h"
#import "ZHModelConstants.h"
#import "ZHPhotoAlbumNetworkService.h"
#import "ZHPhotoAlbumCollectionViewCell.h"


static NSString *CellIdentifier = @"ZHPhotoAlbumCollectionViewCell";
static NSUInteger BatchSize = 20;

@interface ZHPhotoAlbumCollectionViewController ()

@end


@implementation ZHPhotoAlbumCollectionViewController

@synthesize managedObjectContext = _managedObjectContext;
@synthesize fetchedResultsController = _fetchedResultsController;

- (id)initWithCoder:(NSCoder*)coder
{
    self = [super initWithCoder:coder];
    
    if (self)
    {
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    ZHPhotoAlbumNetworkService *photoAlbums = [[ZHPhotoAlbumNetworkService alloc] init];
    [photoAlbums getAllPhotoAlbums];
    [self setTitle:@"照片墙"];
}

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext == nil)
    {
        _managedObjectContext = [[ZHModel sharedModel] managedObjectContext];
    }
    
    return _managedObjectContext;
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil)
    {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:entity_PhotoAlbum
                                   inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                              initWithKey:@"guid" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    [fetchRequest setFetchBatchSize:BatchSize];
    
    NSFetchedResultsController *aFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:[self managedObjectContext]
                                          sectionNameKeyPath:nil
                                                   cacheName:@"Root"];
    
    self.fetchedResultsController = aFetchedResultsController;
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    [self.collectionView registerClass:[ZHPhotoAlbumCollectionViewCell class] forCellWithReuseIdentifier:CellIdentifier];
    
    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [[_fetchedResultsController sections] count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[[_fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZHPhotoAlbumCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil)
    {
        cell = [[ZHPhotoAlbumCollectionViewCell alloc] init];
    }
    
    ZHPhotoAlbum *photAlbum = [_fetchedResultsController objectAtIndexPath:indexPath];
    [cell updateWithPhotoAlbum:photAlbum];
    
    return cell;
}

@end