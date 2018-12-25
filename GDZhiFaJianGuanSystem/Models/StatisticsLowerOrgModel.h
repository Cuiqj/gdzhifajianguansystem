//
//  StatisticsLowerOrgModel.h
//  GDZhiFaJianGuanSystem
//
//  Created by yu hongwu on 14-9-16.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseDataModel.h"
#import "TBXML.h"


@interface StatisticsLowerOrgModel : BaseDataModel

@property (nonatomic, retain) NSNumber * num;
@property (nonatomic, retain) NSString * orgShortName;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * serialnumber;
+ (instancetype)newModelFromXML:(id)xml;
+(instancetype)newModel;
@end
