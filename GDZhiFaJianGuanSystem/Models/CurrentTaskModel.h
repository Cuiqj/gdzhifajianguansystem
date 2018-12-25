//
//  CurrentTaskModel.h
//  GDZhiFaJianGuanSystem
//
//  Created by luna on 14-2-21.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseDataModel.h"


@interface CurrentTaskModel : BaseDataModel

@property (nonatomic, retain) NSString * app_no;
@property (nonatomic, retain) NSString * applicant_name;
@property (nonatomic, retain) NSString * current_status;
@property (nonatomic, retain) NSString * currentUserAccount;
@property (nonatomic, retain) NSString * currentUserName;
@property (nonatomic, retain) NSString * end_time;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * importent;
@property (nonatomic, retain) NSString * lastUserAccount;
@property (nonatomic, retain) NSString * lastUserName;
@property (nonatomic, retain) NSString * name1;
@property (nonatomic, retain) NSString * name2;
@property (nonatomic, retain) NSString * nodeId;
@property (nonatomic, retain) NSString * nodeName;
@property (nonatomic, retain) NSString * org_id;
@property (nonatomic, retain) NSString * project_id;
@property (nonatomic, retain) NSString * signDate;
@property (nonatomic, retain) NSString * signName;
@property (nonatomic, retain) NSString * signOption;
@property (nonatomic, retain) NSString * start_time;
@property (nonatomic, retain) NSString * timeout;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * yijian1;
@property (nonatomic, retain) NSString * yijian2;
@property (nonatomic, retain) NSString * date_cut;

@end
