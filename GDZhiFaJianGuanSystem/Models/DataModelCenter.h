//
//  DataModelCenter.h
//  GDZhiFaJianGuanSystem
//
//  Created by XU SHIWEN on 14-2-8.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBXML.h"
#import "UserInfoSimpleModel.h"
#import "CurrentTaskModel.h"
#import "AllPermitModel.h"
#import "ReportAndAttechmentModel.h"
#import "OrgInfoSimpleModel.h"
#import "AllCaseModel.h"
#import "RoadModel.h"
#import "RoadBuildControlModel.h"
#import "InspectionModel.h"
#import "MessageModel.h"
#import "OrgArticleModel.h"
#import "LawItemsModel.h"
#import "LawsModel.h"
#import "Rpt_statistics_hisModel.h"
#import "Rpt_statisticsModel.h"
#import "RoadEngrossModel.h"
#import "AppSignModel.h"
#import "EmployeeInfoModel.h"
#import "TaskSimpleModel.h"
#import "RoadAssetPriceModel.h"
#import "RoadEngrossPriceModel.h"
#import "StatisticsNewModel.h"
#import "StatisticsLowerOrgModel.h"
#import "PermitExpireModel.h"
@interface DataModelCenter : NSObject

@property (nonatomic, getter = isUserLogin) BOOL userLogin;

@property (retain ,nonatomic) WebServiceHandler * webService;

+ (instancetype)defaultCenter;
+ (instancetype)sysCenter;

- (void)loginWithName:(NSString *)name andPwd:(NSString *)pwd andResult:(void(^)(BOOL success, NSError *err))resultHandler;
- (void)setWebService:(NSString *)name andPwd:(NSString *)pwd;
/**
 * 清除本地数据
 */
- (void)clearLocalData;
/**
 * 同步本地数据
 */
- (void)syncLocalData;

@end
