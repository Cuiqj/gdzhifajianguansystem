//
//  WebServiceHandler.h
//  GDZhiFaJianGuanSystem
//
//  Created by XU SHIWEN on 14-2-7.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 * 以下声明需被实现，否则会运行时异常
 */

@class OrgInfoSimpleModel;
@class UserInfoSimpleModel;
@class AllPermitModel;
@class ReportAndAttechmentModel;
@class CurrentTaskModel;
@class AllCaseModel;
@class InspectionModel;
@class RoadBuildControlModel;
@class RoadModel;
@class OrgArticleModel;
@class MessageModel;
@class AppSignModel;
@class StatisticsNewModel;

@protocol WebServiceHandlerDelegate;

/**
 * 处理与web服务器的交互
 */
@interface WebServiceHandler : NSObject
@property (nonatomic, strong) NSOperationQueue *queue;
@property (nonatomic, weak) id<WebServiceHandlerDelegate> delegate;


+ (NSURL *)serverURL;

/**
 * 测试网络联通性，请参照路政处理系统完成
 */
+ (BOOL)isServerReachable;

/**
 * 通过指定参数获取一个WebServiceHandler对象，成功状态功过webServiceAuthStatus告知delegate
 * @param serverURL 服务器地址
 * @param userName 用户名
 * @param password 用户密码
 */
+ (instancetype)handlerWithURL:(NSURL *)serverURL userName:(NSString *)userName andPassword:(NSString *)password;

/**
 * 获取当前用户的机构及下属机构信息
 * @param asyncHanlder 异步返回请求结果，orgList包含零个或零个以上OrgInfoModel对象
 * @param orgId
 *            为空时获取当前用户的机构及所有下属机构信息
 */
- (void)getSupervisionLowerOrgList:(NSString *)orgId withAsyncHanlder:(void(^)(NSArray *orgList, NSError *err))asyncHanlder;
/**
 * 获取当前用户的机构及下属机构的所有用户简单信息
 * @param asyncHanlder 异步返回请求结果，orgList包含零个或零个以上OrgInfoModel对象
 * @param containLowerOrg 结果是否包含下属机构信息 1 包含 0 不包含  | zhenlintie  2014-03-26
 */
- (void)getSupervisionOrgUserList:(void(^)(NSArray *userList, NSError *err))asyncHanlder containLowerOrg:(BOOL)shouldContain;

/**
 * 获取当前用户简单信息
 */
- (void)getSupervisionUserInfo:(void(^)(UserInfoSimpleModel *user, NSError *err))asyncHanlder;

/**
 * 获取当前用户的机构信息
 *
 * @param superpassword
 * @param userName
 * @param password
 * @return
 */
- (void)getSupervisionUserOrgInfo:(void(^)(OrgInfoSimpleModel *user, NSError *err))asyncHanlder;

/**
 * 获取许可列表信息
 * @param args 包含所需的参数的NSDictionary对象，该对象的键可以有"orgId"（机构id）,"dateStart"（开始日期）,"dateEnd"（结束日期）,"processId"（许可种类）,containLowerOrg 结果是否包含下属机构信息 1 包含 0 不包含  | zhenlintie  2014-03-26 ,employeeId 人员id，不为空时查询此人同名用户参与过的  | zhenlintie  2014-04-09，注：请根据服务器的实际的要求来确定哪个键必须出现、以及两个日期是否必须结对出现
 * @param asyncHanlder 异步返回请求结果，permitList包含零个或零个以上AllPermitModel对象
 */
- (void)getSupervisionAllPermitList:(NSDictionary *)args withAsyncHanlder:(void(^)(NSArray *permitList, NSError *err))asyncHanlder;

/**
 *获取许可详细信息（实际可以直接调用getSupervisionAllPermitList方法中获取到的Model）
 * @param permitId 许可ID
 * @param asyncHanlder 异步返回请求结果
 */
- (void)getSupervisionPermitInfo:(NSString *)permitId withAsyncHanlder:(void(^)(AllPermitModel *permit, NSError *err))asyncHanlder;


/**
 * 获取指定许可id的附件信息
 * @param permitId 许可ID
 * @param asyncHanlder 异步返回请求结果，attachList包含零个或零个以上ReportAllAttechmentModel对象
 */
