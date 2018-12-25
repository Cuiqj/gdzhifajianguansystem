//
//  RoadBuildControlModel.m
//  GDZhiFaJianGuanSystem
//
//  Created by luna on 14-2-10.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import "RoadBuildControlModel.h"


@implementation RoadBuildControlModel

@dynamic address;
@dynamic buildqingkuang;
@dynamic caseno;
@dynamic chuliqingkuang;
@dynamic dangshiren;
@dynamic danwei;
@dynamic endornot;
@dynamic gonglizhuanghao;
@dynamic happendate;
@dynamic identifier;
@dynamic noroadmark;
@dynamic numbers;
@dynamic orgid;
@dynamic photourl;
@dynamic place;
@dynamic remark;
@dynamic roadfanwei;
@dynamic shifouluxiang;
@dynamic wiremark;
@dynamic writedate;
@dynamic xianbie;

+ (instancetype)newModelFromXML:(id)xml
{
    // 解析xml
    RoadBuildControlModel *roadBuild = nil;
    
    [MYAPPDELEGATE saveContext];
    return roadBuild;
}

@end
