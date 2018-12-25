//
//  Rpt_statistics_hisModel.h
//  GDZhiFaJianGuanSystem
//
//  Created by luna on 14-2-17.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseDataModel.h"

@interface Rpt_statistics_hisModel : BaseDataModel

@property (nonatomic, retain) NSString * amount;
@property (nonatomic, retain) NSString * beginsum;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * endsum;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * orgid;
@property (nonatomic, retain) NSString * rate;
@property (nonatomic, retain) NSString * remark;
@property (nonatomic, retain) NSString * stattypes;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSString * typenames;

@end
