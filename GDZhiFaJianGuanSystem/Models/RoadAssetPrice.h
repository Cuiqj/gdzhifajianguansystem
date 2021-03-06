//
//  RoadAssetPrice.h
//  GDZhiFaJianGuanSystem
//
//  Created by luna on 14-3-3.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseDataModel.h"
#import "TBXML.h"

extern NSString * const RoadAssetPriceStandardAllStandards;
@interface RoadAssetPrice : BaseDataModel

@property (nonatomic, retain) NSString * big_type;
@property (nonatomic, retain) NSString * damage_type;
@property (nonatomic, retain) NSString * depart_num;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSString * remark;
@property (nonatomic, retain) NSString * roadasset_id;
@property (nonatomic, retain) NSString * spec;
@property (nonatomic, retain) NSString * standard;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * unit_name;

//+ (NSArray *)allDistinctPropertiesNamed:(NSString *)propertyName;
//+ (NSArray *)roadAssetPricesForStandard:(NSString *)standardName;
@end
