//
//  StatisticsNewModel.h
//  GDZhiFaJianGuanSystem
//
//  Created by yu hongwu on 14-9-15.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseDataModel.h"
#import "TBXML.h"


@interface StatisticsNewModel : BaseDataModel

@property (nonatomic, retain) NSString * names;
@property (nonatomic, retain) NSNumber * num_begin;
@property (nonatomic, retain) NSNumber * num_end;
@property (nonatomic, retain) NSNumber * num_notend;
@property (nonatomic, retain) NSNumber * money_count;
@property (nonatomic, retain) NSNumber * money_fact;
@property (nonatomic, retain) NSString * types;
+ (instancetype)newModelFromXML:(id)xml;
+(instancetype)newModel;
@end
