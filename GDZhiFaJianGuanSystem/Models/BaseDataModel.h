//
//  BaseDataModel.h
//  GDZhiFaJianGuanSystem
//
//  Created by XU SHIWEN on 14-2-8.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <objc/objc.h>
#import <objc/runtime.h>
#import "NSString+MyStringProcess.h"
#import "AppDelegate.h"

@interface BaseDataModel : NSManagedObject

+ (instancetype)newModelFromXML:(id)xml;

- (NSString *)xmlForWebService;

- (NSString *)xmlForWebServiceWithPrefix:(NSString *)prefix;

- (NSString *)XMLStringWithOutModelNameFromObjectWithPrefix:(NSString *)prefix;

@end
