//
//  JBAppDelegate.h
//  Desktoppr
//
//  Created by James Brooks on 28/10/2012
//  Copyright (c) 2012 James Brooks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JBAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
