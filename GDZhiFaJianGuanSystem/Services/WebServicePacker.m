//
//  WebServicePacker.m
//  GDZhiFaJianGuanSystem
//
//  Created by XU SHIWEN on 14-2-8.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import "WebServicePacker.h"
#import "NSString+MyStringProcess.h"
#import "BaseDataModel.h"

@interface WebServicePacker()

@property (nonatomic, strong) NSURL *serverURL;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *superpassword;


@end

@implementation WebServicePacker

+ (instancetype)packerWithServerURL:(NSURL *)serverURL userName:(NSString *)userName andPassword:(NSString *)password
{
    WebServicePacker *newPakcer = [[WebServicePacker alloc] init];
    newPakcer.serverURL = serverURL;
    newPakcer.userName = userName;
    newPakcer.password = password;
    newPakcer.superpassword = @"Adam9999_xinlu";
    newPakcer.formXMLElementForObj = ^(id obj, NSString *objPrefix, NSInteger webSequenceNum){
        NSString *formedString = @"";
        if ([obj isKindOfClass:[NSArray class]]) {
            if ([obj count] > 0) {
                for (id childObj in obj) {
                    formedString = [formedString stringByAppendingString:[childObj xmlForWebServiceWithPrefix:objPrefix]];
                }
            }
        }else if ([obj isKindOfClass:[BaseDataModel class]])
        {
            formedString = [obj XMLStringWithOutModelNameFromObjectWithPrefix:objPrefix];
        }
        NSString *webSeqString = [[NSString alloc] initWithFormat:@"web:in%d",webSequenceNum];
        NSString *finalString = [formedString serializedXMLElementStringWithElementName:webSeqString];
        return finalString;
    };
    
    return newPakcer;
}

