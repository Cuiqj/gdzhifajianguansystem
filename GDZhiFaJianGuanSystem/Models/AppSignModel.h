//
//  AppSignModel.h
//  GDZhiFaJianGuanSystem
//
//  Created by luna on 14-2-21.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseDataModel.h"


@interface AppSignModel : BaseDataModel

@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSDate * signDate;
@property (nonatomic, retain) NSString * signName;
@property (nonatomic, retain) NSString * signOption;
@property (nonatomic, retain) NSString * nextUser;

@end
