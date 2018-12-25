//
//  EmployeeInfoModel.h
//  GDZhiFaJianGuanSystem
//
//  Created by luna on 14-3-5.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseDataModel.h"
#import "TBXML.h"


@interface EmployeeInfoModel : BaseDataModel

@property (nonatomic, retain) NSString * academic;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * appearance;
@property (nonatomic, retain) NSString * birthday;
@property (nonatomic, retain) NSString * cardID;
@property (nonatomic, retain) NSString * delFlag;
@property (nonatomic, retain) NSString * depart_id;
@property (nonatomic, retain) NSString * duty;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * employee_code;
@property (nonatomic, retain) NSString * enforce_code;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * im_code;
@property (nonatomic, retain) NSString * marriage;
@property (nonatomic, retain) NSString * memo;
@property (nonatomic, retain) NSString * mobile;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * nation;
@property (nonatomic, retain) NSString * nativePlace;
@property (nonatomic, retain) NSString * orderdesc;
@property (nonatomic, retain) NSString * organization_id;
@property (nonatomic, retain) NSString * photo;
@property (nonatomic, retain) NSString * quality;
@property (nonatomic, retain) NSString * resume;
@property (nonatomic, retain) NSString * rewards_punishments;
@property (nonatomic, retain) NSString * roadwork_time;
@property (nonatomic, retain) NSString * sex;
@property (nonatomic, retain) NSString * speciality;
@property (nonatomic, retain) NSString * telephone;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * work_start_date;

@end
