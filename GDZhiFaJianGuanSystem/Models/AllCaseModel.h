//
//  AllCaseModel.h
//  GDZhiFaJianGuanSystem
//
//  Created by luna on 14-2-22.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseDataModel.h"


@interface AllCaseModel : BaseDataModel

@property (nonatomic, retain) NSString * anjuan_no;
@property (nonatomic, retain) NSString * automobile_number;
@property (nonatomic, retain) NSString * baomi_type;
@property (nonatomic, retain) NSString * case_code;
@property (nonatomic, retain) NSString * caseqingkuang;
@property (nonatomic, retain) NSString * casereasonAuto;
@property (nonatomic, retain) NSString * citizen_address;
@property (nonatomic, retain) NSString * citizen_name;
@property (nonatomic, retain) NSString * citizen_tel;
@property (nonatomic, retain) NSString * danganshi_no;
@property (nonatomic, retain) NSString * execute_circs;
@property (nonatomic, retain) NSString * fact_pay_sum;
@property (nonatomic, retain) NSString * happen_date;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * limit;
@property (nonatomic, retain) NSString * org_id;
@property (nonatomic, retain) NSString * pay_sum;
@property (nonatomic, retain) NSString * process_id;
@property (nonatomic, retain) NSString * process_name;
@property (nonatomic, retain) NSString * punish_sum;
@property (nonatomic, retain) NSString * quanzong_no;
@property (nonatomic, retain) NSString * road_name;
@property (nonatomic, retain) NSString * station_end;
@property (nonatomic, retain) NSString * station_end_display;
@property (nonatomic, retain) NSString * station_start;
@property (nonatomic, retain) NSString * station_start_display;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, copy) NSString * date_caseend;

@end
