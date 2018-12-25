//
//  RoadEngrossPriceModel.h
//  GDZhiFaJianGuanSystem
//
//  Created by luna on 14-3-3.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseDataModel.h"
#import "TBXML.h"

@interface RoadEngrossPriceModel : BaseDataModel

@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * spec;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSString * unit_name;
@property (nonatomic, retain) NSString * remark;

+ (NSArray *)allInstances;
@end