- (void)getSupervisionPermitReportAndAttechmentList:(NSString *)permitId withAsyncHanlder:(void(^)(NSArray *attachList, NSError *err))asyncHanlder;;

/**
 * 获取当前待办的许可意见任务
 *
 * @param superpassword
 * @param userName
 * @param password
 * @return
 */
- (void)getSupervisionUserSignTask:(void(^)(NSArray *userSignTaskList, NSError *err))asyncHanlder;

/**
 * 获取控制区信息
 *
 * @param superpassword
 * @param userName
 * @param password
 * @return
 */
//- (void)getSupervisionRoadBuildControlList:(void(^)(NSArray *roadBuildList, NSError *err))asyncHanlder;

/**
 * 获取路线信息
 *
 * @param superpassword
 * @param userName
 * @param password
 * @return
 */
- (void)getSupervisionRoadList:(void(^)(NSMutableArray *roadList, NSError *err))asyncHanlder;


/**
 * 获取案件列表信息....
 * @param superpassword
 * @param userName
 * @param password
 * @param args
 *     @param orgId
             查询的机构id，查询时不包括该机构的下属机构
 *     @param dateStart
             开始日期（时间部分无效）
 *     @param dateEnd
             结束日期（时间部分无效）
 *     @param processId
             案件种类
 *     @param containLowerOrg 
             结果是否包含下属机构信息 1 包含 0 不包含  | zhenlintie  2014-03-26
 *     @param employeeId 人员id，不为空时查询此人同名用户参与过的  | zhenlintie  2014-04-09
 * @return
 */
- (void)getSupervisionAllCaseList:(NSDictionary *)args withAsyncHanlder:(void(^)(NSArray *caseList, NSError *err))asyncHanlder;

/**
 * 获取巡查列表信息
 * @param superpassword
 * @param userName
 * @param password
 * @param args
 *     @param orgId
 *            查询的机构id，查询时不包括该机构的下属机构
 *     @param dateStart
 *            开始日期（形如yyyy-MM-dd，查询时包括这一天）
 *     @param dateEnd
 *            结束日期（形如yyyy-MM-dd，注意：查询时不包括这一天）
 *     @param containLowerOrg
              结果是否包含下属机构信息 1 包含 0 不包含  | zhenlintie  2014-03-26
 *     @param employeeId 
              人员id，不为空时查询此人同名用户参与过的  | zhenlintie  2014-04-09
 * Integer pagenum
 * @return
 */
- (void)getSupervisionAllInspectionList:(NSDictionary *)args withAsyncHanlder:(void(^)(NSArray *inspectionList, NSError *err))asyncHanlder;

/**
 * 获取指定巡查id的详细信息
 * @param superpassword
 * @param userName
 * @param password
 * @param inspectionId
 *            巡查id
 * @return
 */
- (void)getSupervisionInspectionInfo:(NSString *)inspectionId withAsyncHanlder:(void(^)(InspectionModel *inspection, NSError *err))asyncHanlder;


/**
 * 获取巡查文书、附件信息
 *
 * @param superpassword
 * @param userName
 * @param password
 * @param inspectionId
 *            巡查id
 * @return
 */
- (void)getSupervisionInspectionReportAndAttechmentList:(NSString *)inspectionId withAsyncHanlder:(void(^)(NSArray *reportAndAttechmentList, NSError *err))asyncHanlder;
/**
 * 获取占利用档案卡片
 *
 * @param superpassword
 * @param userName
 * @param password
 * @param roadEngrossId
 *            公路占利用id
 * @return
 */
-(void)getSupervisionRoadEngrossReportAndAttechmentList:(NSString *)roadEngrossId withAsyncHanlder:(void (^)(NSString *, NSError *))asyncHanlder;
/**
 * 获取案件详细信息
 *
 * @param superpassword
 * @param userName
 * @param password
 * @param caseId
 *            案件id
 * @return
 */
- (void)getSupervisionCaseInfo:(NSString *)caseId withAsyncHanlder:(void(^)(AllCaseModel *caseModel, NSError *err))asyncHanlder;

