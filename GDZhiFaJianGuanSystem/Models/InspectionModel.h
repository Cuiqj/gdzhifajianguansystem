//
//  InspectionModel.h
//  GDZhiFaJianGuanSystem
//
//  Created by luna on 14-2-22.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseDataModel.h"

@interface InspectionModel : BaseDataModel

@property (nonatomic, retain) NSString * carcode;
@property (nonatomic, retain) NSString * classe;
@property (nonatomic, retain) NSString * date_inspection;
@property (nonatomic, retain) NSString * delivertext;
@property (nonatomic, retain) NSString * description_inspection;
@property (nonatomic, retain) NSString * duty_leader;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * inspection_area;
@property (nonatomic, retain) NSString * inspection_desc;
@property (nonatomic, retain) NSString * inspection_line;
@property (nonatomic, retain) NSString * inspection_milimetres;
@property (nonatomic, retain) NSString * inspection_place;
@property (nonatomic, retain) NSString * inspectionor_name;
@property (nonatomic, retain) NSString * isdeliver;
@property (nonatomic, retain) NSString * isnew;
@property (nonatomic, retain) NSString * lu_opinion;
@property (nonatomic, retain) NSString * lu_opinion_date;
@property (nonatomic, retain) NSString * luzhen_principal;
@property (nonatomic, retain) NSString * organization_id;
@property (nonatomic, retain) NSString * p_opinion;
@property (nonatomic, retain) NSString * p_opinion_date;
@property (nonatomic, retain) NSString * principal;
@property (nonatomic, retain) NSString * recorder_name;
@property (nonatomic, retain) NSString * remark;
@property (nonatomic, retain) NSString * roadsegment_id;
@property (nonatomic, retain) NSString * station_end;
@property (nonatomic, retain) NSString * station_start;
@property (nonatomic, retain) NSString * take_measure;
@property (nonatomic, retain) NSString * time_end;
@property (nonatomic, retain) NSString * time_start;
@property (nonatomic, retain) NSString * weather;

@end
