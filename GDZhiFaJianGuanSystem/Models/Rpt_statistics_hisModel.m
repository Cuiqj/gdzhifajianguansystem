//
//  Rpt_statistics_hisModel.m
//  GDZhiFaJianGuanSystem
//
//  Created by luna on 14-2-17.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import "Rpt_statistics_hisModel.h"


@implementation Rpt_statistics_hisModel

@dynamic amount;
@dynamic beginsum;
@dynamic date;
@dynamic endsum;
@dynamic identifier;
@dynamic orgid;
@dynamic rate;
@dynamic remark;
@dynamic stattypes;
@dynamic status;
@dynamic typenames;

+ (instancetype)newModelFromXML:(id)xml
{
    // 解析xml
    Rpt_statistics_hisModel *rpt_his = nil;
    dispatch_sync(dispatch_get_main_queue(), ^{
		[MYAPPDELEGATE saveContext];
	});
    return rpt_his;
}

@end
