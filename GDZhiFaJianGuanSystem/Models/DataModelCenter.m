//
//  DataModelCenter.m
//  GDZhiFaJianGuanSystem
//
//  Created by XU SHIWEN on 14-2-8.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import "DataModelCenter.h"
#import "WebServiceHandler.h"
#import "AppUtil.h"

@interface DataModelCenter()

@end


@implementation DataModelCenter

- (id)initSingleton
{
    if (self = [super init]) {
    }
    return self;
}

+ (instancetype)defaultCenter
{
    static DataModelCenter *center = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        center = [[self alloc] initSingleton];
    });
    return center;
}
+ (instancetype)sysCenter
{
    static DataModelCenter *center = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        center = [[self alloc] initSingleton];
    });
    return center;
}
- (void)loginWithName:(NSString *)name andPwd:(NSString *)pwd andResult:(void (^)(BOOL, NSError *))resultHandler
{
    self.webService = [WebServiceHandler handlerWithURL:nil userName:name andPassword:pwd];
    [self.webService getSupervisionUserInfo:^(UserInfoSimpleModel *user, NSError *err) {
        if (err!=nil) {
            resultHandler(NO,err);
        }else
        {
			dispatch_sync(dispatch_get_main_queue(), ^{
				[[NSUserDefaults standardUserDefaults] setValue:user.orgID forKey:ORGKEY];
				[[NSUserDefaults standardUserDefaults] setValue:user.username forKey:USERNAME];
            });
            resultHandler(YES,err);
        }
		 
    }];
}




- (void)syncLocalData
{
    [self clearLocalData];


	
	
    [self downLoadUserData];
	[self downRoadassetPriceData];
	[self downRoadEngrossPriceData];
	[self downLowerOrgListData];

	
	
//    [self downLoadCurrentUserData];
//    [self downLoadOrgData];
//    [self downLoadAllPermitData];
//    [self downLoadCurrentTaskData];
//    [self downLoadRoadData];
//    [self downLoadPermitData];
//    [self downLoadReportAttechData];
//    [self downLoadAllCaseData];
//    [self downLoadCaseModelData];
//    [self downLoadCaseReportData];
//    [self downLoadLawsData];
//    [self downLoadInspectionData];
//    [self downLoadOrgArticleData];
//    [self downLoadRoadEngrossData];
//    [self downLoadLawsInfoData];
//    [self downLoadStatisticsData];
//    [self downLoadInspectionInfoData];
//    [self downLoadInspectionReportData];
//    [self downLoadStatisticsHisData];
//    [self downLoadAllCaseListData];
//    [self downLoadInspectionListData];
//    [self downLoadRoadEngrossListData];
//    [self downLoadPermitListData];
//    [self downLoadOrgListData];
//    [self downLoadMessageListData];
//    [self downLoadLawListData];
//    [self downLoadMessageData];
//    [self downLoadEmployeeData];
//    [self upLoadOrgArticle];
//    [self upLoadMessage];
//    [self downLoadTaskData];
//    [self upLoadAppSign];

}

- (void)clearLocalData
{

    [self clearEntityForName:@"UserInfoSimpleModel"];
    [self clearEntityForName:@"CurrentTaskModel"];
    [self clearEntityForName:@"AllPermitModel"];
    [self clearEntityForName:@"ReportAndAttechmentModel"];
    [self clearEntityForName:@"OrgInfoSimpleModel"];
    [self clearEntityForName:@"AllCaseModel"];
    [self clearEntityForName:@"RoadModel"];
    [self clearEntityForName:@"RoadBuildControlModel"];
    [self clearEntityForName:@"InspectionModel"];
    [self clearEntityForName:@"MessageModel"];
    [self clearEntityForName:@"OrgArticleModel"];
    [self clearEntityForName:@"LawItemsModel"];
    [self clearEntityForName:@"LawsModel"];
    [self clearEntityForName:@"Rpt_statistics_hisModel"];
    [self clearEntityForName:@"Rpt_statisticsModel"];
    [self clearEntityForName:@"RoadEngrossModel"];
    [self clearEntityForName:@"AppSignModel"];
    [self clearEntityForName:@"EmployeeInfoModel"];
    [self clearEntityForName:@"TaskSimpleModel"];
    [self clearEntityForName:@"RoadEngrossPriceModel"];
	[self clearEntityForName:@"StatisticsNewModel"];
    
}

