//
//  PermitExpireModel.h
//  GDZhiFaJianGuanSystem
//
//  Created by yu hongwu on 14-9-18.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseDataModel.h"
#import "TBXML.h"


@interface PermitExpireModel : BaseDataModel

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * project_id;
@property (nonatomic, retain) NSString * case_no;
@property (nonatomic, retain) NSString * process_name;
@property (nonatomic, retain) NSDate * app_date;
@property (nonatomic, retain) NSString * permission_address;
@property (nonatomic, retain) NSString * date_step;
@property (nonatomic, retain) NSString * applicant_name;
@property (nonatomic, retain) NSDate * date_end;
@property (nonatomic, retain) NSNumber * date_diff;
@property (nonatomic, retain) NSNumber * serialnumber;
+ (instancetype)newModelFromXML:(id)xml;
+(instancetype)newModel;
@end
