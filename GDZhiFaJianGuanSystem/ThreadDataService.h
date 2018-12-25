//
//  ThreadDataService.h
//  GDZhiFaJianGuanSystem
//
//  Created by yu hongwu on 14-9-28.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThreadDataService : NSObject
- (NSManagedObjectContext *)threadManagedObjectContext;
- (void)onFinishParsing;
- (void)threadControllerContextDidSave:(NSNotification*)saveNotification ;
- (void)mergeToMainContext:(NSNotification*)saveNotification;
@end
