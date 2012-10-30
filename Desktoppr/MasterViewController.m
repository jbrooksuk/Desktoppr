//
//  MasterViewController.m
//  Desktoppr
//
//  Created by James Brooks on 28/10/2012
//  Copyright (c) 2012 James Brooks. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "WallpaperCell.h"
#import "SBJson.h"
#include <stdlib.h>

#define DISPATCH_QUEUE_PRIORITY_HIGH        2
// #define DISPATCH_QUEUE_PRIORITY_LOW         -2

static NSString *CellIdentifier = @"WallpaperCell";

@implementation MasterViewController {
    NSMutableArray *_objectChanges;
    NSMutableArray *_sectionChanges;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

//-(void)viewDidAppear:(BOOL)animated
//{
//     [self becomeFirstResponder];
//}
//
//-(void)viewDidDisappear:(BOOL)animated
//{
//     [self becomeFirstResponder];
//}
//
//- (BOOL)canBecomeFirstResponder {
//    return YES;
//}
//
//// On shake, load 20 random images.
//-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
//{
//    if(motion == UIEventSubtypeMotionShake) {
//        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 0)];
//        [self.collectionView deleteSections:indexSet];
//        [self deleteAllObjects:@"Wallpaper"];
//        
//        // Load 20 random wallpapers
//        for(int n = 1; n <= 20; n = n + 1)
//            NSLog(@"Loading random wallpaper %i", n);
//    }
//}

// Used to change the colour of things.
- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:18.0/255 green:44.0/255 blue:69.0/255 alpha:1];
    [[UINavigationBar appearance] setBackgroundColor:[UIColor colorWithRed:18.0/255 green:44.0/255 blue:69.0/255 alpha:1]];
}

- (void)viewDidLoad
{    
    self.title = @"On Desktoppr";
    [self loadDesktopprItems];
    [super viewDidLoad];
}

- (IBAction)refreshItems:(id)sender
{
    // Attempt to delete all sections
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 0)];
    [self.collectionView deleteSections:indexSet];
    
    [self loadDesktopprItems];
}

-(void)loadDesktopprItems {
    [self deleteAllObjects:@"Wallpaper"];
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
    
    HUD.labelText = @"Loading items";
    
    [HUD showWhileExecuting:@selector(loadDesktopprItemsSel) onTarget:self withObject:NULL animated:YES];
}

- (void)loadDesktopprItemsSel {
    _objectChanges = [NSMutableArray array];
    _sectionChanges = [NSMutableArray array];
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    
    int r = arc4random() % 74;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.desktoppr.co/1/wallpapers?page=%i", r]]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    NSDictionary *wallpaperObject = [parser objectWithString:json_string error:nil];
    
    for (NSDictionary *wallpaper in [wallpaperObject objectForKey:@"response"]) {
        NSLog(@"Loading random wallpaper.");
        NSManagedObject *wallpaperModel = [NSEntityDescription insertNewObjectForEntityForName:@"Wallpaper" inManagedObjectContext:AppDelegate.managedObjectContext];
        
        // Get the palette data as original JSON string
        [wallpaperModel setValue:[[wallpaper objectForKey:@"palette"] JSONRepresentation] forKey:@"wallpaperPalette"];
        
        // Image "meta"
        [wallpaperModel setValue:[[wallpaper objectForKey:@"image"] objectForKey:@"url"] forKey:@"wallpaperURL"];
        [wallpaperModel setValue:[wallpaper objectForKey:@"views_count"] forKey:@"wallpaperViews"];
        [wallpaperModel setValue:[wallpaper objectForKey:@"user_count"] forKey:@"wallpaperUsers"];
        [wallpaperModel setValue:[wallpaper objectForKey:@"id"] forKey:@"wallpaperID"];
        
        // Store the image sizes
        [wallpaperModel setValue:[[wallpaper objectForKey:@"image"] objectForKey:@"width"] forKey:@"wallpaperImageWidth"];
        [wallpaperModel setValue:[[wallpaper objectForKey:@"image"] objectForKey:@"height"] forKey:@"wallpaperImageHeight"];
        
        dispatch_queue_t imageQueue = dispatch_queue_create("imageProcess", NULL);
        dispatch_async(imageQueue, ^{
            // Get the full image
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                NSString *urlString = [[wallpaper valueForKey:@"image"] valueForKey:@"url"];
                NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
                [wallpaperModel setValue:imageData forKey:@"wallpaperImageData"];
            });
            
            // Get the thumbnail
            NSString *urlString = [[[wallpaper valueForKey:@"image"] objectForKey:@"thumb"] valueForKey:@"url"];
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [wallpaperModel setValue:imageData forKey:@"wallpaperThumbData"];
            });
        });
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WallpaperCell *cell = (WallpaperCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [cell setImage:[UIImage imageWithData:[object valueForKey:@"wallpaperThumbData"]]];
    [cell setViews:[object valueForKey:@"wallpaperViews"]];
    [cell setSyncs:[object valueForKey:@"wallpaperUsers"]];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    NSLog(@"Deciding segue. Current: %@", [segue identifier]);
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [[self.collectionView indexPathsForSelectedItems] lastObject];
        NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        [[segue destinationViewController] setDetailItem:object];
    }
}

- (void) deleteAllObjects: (NSString *) entityDescription  {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityDescription inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *items = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    for (NSManagedObject *managedObject in items) {
    	[_managedObjectContext deleteObject:managedObject];
    	NSLog(@"%@ Object deleted",entityDescription);
    }
    if (![_managedObjectContext save:&error]) {
    	NSLog(@"Error deleting %@ - error:%@",entityDescription,error);
    }
    
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Wallpaper" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setFetchBatchSize:20];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"wallpaperURL" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    
    NSMutableDictionary *change = [NSMutableDictionary new];
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            change[@(type)] = @(sectionIndex);
            break;
        case NSFetchedResultsChangeDelete:
            change[@(type)] = @(sectionIndex);
            break;
    }
    
    [_sectionChanges addObject:change];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    
    NSMutableDictionary *change = [NSMutableDictionary new];
    switch(type)
    {
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
    [_objectChanges addObject:change];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    if ([_sectionChanges count] > 0)
    {
        [self.collectionView performBatchUpdates:^{
            
            for (NSDictionary *change in _sectionChanges)
            {
                [change enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, id obj, BOOL *stop) {
                    
                    NSFetchedResultsChangeType type = [key unsignedIntegerValue];
                    switch (type)
                    {
                        case NSFetchedResultsChangeInsert:
                            [self.collectionView insertSections:[NSIndexSet indexSetWithIndex:[obj unsignedIntegerValue]]];
                            break;
                        case NSFetchedResultsChangeDelete:
                            [self.collectionView deleteSections:[NSIndexSet indexSetWithIndex:[obj unsignedIntegerValue]]];
                            break;
                        case NSFetchedResultsChangeUpdate:
                            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:[obj unsignedIntegerValue]]];
                            break;
                    }
                }];
            }
        } completion:nil];
    }
    
    if ([_objectChanges count] > 0 && [_sectionChanges count] == 0)
    {
        [self.collectionView performBatchUpdates:^{
            
            for (NSDictionary *change in _objectChanges)
            {
                [change enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, id obj, BOOL *stop) {
                    
                    NSFetchedResultsChangeType type = [key unsignedIntegerValue];
                    switch (type)
                    {
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
        } completion:nil];
    }
    
    [_sectionChanges removeAllObjects];
    [_objectChanges removeAllObjects];
}

- (IBAction)reloadItems:(id)sender {
}
@end