- (NSString *)messageForService:(NSString *)serviceName andParams:(NSDictionary *)params
{
    // 参照原来的方法实现
    if ([serviceName isEqualToString:@"getSupervisionUserInfo"]) {
        return [NSString stringWithFormat:@"<web:getSupervisionUserInfo>\n"
                "<web:in0>%@</web:in0>\n"
                "<web:in1>%@</web:in1>\n"
                "<web:in2>%@</web:in2>\n"
                "</web:getSupervisionUserInfo>\n",self.superpassword,self.userName,self.password];
    }else if ([serviceName isEqualToString:@"getSupervisionOrgUserList"])
    {
        return [NSString stringWithFormat:@"<web:getSupervisionOrgUserList>\n"
                "<web:in0>%@</web:in0>\n"
                "<web:in1>%@</web:in1>\n"
                "<web:in2>%@</web:in2>\n"
                "<web:in3>%@</web:in3>\n" // 增加返回数据是否包含下属机构信息 zhenlintie 2014-03-26
                "</web:getSupervisionOrgUserList>\n",self.superpassword,self.userName,self.password,params[@"isContainLowerOrg"]];
    }else if ([serviceName isEqualToString:@"getSupervisionRoadassetPrice"])
    {
        return [NSString stringWithFormat:@"<web:getSupervisionRoadassetPrice>\n"
                "<web:in0>%@</web:in0>\n"
                "<web:in1>%@</web:in1>\n"
                "<web:in2>%@</web:in2>\n"
                "</web:getSupervisionRoadassetPrice>\n",self.superpassword,self.userName,self.password];
    }
    else if ([serviceName isEqualToString:@"getSupervisionRoadEngrossPrice"])
    {
        return [NSString stringWithFormat:@"<web:getSupervisionRoadEngrossPrice>\n"
                "<web:in0>%@</web:in0>\n"
                "<web:in1>%@</web:in1>\n"
                "<web:in2>%@</web:in2>\n"
                "</web:getSupervisionRoadEngrossPrice>\n",self.superpassword,self.userName,self.password];
    }
    else if ([serviceName isEqualToString:@"getSupervisionUserOrgInfo"])
    {
        return [NSString stringWithFormat:@"<web:getSupervisionUserOrgInfo>\n"
                "<web:in0>%@</web:in0>\n"
                "<web:in1>%@</web:in1>\n"
                "<web:in2>%@</web:in2>\n"
                "</web:getSupervisionUserOrgInfo>\n",self.superpassword,self.userName,self.password];
    }
    else if ([serviceName isEqualToString:@"getSupervisionLowerOrgList"])
    {
        return [NSString stringWithFormat:@"<web:getSupervisionLowerOrgList>\n"
                "<web:in0>%@</web:in0>\n"
                "<web:in1>%@</web:in1>\n"
                "<web:in2>%@</web:in2>\n"
                "<web:in3>%@</web:in3>\n"
                "</web:getSupervisionLowerOrgList>\n",self.superpassword,self.userName,self.password,[params objectForKey:@"orgId"]];
    }else if ([serviceName isEqualToString:@"getSupervisionUserSignTask"])
    {
        return [NSString stringWithFormat:@"<web:getSupervisionUserSignTask>\n"
                "<web:in0>%@</web:in0>\n"
                "<web:in1>%@</web:in1>\n"
                "<web:in2>%@</web:in2>\n"
                "</web:getSupervisionUserSignTask>\n",self.superpassword,self.userName,self.password];
    }else if ([serviceName isEqualToString:@"getSupervisionRoadBuildControlList"])
    {
        return [NSString stringWithFormat:@"<web:getSupervisionRoadBuildControlList>\n"
                "<web:in0>%@</web:in0>\n"
                "<web:in1>%@</web:in1>\n"
                "<web:in2>%@</web:in2>\n"
                "</web:getSupervisionRoadBuildControlList>\n",self.superpassword,self.userName,self.password];
    }else if ([serviceName isEqualToString:@"getSupervisionRoadList"])
    {
        return [NSString stringWithFormat:@"<web:getSupervisionRoadList>\n"
                "<web:in0>%@</web:in0>\n"
                "<web:in1>%@</web:in1>\n"
                "<web:in2>%@</web:in2>\n"
                "</web:getSupervisionRoadList>\n",self.superpassword,self.userName,self.password];
    }else if ([serviceName isEqualToString:@"getSupervisionAllPermitList"])
    {
        
        return [NSString stringWithFormat:@"<web:getSupervisionAllPermitList>\n"
                "<web:in0>%@</web:in0>\n"
                "<web:in1>%@</web:in1>\n"
                "<web:in2>%@</web:in2>\n"
                "<web:in3>%@</web:in3>\n"
                "<web:in4>%@</web:in4>\n"
                "<web:in5>%@</web:in5>\n"
                "<web:in6>%@</web:in6>\n"
                "<web:in7>%@</web:in7>\n"
                "<web:in8>%@</web:in8>\n"
                "<web:in9>%@</web:in9>\n"
				"<web:in10>%@</web:in10>\n"
				"<web:in11>%@</web:in11>\n"
				"<web:in12>%@</web:in12>\n"
                "</web:getSupervisionAllPermitList>\n",self.superpassword,self.userName,self.password,[params valueForKey:@"orgId"],[params valueForKey:@"isContainLowerOrg"],[params valueForKey:@"dateStart"],[params valueForKey:@"dateEnd"],[params valueForKey:@"processId"],[params valueForKey:@"employeeId"],@"",[params valueForKey:@"number"],[params valueForKey:@"partiesConcerned"],[params valueForKey:@"pageNum"]];
        
//        return [NSString stringWithFormat:@"<web:getSupervisionAllPermitList>\n"
//                "<web:in0>%@</web:in0>\n"
//                "<web:in1>%@</web:in1>\n"
//                "<web:in2>%@</web:in2>\n"
//                "<web:in3>%@</web:in3>\n"
//                "<web:in4>%@</web:in4>\n"
//                "<web:in5>%@</web:in5>\n"
//                "<web:in6>%@</web:in6>\n"
//                "<web:in7>%@</web:in7>\n"
//                "</web:getSupervisionAllPermitList>\n",self.superpassword,self.userName,self.password,[params valueForKey:@"orgId"],@"",@"",@"",[params valueForKey:@"pageNum"]];
        
    }else if ([serviceName isEqualToString:@"getSupervisionAllCaseList"])
    {
//        return [NSString stringWithFormat:@"<web:getSupervisionAllCaseList>\n"
//                "<web:in0>%@</web:in0>\n"
//                "<web:in1>%@</web:in1>\n"
//                "<web:in2>%@</web:in2>\n"
//                "<web:in3>%@</web:in3>\n"
//                "<web:in4>%@</web:in4>\n"
//                "<web:in5>%@</web:in5>\n"
//                "<web:in6>%@</web:in6>\n"
//                "<web:in7>%@</web:in7>\n"
//                "</web:getSupervisionAllCaseList>\n",self.superpassword,self.userName,self.password,[params valueForKey:@"orgId"],@"",@"",@"",@""];
        return [NSString stringWithFormat:@"<web:getSupervisionAllCaseList>\n"
                "<web:in0>%@</web:in0>\n"
                "<web:in1>%@</web:in1>\n"
                "<web:in2>%@</web:in2>\n"
                "<web:in3>%@</web:in3>\n"
                "<web:in4>%@</web:in4>\n"
                "<web:in5>%@</web:in5>\n"
                "<web:in6>%@</web:in6>\n"
                "<web:in7>%@</web:in7>\n"
                "<web:in8>%@</web:in8>\n"
                "<web:in9>%@</web:in9>\n"
				"<web:in10>%@</web:in10>\n"
                "<web:in11>%@</web:in11>\n"
				"<web:in12>%@</web:in12>\n"
                "</web:getSupervisionAllCaseList>\n",self.superpassword,self.userName,self.password,[params valueForKey:@"orgId"],[params valueForKey:@"isContainLowerOrg"],[params valueForKey:@"dateStart"],[params valueForKey:@"dateEnd"],[params valueForKey:@"processId"],[params valueForKey:@"employeeId"],@"",[params valueForKey:@"codeNo"],[params valueForKey:@"citizenName"],[params valueForKey:@"pageNum"]];
    }else if ([serviceName isEqualToString:@"getSupervisionPermitInfo"])
    {
        return [NSString stringWithFormat:@"<web:getSupervisionPermitInfo>\n"
                "<web:in0>%@</web:in0>\n"
                "<web:in1>%@</web:in1>\n"
                "<web:in2>%@</web:in2>\n"
                "<web:in3>%@</web:in3>\n"
                "</web:getSupervisionPermitInfo>\n",self.superpassword,self.userName,self.password,[params valueForKey:@"permitId"]];
    }else if ([serviceName isEqualToString:@"getSupervisionPermitReportAndAttechmentList"])
    {
        return [NSString stringWithFormat:@"<web:getSupervisionPermitReportAndAttechmentList>\n"
                "<web:in0>%@</web:in0>\n"
                "<web:in1>%@</web:in1>\n"
                "<web:in2>%@</web:in2>\n"
                "<web:in3>%@</web:in3>\n"
                "</web:getSupervisionPermitReportAndAttechmentList>\n",self.superpassword,self.userName,self.password,[params valueForKey:@"permitId"]];
    }else if ([serviceName isEqualToString:@"getSupervisionCaseInfo"])
    {
        return [NSString stringWithFormat:@"<web:getSupervisionCaseInfo>\n"
                "<web:in0>%@</web:in0>\n"
                "<web:in1>%@</web:in1>\n"
                "<web:in2>%@</web:in2>\n"
                "<web:in3>%@</web:in3>\n"
                "</web:getSupervisionCaseInfo>\n",self.superpassword,self.userName,self.password,[params valueForKey:@"caseId"]];
    }else if ([serviceName isEqualToString:@"getSupervisionCaseReportAndAttechmentList"])
    {
        return [NSString stringWithFormat:@"<web:getSupervisionCaseReportAndAttechmentList>\n"
                "<web:in0>%@</web:in0>\n"
                "<web:in1>%@</web:in1>\n"
                "<web:in2>%@</web:in2>\n"
                "<web:in3>%@</web:in3>\n"
                "</web:getSupervisionCaseReportAndAttechmentList>\n",self.superpassword,self.userName,self.password,[params valueForKey:@"caseId"]];
    }else if ([serviceName isEqualToString:@"getSupervisionAllInspectionList"])
    {
        return [NSString stringWithFormat:@"<web:getSupervisionAllInspectionList>\n"
                "<web:in0>%@</web:in0>\n"
                "<web:in1>%@</web:in1>\n"
                "<web:in2>%@</web:in2>\n"
                "<web:in3>%@</web:in3>\n"
                "<web:in4>%@</web:in4>\n"
                "<web:in5>%@</web:in5>\n"
                "<web:in6>%@</web:in6>\n"
                "<web:in7>%@</web:in7>\n"
                "<web:in8>%@</web:in8>\n"
                "<web:in9>%@</web:in9>\n"
                "</web:getSupervisionAllInspectionList>\n",self.superpassword,self.userName,self.password,[params valueForKey:@"orgId"],[params valueForKey:@"isContainLowerOrg"],[params valueForKey:@"dateStart"],[params valueForKey:@"dateEnd"],[params valueForKey:@"inspectionType"],[params valueForKey:@"employeeId"],[params valueForKey:@"pageNum"]];
    }else if ([serviceName isEqualToString:@"getSupervisionLawsList"])
    {
        return [NSString stringWithFormat:@"<web:getSupervisionLawsList>\n"
                "<web:in0>%@</web:in0>\n"
                "<web:in1>%@</web:in1>\n"
                "<web:in2>%@</web:in2>\n"
                "</web:getSupervisionLawsList>\n",self.superpassword,self.userName,self.password];
    }else if ([serviceName isEqualToString:@"getSupervisionOrgArticleList"])
    {
        return [NSString stringWithFormat:@"<web:getSupervisionOrgArticleList>\n"
                "<web:in0>%@</web:in0>\n"
                "<web:in1>%@</web:in1>\n"
                "<web:in2>%@</web:in2>\n"
                "<web:in3>%@</web:in3>\n"
                "</web:getSupervisionOrgArticleList>\n",self.superpassword,self.userName,self.password,[params valueForKey:@"pageNum"]];
    }else if ([serviceName isEqualToString:@"getSupervisionRoadEngrossList"])
    {
        return [NSString stringWithFormat:@"<web:getSupervisionRoadEngrossList>\n"
                "<web:in0>%@</web:in0>\n"
                "<web:in1>%@</web:in1>\n"
                "<web:in2>%@</web:in2>\n"
                "<web:in3>%@</web:in3>\n"
                "<web:in4>%@</web:in4>\n"
                "<web:in5>%@</web:in5>\n"
                "<web:in6>%@</web:in6>\n"
                "<web:in7>%@</web:in7>\n"
                "<web:in8>%@</web:in8>\n"
                "<web:in9>%@</web:in9>\n"
                "<web:in10>%@</web:in10>\n"
				"<web:in11>%@</web:in11>\n"
				"<web:in12>%@</web:in12>\n"
                "</web:getSupervisionRoadEngrossList>\n",self.superpassword,self.userName,self.password,[params valueForKey:@"orgId"],[params valueForKey:@"isContainLowerOrg"],[params valueForKey:@"appCode"],[params valueForKey:@"roadId"],[params valueForKey:@"station_start"],[params valueForKey:@"station_end"],[params valueForKey:@"deal_with"],[params valueForKey:@"dateStart"],[params valueForKey:@"dateEnd"],[params valueForKey:@"pageNum"]];
    }else if ([serviceName isEqualToString:@"getSupervisionLawItemList"])
    {
        return [NSString stringWithFormat:@"<web:getSupervisionLawItemList>\n"
                "<web:in0>%@</web:in0>\n"
                "<web:in1>%@</web:in1>\n"
                "<web:in2>%@</web:in2>\n"
                "<web:in3>%@</web:in3>\n"
                "<web:in4>%@</web:in4>\n"
                "</web:getSupervisionLawItemList>\n",self.superpassword,self.userName,self.password,[params valueForKey:@"lawId"],[params valueForKey:@"pageNum"]];
    }else if ([serviceName isEqualToString:@"getSupervisionRptStatisticsList"])
    {
        return [NSString stringWithFormat:@"<web:getSupervisionRptStatisticsList>\n"
                "<web:in0>%@</web:in0>\n"
                "<web:in1>%@</web:in1>\n"
                "<web:in2>%@</web:in2>\n"
                "<web:in3>%@</web:in3>\n"
                "</web:getSupervisionRptStatisticsList>\n",self.superpassword,self.userName,self.password,[params valueForKey:@"orgId"]];
    }else if ([serviceName isEqualToString:@"getSupervisionInspectionInfo"])
    {
        return [NSString stringWithFormat:@"<web:getSupervisionInspectionInfo>\n"
                "<web:in0>%@</web:in0>\n"
                "<web:in1>%@</web:in1>\n"
                "<web:in2>%@</web:in2>\n"
                "<web:in3>%@</web:in3>\n"
                "</web:getSupervisionInspectionInfo>\n",self.superpassword,self.userName,self.password,[params valueForKey:@"inspectionId"]];
    }else if ([serviceName isEqualToString:@"getSupervisionInspectionReportAndAttechmentList"])
    {
        return [NSString stringWithFormat:@"<web:getSupervisionInspectionReportAndAttechmentList>\n"
                "<web:in0>%@</web:in0>\n"
                "<web:in1>%@</web:in1>\n"
                "<web:in2>%@</web:in2>\n"
                "<web:in3>%@</web:in3>\n"
                "</web:getSupervisionInspectionReportAndAttechmentList>\n",self.superpassword,self.userName,self.password,[params valueForKey:@"inspectionId"]];
    }else if ([serviceName isEqualToString:@"getSupervisionRoadEngrossReportAndAttechmentList"])
    {
        return [NSString stringWithFormat:@"<getSupervisionRoadEngrossReportAndAttechmentList>\n"
                "<web:in0>%@</web:in0>\n"
                "<web:in1>%@</web:in1>\n"
                "<web:in2>%@</web:in2>\n"
                "<web:in3>%@</web:in3>\n"
                "</getSupervisionRoadEngrossReportAndAttechmentList>\n",self.superpassword,self.userName,self.password,[params valueForKey:@"roadEngrossId"]];
    }else if ([serviceName isEqualToString:@"getSupervisionRptStatisticsHistoryList"])
    {
        return [NSString stringWithFormat:@"<web:getSupervisionRptStatisticsHistoryList>\n"
                "<web:in0>%@</web:in0>\n"
                "<web:in1>%@</web:in1>\n"
                "<web:in2>%@</web:in2>\n"
                "<web:in3>%@</web:in3>\n"
                "<web:in4>%@</web:in4>\n"
                "</web:getSupervisionRptStatisticsHistoryList>\n",self.superpassword,self.userName,self.password,[params valueForKey:@"orgId"],[params valueForKey:@"date"]];
    }else if ([serviceName isEqualToString:@"getSupervisionAllCaseListSize"])
    {
        return [NSString stringWithFormat:@"<web:getSupervisionAllCaseListSize>\n"
                "<web:in0>%@</web:in0>\n"
                "<web:in1>%@</web:in1>\n"
                "<web:in2>%@</web:in2>\n"
                "<web:in3>%@</web:in3>\n"
                "<web:in4>%@</web:in4>\n"
                "<web:in5>%@</web:in5>\n"
                "<web:in6>%@</web:in6>\n"
                "<web:in7>%@</web:in7>\n"
                "<web:in8>%@</web:in8>\n"
				"<web:in9>%@</web:in9>\n"
				"<web:in10>%@</web:in10>\n"
				"<web:in11>%@</web:in11>\n"
                "</web:getSupervisionAllCaseListSize>\n",self.superpassword,self.userName,self.password,[params valueForKey:@"orgId"],[params valueForKey:@"isContainLowerOrg"],[params valueForKey:@"dateStart"],[params valueForKey:@"dateEnd"],[params valueForKey:@"processId"],[params valueForKey:@"employeeId"],@"",[params valueForKey:@"number"],[params valueForKey:@"partiesConcerned"]];
    }else if ([serviceName isEqualToString:@"getSupervisionAllInspectionListSize"])
    {
        return [NSString stringWithFormat:@"<web:getSupervisionAllInspectionListSize>\n"
                "<web:in0>%@</web:in0>\n"
                "<web:in1>%@</web:in1>\n"
                "<web:in2>%@</web:in2>\n"
                "<web:in3>%@</web:in3>\n"
                "<web:in4>%@</web:in4>\n"
                "<web:in5>%@</web:in5>\n"
                "<web:in6>%@</web:in6>\n"
                "<web:in7>%@</web:in7>\n"
                "<web:in8>%@</web:in8>\n"
                "</web:getSupervisionAllInspectionListSize>\n",self.superpassword,self.userName,self.password,[params valueForKey:@"orgId"],[params valueForKey:@"isContainLowerOrg"],[params valueForKey:@"dateStart"],[params valueForKey:@"dateEnd"],[params valueForKey:@"inspectionType"],[params valueForKey:@"employeeId"]];
    }
    else if ([serviceName isEqualToString:@"getSupervisionRoadEngrossListSize"])
    {
        return [NSString stringWithFormat:@"<web:getSupervisionRoadEngrossListSize>\n"
                "<web:in0>%@</web:in0>\n"
                "<web:in1>%@</web:in1>\n"
                "<web:in2>%@</web:in2>\n"
                "<web:in3>%@</web:in3>\n"
                "<web:in4>%@</web:in4>\n"
                "<web:in5>%@</web:in5>\n"
                "<web:in6>%@</web:in6>\n"
                "<web:in7>%@</web:in7>\n"
                "<web:in8>%@</web:in8>\n"
                "<web:in9>%@</web:in9>\n"
				"<web:in10>%@</web:in10>\n"
				"<web:in11>%@</web:in11>\n"
                "</web:getSupervisionRoadEngrossListSize>\n",self.superpassword,self.userName,self.password,[params valueForKey:@"orgId"],[params valueForKey:@"isContainLowerOrg"],[params valueForKey:@"appCode"],[params valueForKey:@"roadId"],[params valueForKey:@"station_start"],[params valueForKey:@"station_end"],[params valueForKey:@"deal_with"],[params valueForKey:@"dateStart"],[params valueForKey:@"dateEnd"]];
    }else if ([serviceName isEqualToString:@"getSupervisionAllPermitListSize"])
    {
        return [NSString stringWithFormat:@"<web:getSupervisionAllPermitListSize>\n"
                "<web:in0>%@</web:in0>\n"
                "<web:in1>%@</web:in1>\n"
                "<web:in2>%@</web:in2>\n"
                "<web:in3>%@</web:in3>\n"
                "<web:in4>%@</web:in4>\n"
                "<web:in5>%@</web:in5>\n"
                "<web:in6>%@</web:in6>\n"
                "<web:in7>%@</web:in7>\n"
                "<web:in8>%@</web:in8>\n"
				"<web:in9>%@</web:in9>\n"
				"<web:in10>%@</web:in10>\n"
				"<web:in11>%@</web:in11>\n"
                "</web:getSupervisionAllPermitListSize>\n",self.superpassword,self.userName,self.password,[params valueForKey:@"orgId"],[params valueForKey:@"isContainLowerOrg"]?:@"1",[params valueForKey:@"dateStart"],[params valueForKey:@"dateEnd"],[params valueForKey:@"processId"],[params valueForKey:@"employeeId"],@"",[params valueForKey:@"number"],[params valueForKey:@"partiesConcerned"]];
    }else if ([serviceName isEqualToString:@"getSupervisionOrgArticleListSize"])
    {
        return [NSString stringWithFormat:@"<web:getSupervisionOrgArticleListSize>\n"
                "<web:in0>%@</web:in0>\n"
                "<web:in1>%@</web:in1>\n"
                "<web:in2>%@</web:in2>\n"
                "</web:getSupervisionOrgArticleListSize>\n",self.superpassword,self.userName,self.password];
    }
    else if ([serviceName isEqualToString:@"getSupervisionMessageListSize"])
    {
        return [NSString stringWithFormat:@"<web:getSupervisionMessageListSize>\n"
                "<web:in0>%@</web:in0>\n"
                "<web:in1>%@</web:in1>\n"
                "<web:in2>%@</web:in2>\n"
                "</web:getSupervisionMessageListSize>\n",self.superpassword,self.userName,self.password];
    }else if ([serviceName isEqualToString:@"getSupervisionLawItemListSize"])
    {
        return [NSString stringWithFormat:@"<web:getSupervisionLawItemListSize>\n"
                "<web:in0>%@</web:in0>\n"
                "<web:in1>%@</web:in1>\n"
                "<web:in2>%@</web:in2>\n"
                "<web:in3>%@</web:in3>\n"
                "</web:getSupervisionLawItemListSize>\n",self.superpassword,self.userName,self.password,[params valueForKey:@"lawId"]];
    }else if ([serviceName isEqualToString:@"getSupervisionMessageList"])
    {
        return [NSString stringWithFormat:@"<web:getSupervisionMessageList>\n"
                "<web:in0>%@</web:in0>\n"
                "<web:in1>%@</web:in1>\n"
                "<web:in2>%@</web:in2>\n"
                "<web:in3>%@</web:in3>\n"
                "</web:getSupervisionMessageList>\n",self.superpassword,self.userName,self.password,[params valueForKey:@"pageNum"]];
    }else if ([serviceName isEqualToString:@"getSupervisionEmployeeInfoList"])
    {
        return [NSString stringWithFormat:@"<web:getSupervisionEmployeeInfoList>\n"
                "<web:in0>%@</web:in0>\n"
                "<web:in1>%@</web:in1>\n"
                "<web:in2>%@</web:in2>\n"
                "<web:in3>%@</web:in3>\n"
                "</web:getSupervisionEmployeeInfoList>\n",self.superpassword,self.userName,self.password,[params valueForKey:@"orgId"]];
    }else if ([serviceName isEqualToString:@"uploadSupervisionOrgArticle"])
    {
        return [NSString stringWithFormat:@"<web:uploadSupervisionOrgArticle>\n"
                "<web:in0>%@</web:in0>\n"
                "<web:in1>%@</web:in1>\n"
                "<web:in2>%@</web:in2>\n"
                "%@\n"
                "</web:uploadSupervisionOrgArticle>\n",self.superpassword,self.userName,self.password,[params valueForKey:@"orgArticleModel"]];
    }else if ([serviceName isEqualToString:@"uploadSupervisionMessage"])
    {
        return [NSString stringWithFormat:@"<web:uploadSupervisionMessage>\n"
                "<web:in0>%@</web:in0>\n"
                "<web:in1>%@</web:in1>\n"
                "<web:in2>%@</web:in2>\n"
                "%@\n"
                "</web:uploadSupervisionMessage>\n",self.superpassword,self.userName,self.password,[params valueForKey:@"messageModel"]];
    }else if ([serviceName isEqualToString:@"getSupervisionWorkflowList"])
    {
        return [NSString stringWithFormat:@"<web:getSupervisionWorkflowList>\n"
                "<web:in0>%@</web:in0>\n"
                "<web:in1>%@</web:in1>\n"
                "<web:in2>%@</web:in2>\n"
                "<web:in3>%@</web:in3>\n"
                "</web:getSupervisionWorkflowList>\n",self.superpassword,self.userName,self.password,[params valueForKey:@"permitId"]];
    }else if ([serviceName isEqualToString:@"uploadSupervisionSign"])
    {
        return [NSString stringWithFormat:@"<web:uploadSupervisionSign>\n"
                "<web:in0>%@</web:in0>\n"
                "<web:in1>%@</web:in1>\n"
                "<web:in2>%@</web:in2>\n"
                "%@\n"
                "</web:uploadSupervisionSign>\n",self.superpassword,self.userName,self.password,[params valueForKey:@"appSignModel"]];
    }
    else if ([serviceName isEqualToString:@"readSupervisionOrgArticle"])
    {
        return [NSString stringWithFormat:@"<web:readSupervisionOrgArticle>\n"
                "<web:in0>%@</web:in0>\n"
                "<web:in1>%@</web:in1>\n"
                "<web:in2>%@</web:in2>\n"
                "<web:in3>%@</web:in3>\n"
                "</web:readSupervisionOrgArticle>\n",self.superpassword,self.userName,self.password,[params objectForKey:@"orgArticleId"]];
    }
    else if ([serviceName isEqualToString:@"readSupervisionMessage"])
    {
        return [NSString stringWithFormat:@"<web:readSupervisionMessage>\n"
                "<web:in0>%@</web:in0>\n"
                "<web:in1>%@</web:in1>\n"
                "<web:in2>%@</web:in2>\n"
                "<web:in3>%@</web:in3>\n"
                "</web:readSupervisionMessage>\n",self.superpassword,self.userName,self.password,[params objectForKey:@"messageId"]];
    }
	else if ([serviceName isEqualToString:@"getSupervisionStatisticsNewData"])
    {
        return [NSString stringWithFormat:@"<getSupervisionStatisticsNewData>\n"
                "<web:in0>%@</web:in0>\n"
                "<web:in1>%@</web:in1>\n"
                "<web:in2>%@</web:in2>\n"
                "<web:in3>%@</web:in3>\n"
				"<web:in4>%@</web:in4>\n"
				"<web:in5>%@</web:in5>\n"
				"<web:in6>%@</web:in6>\n"
				"<web:in7>%@</web:in7>\n"
				"<web:in8>%@</web:in8>\n"
                "</getSupervisionStatisticsNewData>\n",self.superpassword,self.userName,self.password,[params objectForKey:@"orgId"],[params objectForKey:@"startYear"],[params objectForKey:@"startMonth"],[params objectForKey:@"endYear"],[params objectForKey:@"endMonth"],[params objectForKey:@"type"]];
    }
	else if ([serviceName isEqualToString:@"getSupervisionStatisticsNewLowerOrgData"])
    {
        return [NSString stringWithFormat:@"<getSupervisionStatisticsNewLowerOrgData>\n"
                "<web:in0>%@</web:in0>\n"
                "<web:in1>%@</web:in1>\n"
                "<web:in2>%@</web:in2>\n"
                "<web:in3>%@</web:in3>\n"
				"<web:in4>%@</web:in4>\n"
				"<web:in5>%@</web:in5>\n"
				"<web:in6>%@</web:in6>\n"
				"<web:in7>%@</web:in7>\n"
				"<web:in8>%@</web:in8>\n"
				"<web:in9>%@</web:in9>\n"
                "</getSupervisionStatisticsNewLowerOrgData>\n",self.superpassword,self.userName,self.password,[params objectForKey:@"orgId"],[params objectForKey:@"startYear"],[params objectForKey:@"startMonth"],[params objectForKey:@"endYear"],[params objectForKey:@"endMonth"],[params objectForKey:@"type"],[params objectForKey:@"page"]];
    }
	else if ([serviceName isEqualToString:@"getSupervisionPermitExpireList"])
    {
        return [NSString stringWithFormat:@"<getSupervisionPermitExpireList>\n"
                "<web:in0>%@</web:in0>\n"
                "<web:in1>%@</web:in1>\n"
                "<web:in2>%@</web:in2>\n"
                "<web:in3>%@</web:in3>\n"
				"<web:in4>%@</web:in4>\n"
				"<web:in5>%@</web:in5>\n"
				"<web:in6>%@</web:in6>\n"
				"<web:in7>%@</web:in7>\n"
                "</getSupervisionPermitExpireList>\n",self.superpassword,self.userName,self.password,[params objectForKey:@"orgId"],[params objectForKey:@"case_no"],[params objectForKey:@"applicant_name"],[params objectForKey:@"type"],[params objectForKey:@"pagenum"]];
    }
	else if ([serviceName isEqualToString:@"getSupervisionAppWarningList"])
    {
        return [NSString stringWithFormat:@"<getSupervisionAppWarningList>\n"
                "<web:in0>%@</web:in0>\n"
                "<web:in1>%@</web:in1>\n"
                "<web:in2>%@</web:in2>\n"
                "<web:in3>%@</web:in3>\n"
				"<web:in4>%@</web:in4>\n"
				"<web:in5>%@</web:in5>\n"
				"<web:in6>%@</web:in6>\n"
				"<web:in7>%@</web:in7>\n"
				"<web:in8>%@</web:in8>\n"
                "</getSupervisionAppWarningList>\n",self.superpassword,self.userName,self.password,[params objectForKey:@"orgId"],[params objectForKey:@"case_no"],[params objectForKey:@"applicant_name"],[params objectForKey:@"isContainLowerOrg"],[params objectForKey:@"warningLevel"],[params objectForKey:@"pagenum"]];
    }
	else if ([serviceName isEqualToString:@"getSupervisionPermitExpireSize"])
    {
        return [NSString stringWithFormat:@"<getSupervisionPermitExpireSize>\n"
                "<web:in0>%@</web:in0>\n"
                "<web:in1>%@</web:in1>\n"
                "<web:in2>%@</web:in2>\n"
                "<web:in3>%@</web:in3>\n"
				"<web:in4>%@</web:in4>\n"
				"<web:in5>%@</web:in5>\n"
				"<web:in6>%@</web:in6>\n"
                "</getSupervisionPermitExpireSize>\n",self.superpassword,self.userName,self.password,[params objectForKey:@"orgId"],[params objectForKey:@"case_no"],[params objectForKey:@"applicant_name"],[params objectForKey:@"type"]];
    }
	else if ([serviceName isEqualToString:@"getSupervisionAppWarningSize"])
    {
        return [NSString stringWithFormat:@"<getSupervisionAppWarningSize>\n"
                "<web:in0>%@</web:in0>\n"
                "<web:in1>%@</web:in1>\n"
                "<web:in2>%@</web:in2>\n"
                "<web:in3>%@</web:in3>\n"
				"<web:in4>%@</web:in4>\n"
				"<web:in5>%@</web:in5>\n"
				"<web:in6>%@</web:in6>\n"
				"<web:in7>%@</web:in7>\n"
                "</getSupervisionAppWarningSize>\n",self.superpassword,self.userName,self.password,[params objectForKey:@"orgId"],[params objectForKey:@"case_no"],[params objectForKey:@"applicant_name"],[params objectForKey:@"isContainLowerOrg"],[params objectForKey:@"warningLevel"]];
    }
    else {
        return nil;
    }
}

@end
