//
//  AppDelegate.h
//  GDZhiFaJianGuanSystem
//
//  Created by XU SHIWEN on 14-2-7.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,strong)NSString *serverAddress;
@property (nonatomic,strong)NSString *fileAddress;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
+ (AppDelegate *)App;
@end


@interface MyNavigationController : UINavigationController

@end