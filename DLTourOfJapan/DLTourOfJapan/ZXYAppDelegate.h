//
//  ZXYAppDelegate.h
//  DLTourOfJapan
//
//  Created by developer on 14-6-16.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXYMainViewController.h"
@interface ZXYAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
