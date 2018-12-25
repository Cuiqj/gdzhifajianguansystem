//
//  RoadEngrossModel.h
//  GDZhiFaJianGuanSystem
//
//  Created by luna on 14-2-17.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseDataModel.h"

@interface RoadEngrossModel : BaseDataModel

@property (nonatomic, retain) NSString * accessory_no;
@property (nonatomic, retain) NSString * approve_code;
@property (nonatomic, retain) NSString * build_structure;
@property (nonatomic, retain) NSString * built_area;
@property (nonatomic, retain) NSString * built_count;
@property (nonatomic, retain) NSString * built_distance;
@property (nonatomic, retain) NSString * built_length;
@property (nonatomic, retain) NSString * case_no;
@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSDate * date_end;
@property (nonatomic, retain) NSDate * date_start;
@property (nonatomic, retain) NSString * deal_with;
@property (nonatomic, retain) NSString * engross_built_info;
@property (nonatomic, retain) NSString * engross_info;
@property (nonatomic, retain) NSString * engross_space;
@property (nonatomic, retain) NSString * engross_style;
@property (nonatomic, retain) NSString * fix;
@property (nonatomic, retain) NSString * grading;
@property (nonatomic, retain) NSString * gutter_distance;
@property (nonatomic, retain) NSString * height;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * inroad_info;
@property (nonatomic, retain) NSString * item_type;
@property (nonatomic, retain) NSString * linkman_name;
@property (nonatomic, retain) NSString * linkman_phone;
@property (nonatomic, retain) NSString * org_id;
@property (nonatomic, retain) NSString * owner_name;
@property (nonatomic, retain) NSString * remark;
@property (nonatomic, retain) NSDate * removeDate;
@property (nonatomic, retain) NSString * roadSegment_id;
@property (nonatomic, retain) NSString * serialno;
@property (nonatomic, retain) NSString * station_end;
@property (nonatomic, retain) NSString * station_start;
@property (nonatomic, retain) NSString * support_type;
@property (nonatomic, retain) NSString * tag_content;
@property (nonatomic, retain) NSString * yearno;

@end