/**
 * 获取案件文书、附件信息
 *
 * @param superpassword
 * @param userName
 * @param password
 * @param caseId
 *            案件id
 * @return
 */
- (void)getSupervisionCaseReportAndAttechmentList:(NSString *)caseId withAsyncHanlder:(void(^)(NSArray *reportAndAttechmentList, NSError *err))asyncHanlder;


/**
 * 获取法律法规列表
 *
 * @param superpassword
 * @param userName
 * @param password
 * @return
 */
- (void)getSupervisionLawsList:(void(^)(NSArray *lawsList, NSError *err))asyncHanlder;

/**
 * 获取通知列表
 *
 * @param superpassword
 * @param userName
 * @param password
 * @param pagenum
 *            页码（为空时默认为第1页）
 * @return
 */
- (void)getSupervisionOrgArticleList:(NSString *)pageNum withAsyncHanlder:(void(^)(NSArray *orgArticleList, NSError *err))asyncHanlder;

/**
 * 获取公路占利用信息
 *
 * @param superpassword
 * @param userName
 * @param password
 * @param args
 *     @param orgId appCode roadId station_start station_end item_type pagenum
 *            查询的机构id，查询时不包括该机构的下属机构
 *     @param appCode
 *            许可编号
 *     @param roadId
 *            路线id，参考获取到的RoadModel列表
 *     @param station_start
 *            查询的起始桩号
 *     @param station_end
 *            查询的结束桩号
 *     @param item_type
 *            项目类型
 *     @param pagenum
 *            页码（为空时默认为第1页）
 *     @param containLowerOrg
              结果是否包含下属机构信息 1 包含 0 不包含  | zhenlintie  2014-03-26
 * @return
 */
- (void)getSupervisionRoadEngrossList:(NSDictionary *)args withAsyncHanlder:(void(^)(NSArray *roadEngrossList, NSError *err))asyncHanlder;


/**
 * 获取法律法规明细列表
 *
 * @param superpassword
 * @param userName
 * @param password
 * @param lawId
 *            法律法规id
 * @param pagenum
 *            页码（为空时默认为第1页）
 * @return
 */
- (void)getSupervisionLawItemList:(NSDictionary *)args withAsyncHanlder:(void(^)(NSArray *lawItemsList, NSError *err))asyncHanlder;


/**
 * 获取路政统计汇总数据（当月）
 *
 * @param superpassword
 * @param userName
 * @param password
 * @param orgId
 *            必需参数，查询的机构id，查询时不包括该机构的下属机构
 * @return
 */
- (void)getSupervisionRptStatisticsList:(NSString *)orgId withAsyncHanlder:(void(^)(NSArray *statisticsList, NSError *err))asyncHanlder;


/**
 * 获取路政统计汇总数据（历史数据）
 *
 * @param superpassword
 * @param userName
 * @param password
 * @param orgId
 *            必需参数，查询的机构id，查询时不包括该机构的下属机构
 * @param date
 *            必需参数，查询的月份第一天，形如2013-10-01
 * @return
 */
- (void)getSupervisionRptStatisticsHistoryList:(NSDictionary *)args withAsyncHanlder:(void(^)(NSArray *statisticsList, NSError *err))asyncHanlder;

/**
 * 获取案件列表信息数量
 *
 * @param superpassword
 * @param userName
 * @param password
 * @param args
 *     @param orgId
 *            查询的机构id，查询时不包括该机构的下属机构
 *     @param dateStart
 *            开始日期（形如yyyy-MM-dd，查询时包括这一天）
 *     @param dateEnd
 *            结束日期（形如yyyy-MM-dd，注意：查询时不包括这一天）
 *     @param processId
 *            案件种类
 *     @param containLowerOrg 结果是否包含下属机构信息 1 包含 0 不包含  | zhenlintie  2014-03-26
 *     @param employeeId 人员id，不为空时查询此人同名用户参与过的  | zhenlintie  2014-04-09
 * @return
 */
- (void)getSupervisionAllCaseListSize:(NSDictionary *)args withAsyncHanlder:(void(^)(int listSize, NSError *err))asyncHanlder;

