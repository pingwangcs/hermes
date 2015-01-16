//
//  HomePageViewController.m
//  Hermes
//
//  Created by XuanXie on 1/14/15.
//  Copyright (c) 2015 XuanXie. All rights reserved.
//

#import "HomePageViewController.h"
#import "ZHEvent.h"
#import "ZHModel.h"
#import "ZHModelConstants.h"
#import "ZHEventNetworkService.h"

@interface HomePageViewController ()

@end

@implementation HomePageViewController

@synthesize managedObjectContext = _managedObjectContext;
@synthesize allEvents = _allEvents;

- (id)init
{
    self = [super init];

    return self;
}

- (void)setup
{
    NSLog(@"start");
    ZHEventNetworkService *events = [[ZHEventNetworkService alloc] init];
    [events getAllEvents];
    NSLog(@"end");
}

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext == nil)
    {
        _managedObjectContext = [[ZHModel sharedModel] managedObjectContext];
    }
    
    return _managedObjectContext;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:entity_Event
                                   inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entity];
    NSError *error;
    self.allEvents = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.allEvents count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] init];
    }
    // Set up the cell...
    ZHEvent *event = [self.allEvents objectAtIndex:indexPath.row];
    cell.textLabel.text = event.title;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@", event.city, event.state];
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
