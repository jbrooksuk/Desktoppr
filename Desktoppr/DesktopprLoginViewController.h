//
//  DesktopprLoginViewController.h
//  Desktoppr
//
//  Created by ITR on 28/10/2012.
//  Copyright (c) 2012 jbrooksuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DesktopprLogin;

@interface DesktopprLoginViewController : UITableViewController <NSFetchedResultsControllerDelegate>

// Core Data stuff?
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObject *loginModel;

// Account details.
@property (strong, nonatomic) IBOutlet UITextField *desktopprUsername;
@property (strong, nonatomic) IBOutlet UITextField *desktopprPassword;
@property (weak, nonatomic) NSString *username;
@property (weak, nonatomic) NSString *password;

// Actions and stuff.
- (IBAction)desktopprLogin:(id)sender;
- (void)getLoginDetails;

// These two functions also set data in CoreData.
- (void)setUsername;
- (void)setPassword;

@end
