//
//  MasterViewController.h
//  Desktoppr
//
//  Created by James Brooks on 28/10/2012
//  Copyright (c) 2012 James Brooks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "MBProgressHUD.h"

@interface MasterViewController : UICollectionViewController <NSFetchedResultsControllerDelegate, MBProgressHUDDelegate> {
    // For the progress HUD
    MBProgressHUD *HUD;
    long long expectedLength;
    long long currentLength;
}

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
- (IBAction)refreshItems:(id)sender;
- (void)loadDesktopprItems;
@property (strong, nonatomic) IBOutlet UICollectionView *wallpaperCollection;

@end
