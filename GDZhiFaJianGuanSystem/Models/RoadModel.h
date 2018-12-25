//
//  RoadModel.h
//  GDZhiFaJianGuanSystem
//
//  Created by luna on 14-2-10.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseDataModel.h"


@interface RoadModel : BaseDataModel

@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSString * delflag;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * place_end;
@property (nonatomic, retain) NSString * place_start;
@property (nonatomic, retain) NSString * remark;
@property (nonatomic, retain) NSString * station_end;
@property (nonatomic, retain) NSString * station_start;

@end