-(void)clearEntityForName:(NSString *)entityName{
    NSError *error=nil;
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    NSEntityDescription *entity=[NSEntityDescription entityForName:entityName inManagedObjectContext:[MYAPPDELEGATE managedObjectContext]];
    [fetchRequest setPredicate:nil];
    [fetchRequest setEntity:entity];
    [fetchRequest setIncludesPropertyValues:NO];
    NSArray *mutableFetchResults=[[MYAPPDELEGATE managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *tableinfo in mutableFetchResults){
        [[MYAPPDELEGATE managedObjectContext] deleteObject:tableinfo];
    }
    [MYAPPDELEGATE saveContext];
    
}

-(void)downLoadUserData
{

    [self.webService getSupervisionOrgUserListBySynchronous:^(NSArray *userList, NSError *err) {
    } containLowerOrg:YES];
}
-(void)downRoadEngrossPriceData
{
	
    [self.webService getSupervisionRoadEngrossPriceBySynchronous:^(NSArray *roadEngross, NSError *err){}];
}

-(void)downLowerOrgListData
{
    [self.webService getSupervisionLowerOrgListBySynchronous:@"" withAsyncHanlder:^(NSArray *orgList, NSError *err) {
		dispatch_sync(dispatch_get_main_queue(), ^{
			if (err == nil) {
				[AppUtil getTreeViewNode:orgList];
			}
		});
	}];
}
-(void)downRoadassetPriceData
{
    [self.webService getSupervisionRoadassetPriceBySynchronous:^(NSArray *roadasset, NSError *err) {
    }];
}
-(void)downLoadCurrentUserData
{
    [self.webService getSupervisionUserInfo:^(UserInfoSimpleModel *user, NSError *err) {
        NSLog(@"获取当前用户简单信息 %@",user);

    }];
}

-(void)downLoadOrgData
{
    [self.webService getSupervisionLowerOrgList:@"13860865" withAsyncHanlder:^(NSArray *orgList, NSError *err) {
        NSLog(@"%@",orgList);
    }];
}

-(void)downLoadCurrentTaskData
{
    [self.webService getSupervisionUserSignTask:^(NSArray *userSignTaskList, NSError *err) {
        NSLog(@"获取当前待办的许可意见任务downLoadCurrentTaskData %@",userSignTaskList);
    }];
}

-(void)downLoadRoadData
{
    [self.webService getSupervisionRoadList:^(NSArray *roadList, NSError *err) {
        NSLog(@"downLoadRoadData  %@",roadList);
    }];
}

-(void)downLoadPermitData
{
    [self.webService getSupervisionPermitInfo:@"1210449924" withAsyncHanlder:^(AllPermitModel *permit, NSError *err) {
        NSLog(@"downLoadPermitData  %@",permit);
    }];
}

-(void)downLoadReportAttechData
{
    [self.webService getSupervisionPermitReportAndAttechmentList:@"1210449924" withAsyncHanlder:^(NSArray *attachList, NSError *err) {
        NSLog(@"downLoadReportAttechData %@",attachList);
    }];
}

-(void)downLoadAllPermitData
{
 
    NSDictionary * dicTest = @{@"processId": @"101",@"orgId":@"237568002",@"dateStart":@"2014-01-20",@"dateEnd":@"2014-02-13",@"isContainLowerOrg":@"1",@"employeeId":@""};
    
    [self.webService getSupervisionAllPermitList:dicTest withAsyncHanlder:^(NSArray *permitList, NSError *err) {
        NSLog(@"downLoadAllPermitData %@",permitList);
    }];
}

- (void)downLoadAllCaseData
{
    
    NSDictionary * dicTest = @{@"processId": @"120",@"orgId":@"237568002",@"dateStart":@"2014-01-20",@"dateEnd":@"2014-02-13",@"isContainLowerOrg":@"1",@"employeeId":@""};
    
    [self.webService getSupervisionAllCaseList:dicTest withAsyncHanlder:^(NSArray *caseList, NSError *err) {
        NSLog(@"downLoadAllCaseData  %@",caseList);
    }];
}

-(void)downLoadCaseModelData
{
    [self.webService getSupervisionCaseInfo:@"1200193538" withAsyncHanlder:^(AllCaseModel *caseModel, NSError *err) {
        NSLog(@"downLoadCaseModelData  %@",caseModel);
    }];
}

-(void)downLoadCaseReportData
{
    [self.webService getSupervisionCaseReportAndAttechmentList:@"1200193538" withAsyncHanlder:^(NSArray *reportAndAttechmentList, NSError *err) {
        NSLog(@"downLoadCaseReportData  %@",reportAndAttechmentList);
    }];
}

- (void)downLoadInspectionData
{
    
    NSDictionary * dicTest = @{@"orgId":@"237568002",@"dateStart":@"2014-01-20",@"dateEnd":@"2014-02-13",@"isContainLowerOrg":@"1",@"employeeId":@""};
    
    [self.webService getSupervisionAllInspectionList:dicTest withAsyncHanlder:^(NSArray *inspectionList, NSError *err) {
        NSLog(@"downLoadInspectionData  %@",inspectionList);
    }];
}

-(void)downLoadLawsData
{
    [self.webService getSupervisionLawsList:^(NSArray *lawsList, NSError *err) {
        NSLog(@"downLoadLawsData  %@",lawsList);
    }];
}

-(void)downLoadOrgArticleData
{
    [self.webService getSupervisionOrgArticleList:nil withAsyncHanlder:^(NSArray *orgArticleList, NSError *err) {
        NSLog(@"downLoadOrgArticleData   %@",orgArticleList);
    }];
}

-(void)downLoadRoadEngrossData
{
    NSDictionary * dicTest = @{@"orgId":@"237568002",@"dateStart":@"2014-01-20",@"dateEnd":@"2014-02-13",@"isContainLowerOrg":@"1"};
    
    [self.webService getSupervisionRoadEngrossList:dicTest withAsyncHanlder:^(NSArray *roadEngrossList, NSError *err) {
        NSLog(@"downLoadRoadEngrossData  %@",roadEngrossList);
    }];
}

-(void)downLoadLawsInfoData
{
    NSDictionary * dicTest = @{@"lawId":@"1132167170",@"pageNum":@"1"};
    
    [self.webService getSupervisionLawItemList:dicTest withAsyncHanlder:^(NSArray *lawItemsList, NSError *err) {
        NSLog(@"downLoadLawsInfoData  %@",lawItemsList);
    }];
}

-(void)downLoadStatisticsData
{
    
    [self.webService getSupervisionRptStatisticsList:@"237568002" withAsyncHanlder:^(NSArray *statisticsList, NSError *err) {
        NSLog(@"downLoadStatisticsData  %@",statisticsList);
    }];
}

-(void)downLoadInspectionInfoData
{
    [self.webService getSupervisionInspectionInfo:@"1196067037" withAsyncHanlder:^(InspectionModel *inspection, NSError *err) {
        NSLog(@"downLoadInspectionInfoData   %@",inspection);
    }];
}

-(void)downLoadInspectionReportData
{
    [self.webService getSupervisionInspectionReportAndAttechmentList:@"1196067037" withAsyncHanlder:^(NSArray *reportAndAttechmentList, NSError *err) {
        NSLog(@"downLoadInspectionReportData  %@",reportAndAttechmentList);
    }];
}

-(void)downLoadStatisticsHisData
{
    
    NSDictionary * dicTest = @{@"orgId":@"237568002",@"date":@"2013-04-01"};
    
    [self.webService getSupervisionRptStatisticsHistoryList:dicTest withAsyncHanlder:^(NSArray *statisticsList, NSError *err) {
        NSLog(@"%@",statisticsList);
    }];

}

-(void)downLoadAllCaseListData
{
    NSDictionary * dicTest = @{@"processId": @"120",@"orgId":@"237568002",@"dateStart":@"2014-01-20",@"dateEnd":@"2014-02-13",@"isContainLowerOrg":@"1",@"isContainLowerOrg":@"1",@"employeeId":@""};
    
    [self.webService getSupervisionAllCaseListSize:dicTest withAsyncHanlder:^(int listSize, NSError *err) {
        NSLog(@"downLoadAllCaseListData   %d",listSize);
    }];
}

-(void)downLoadInspectionListData
{
    NSDictionary * dicTest = @{@"processId": @"120",@"orgId":@"237568002",@"dateStart":@"2014-01-20",@"dateEnd":@"2014-02-13",@"isContainLowerOrg":@"1",@"employeeId":@""};
    
    [self.webService getSupervisionAllInspectionListSize:dicTest withAsyncHanlder:^(int inspectionList, NSError *err) {
        NSLog(@"downLoadInspectionListData  %d",inspectionList);
    }];
}

-(void)downLoadRoadEngrossListData
{
    NSDictionary * dicTest = @{@"processId": @"120",@"orgId":@"237568002",@"dateStart":@"2014-01-20",@"dateEnd":@"2014-02-13",@"isContainLowerOrg":@"1"};
    
    [self.webService getSupervisionRoadEngrossListSize:dicTest withAsyncHanlder:^(int roadEngrossList, NSError *err) {
        NSLog(@"downLoadRoadEngrossListData  %d",roadEngrossList);
    }];
}

-(void)downLoadPermitListData
{
    NSDictionary * dicTest = @{@"processId": @"120",
                               @"orgId":@"237568002",
                               @"dateStart":@"2014-01-20",
                               @"dateEnd":@"2014-02-13",
                               @"isContainLowerOrg":@"1",
                               @"employeeId":@""};
    
    [self.webService getSupervisionAllPermitListSize:dicTest withAsyncHanlder:^(int permitList, NSError *err) {
        NSLog(@"downLoadPermitListData  %d",permitList);
    }];
}

-(void)downLoadOrgListData
{
    [self.webService getSupervisionOrgArticleListSize:^(int orgArticleList, NSError *err) {
        NSLog(@"downLoadOrgListData   %d",orgArticleList);
    }];
}

-(void)downLoadMessageListData
{
    [self.webService getSupervisionMessageListSize:^(int messageList, NSError *err) {
        NSLog(@"downLoadMessageListData   %d",messageList);
    }];
}

-(void)downLoadLawListData
{
//    NSDictionary * dicTest = @{@"lawId":@"1132167170"};
    
    [self.webService getSupervisionLawItemListSize:@"1132167170" withAsyncHanlder:^(int lawList, NSError *err) {
        NSLog(@"downLoadLawListData  %d",lawList);
    }];
}

-(void)downLoadMessageData
{
    NSDictionary * dicTest = @{@"lawId":@"1132167170",@"pageNum":@"1"};
    
    [self.webService getSupervisionMessageList:[dicTest objectForKey:@"pageNum"] withAsyncHanlder:^(NSArray *messageList, NSError *err) {
        NSLog(@"downLoadMessageData  %@",messageList);
    }];
}

-(void)downLoadEmployeeData
{
    NSDictionary * dicTest = @{@"orgId":@"237568002"};
    
    [self.webService getSupervisionEmployeeInfoList:dicTest withAsyncHanlder:^(NSArray *employeeList, NSError *err) {
        NSLog(@"downLoadEmployeeData  %@",employeeList);
    }];
    
}

-(void)upLoadOrgArticle
{
    NSManagedObjectContext *context=[MYAPPDELEGATE managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"OrgArticleModel" inManagedObjectContext:context];
    OrgArticleModel *orgArticle =[[OrgArticleModel alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
    
    orgArticle.identifier=@"123456789";
    orgArticle.remark=@"15469878456";
    orgArticle.org_id=@"156487965442222";
    
    NSError *error;
    if(![context save:&error])
    {
        NSLog(@" OrgArticleModel  不能保存：%@",[error localizedDescription]);
    }
    
    [self.webService uploadSupervisionOrgArticle:orgArticle withAsyncHanlder:^(BOOL flg, NSError *err) {
        NSLog(@"%hhd",flg);
    }];
}

-(void)upLoadMessage
{
    NSManagedObjectContext *context=[MYAPPDELEGATE managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"MessageModel" inManagedObjectContext:context];
    MessageModel *message =[[MessageModel alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
    
    message.identifier=@"123456789";
    message.content=@"235699885566666666666666666666";
    message.title=@"156487965442222";
    
    NSError *error;
    if(![context save:&error])
    {
        NSLog(@" MessageModel  不能保存：%@",[error localizedDescription]);
    }
    
    [self.webService uploadSupervisionMessage:message withAsyncHanlder:^(BOOL flg, NSError *err) {
        NSLog(@"%hhd",flg);
    }];
}

-(void)downLoadTaskData
{
    [self.webService getSupervisionWorkflowList:@"1200193538" withAsyncHanlder:^(NSArray *taskList, NSError *err) {
        NSLog(@"获取许可案件流程信息%@",taskList);
    }];
}

-(void)upLoadAppSign
{
    NSManagedObjectContext *context=[MYAPPDELEGATE managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"AppSignModel" inManagedObjectContext:context];
    AppSignModel *appSign =[[AppSignModel alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
    
    appSign.identifier=@"123456789";
    appSign.nextUser=@"235699885566666666666666666666";
    appSign.signName=@"156487965442222";
    
    NSError *error;
    if(![context save:&error])
    {
        NSLog(@" AppSignModel  不能保存：%@",[error localizedDescription]);
    }
    
    [self.webService uploadSupervisionSign:appSign withAsyncHanlder:^(BOOL flg, NSError *err) {
    }];
}

@end
