//
//  TaskSimpleModel.h
//  GDZhiFaJianGuanSystem
//
//  Created by luna on 14-2-25.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseDataModel.h"
#import "TBXML.h"

@interface TaskSimpleModel : BaseDataModel

@property (nonatomic, retain) NSString * current_status;
@property (nonatomic, retain) NSString * end_time;
@property (nonatomic, retain) NSString * handle_orgid;
@property (nonatomic, retain) NSString * handle_orgname;
@property (nonatomic, retain) NSString * handle_username;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * next_task_id;
@property (nonatomic, retain) NSString * node_id;
@property (nonatomic, retain) NSString * node_name;
@property (nonatomic, retain) NSString * previous_task_id;
@property (nonatomic, retain) NSString * process_type;
@property (nonatomic, retain) NSString * project_id;
@property (nonatomic, retain) NSString * return_reson;
@property (nonatomic, retain) NSString * start_time;
@property (nonatomic, retain) NSString * timeout;
@property (nonatomic, retain) NSString * user_account;

@end
