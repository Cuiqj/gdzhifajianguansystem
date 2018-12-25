//
//  AppVariates.h
//  GDZhiFaJianGuanSystem
//
//  Created by yu hongwu on 14-10-11.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TreeViewNode.h"

NSMutableArray *ORG_TREE;
@interface AppUtil : NSObject
+(void)getOrgList:(void (^)())asyncHanlder;
+(void)getTreeViewNode:(NSArray*)orgList;
@end