/**
 * 获取巡查列表信息数量
 *
 * @param superpassword
 * @param userName
 * @param password
 * @param args
 *     @param orgId
 *            查询的机构id，查询时不包括该机构的下属机构
 *     @param dateStart
 *            开始日期（形如yyyy-MM-dd，查询时包括这一天）
 *     @param dateEnd
 *            结束日期（形如yyyy-MM-dd，注意：查询时不包括这一天）
 *     @param containLowerOrg 结果是否包含下属机构信息 1 包含 0 不包含  | zhenlintie  2014-03-26
 *     @param employeeId 人员id，不为空时查询此人同名用户参与过的  | zhenlintie  2014-04-09
 * @return
 */
- (void)getSupervisionAllInspectionListSize:(NSDictionary *)args withAsyncHanlder:(void(^)(int inspectionList, NSError *err))asyncHanlder;

/**
 * 获取公路占利用信息数量
 *
 * @param superpassword
 * @param userName
 * @param password
 * @param args
 *     @param orgId
 *            查询的机构id，查询时不包括该机构的下属机构
 *     @param appCode
 *            许可编号
 *     @param roadId
 *            路线id，参考获取到的RoadModel列表
 *     @param station_start
 *            查询的起始桩号
 *     @param station_end
 *            查询的结束桩号
 *     @param item_type
 *            项目类型
 *     @param containLowerOrg 结果是否包含下属机构信息 1 包含 0 不包含  | zhenlintie  2014-03-26
 * @return
 */
- (void)getSupervisionRoadEngrossListSize:(NSDictionary *)args withAsyncHanlder:(void(^)(int roadEngrossList, NSError *err))asyncHanlder;

/**
 * 获取许可列表数量
 *
 * @param superpassword
 * @param userName
 * @param password
 * @param args 参数
 *     @param orgId
 *            查询的机构id，查询时不包括该机构的下属机构
 *     @param dateStart
 *            开始日期（形如yyyy-MM-dd，查询时包括这一天）
 *     @param dateEnd
 *            结束日期（形如yyyy-MM-dd，注意：查询时不包括这一天）
 *     @param processId
 *            许可种类
 *     @param containLowerOrg 结果是否包含下属机构信息 1 包含 0 不包含  | zhenlintie  2014-03-26
 *     @param employeeId 人员id，不为空时查询此人同名用户参与过的  | zhenlintie  2014-04-09
 * @return
 */
- (void)getSupervisionAllPermitListSize:(NSDictionary *)args withAsyncHanlder:(void(^)(int permitList, NSError *err))asyncHanlder;

/**
 * 获取通知列表数量
 *
 * @param superpassword
 * @param userName
 * @param password
 * @return
 */
- (void)getSupervisionOrgArticleListSize:(void(^)(int orgArticleList, NSError *err))asyncHanlder;

/**
 * 获取消息列表数量
 *
 * @param superpassword
 * @param userName
 * @param password
 * @return
 */
- (void)getSupervisionMessageListSize:(void(^)(int messageList, NSError *err))asyncHanlder;

/**
 * 获取法律法规明细列表数量
 *
 * @param superpassword
 * @param userName
 * @param password
 * @param lawId
 *            法律法规id
 * @return
 */
- (void)getSupervisionLawItemListSize:(NSString *)lawId withAsyncHanlder:(void(^)(int lawList, NSError *err))asyncHanlder;

/**
 * 获取消息列表
 *
 * @param superpassword
 * @param userName
 * @param password
 * @param pagenum
 *            页码（为空时默认为第1页）
 * @return
 */
- (void)getSupervisionMessageList:(NSString *)pageNum withAsyncHanlder:(void(^)(NSArray *messageList, NSError *err))asyncHanlder;



/**
 * 发布通知
 *
 * @param superpassword
 * @param userName
 * @param password
 * @param model
 * @return 是否上传成功
 */
-(void)uploadSupervisionOrgArticle:(OrgArticleModel *)orgArticleModel withAsyncHanlder:(void(^)(BOOL flg, NSError *err))asyncHanlder;

/**
 * 发布消息
 *
 * @param superpassword
 * @param userName
 * @param password
 * @param model
 * @return 是否上传成功
 */
