//
//  MovieListAppDelegate.h
//  Ketchup
//
//  Created by Paul van Nugteren on 18.02.14.
//  Copyright (c) 2014 Paul van Nugteren. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieListAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