-(void)uploadSupervisionMessage:(MessageModel *)messageModel withAsyncHanlder:(void(^)(BOOL flg, NSError *err))asyncHanlder;

/**
 * 获取许可案件流程信息
 *
 * @param superpassword
 * @param userName
 * @param password
 * @param permitId
 *            许可案件id
 * caseID
 * @return
 */
- (void)getSupervisionWorkflowList:(NSString *)permitId withAsyncHanlder:(void(^)(NSArray *taskList, NSError *err))asyncHanlder;

/**
 * 签署意见
 *
 * @param superpassword
 * @param userName
 * @param password
 * @param model
 *            包含了签署的意见信息
 * @return 是否上传成功
 */
-(void)uploadSupervisionSign:(AppSignModel *)appSign withAsyncHanlder:(void(^)(BOOL flg, NSError *err))asyncHanlder;

/**
 * 获取赔补偿标准
 * @param superpassword
 * @param userName
 * @param password
 * @return
 */
- (void)getSupervisionRoadassetPrice:(void(^)(NSArray *roadasset, NSError *err))asyncHanlder;

/**
 * 获取占利用标准
 * @param superpassword
 * @param userName
 * @param password
 * @return
 */
- (void)getSupervisionRoadEngrossPrice:(void(^)(NSArray *roadEngross, NSError *err))asyncHanlder;

/**
 * 获取人员列表
 *
 * @param superpassword
 * @param userName
 * @param password
 * @param orgId
 *            （指定机构，为空时默认用户所在机构） （获取时不包括下属机构的人员）
 * @param pagenum
 *            页码（为空时默认为第1页）
 * @return
 */
- (void)getSupervisionEmployeeInfoList:(NSString *)orgId withAsyncHanlder:(void(^)(NSArray *employeeList, NSError *err))asyncHanlder;

/**
 * 标记通知为已读
 *
 * @param superpassword
 * @param userName
 * @param password
 * @param id 必需，获取到的通知的id
 * @return 是否上报成功
 */
-(void)readSupervisionOrgArticle:(NSString *)orgArticleId withAsyncHanlder:(void(^)(BOOL flg, NSError *err))asyncHanlder;

/**
 * 标记消息为已读
 *
 * @param superpassword
 * @param userName
 * @param password
 * @param id 必需，获取到的消息的id
 * @return 是否上报成功
 */
-(void)readSupervisionMessage:(NSString *)messageId withAsyncHanlder:(void(^)(BOOL flg, NSError *err))asyncHanlder;


-(void)getSupervisionStatisticsNewData:(NSDictionary *)args withAsyncHanlder:(void (^)(NSMutableArray *, NSError *))asyncHanlder;

-(void)getSupervisionStatisticsNewLowerOrgData:(NSDictionary *)args withAsyncHanlder:(void (^)(NSMutableArray *, NSError *))asyncHanlder;
-(void)getSupervisionPermitExpireList:(NSDictionary *)args withAsyncHanlder:(void (^)(NSMutableArray *, NSError *))asyncHanlder;
-(void)getSupervisionPermitExpireSize:(NSDictionary *)args withAsyncHanlder:(void (^)(NSInteger, NSError *))asyncHanlder;
-(void)getSupervisionAppWarningList:(NSDictionary *)args withAsyncHanlder:(void (^)(NSMutableArray *, NSError *))asyncHanlder;
-(void)getSupervisionAppWarningSize:(NSDictionary *)args withAsyncHanlder:(void (^)(NSInteger, NSError *))asyncHanlder;

-(void)getSupervisionOrgUserListBySynchronous:(void (^)(NSArray *, NSError *))asyncHanlder containLowerOrg:(BOOL)shouldContain;
-(void)getSupervisionRoadassetPriceBySynchronous:(void (^)(NSArray *, NSError *))asyncHanlder;
-(void)getSupervisionRoadEngrossPriceBySynchronous:(void (^)(NSArray *, NSError *))asyncHanlder;
-(void)getSupervisionLowerOrgListBySynchronous:(NSString *)orgId withAsyncHanlder:(void (^)(NSArray *, NSError *))asyncHanlder;
@end





@protocol WebServiceHandlerDelegate <NSObject>

- (void)webServiceAuthStatus:(BOOL)success;

@end
