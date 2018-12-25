//
//  WebServiceHandler.m
//  GDZhiFaJianGuanSystem
//
//  Created by XU SHIWEN on 14-2-7.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import "WebServiceHandler.h"
#import "WebServicePacker.h"
#import "DataModelCenter.h"
#import "TBXML.h"
#import "NSString+MyStringProcess.h"
@interface WebServiceHandler()

@property (nonatomic, strong) NSURL *serverURL;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *password;

@property (nonatomic, strong) WebServicePacker *packer;

@end

@implementation WebServiceHandler

+ (instancetype)handlerWithURL:(NSURL *)serverURL userName:(NSString *)userName andPassword:(NSString *)password
{
    WebServiceHandler *newHandler = [[self alloc] init];
    newHandler.serverURL = serverURL;
    newHandler.userName = userName;
    newHandler.password = password;
	newHandler.queue=[[NSOperationQueue alloc]init];
	[newHandler.queue setMaxConcurrentOperationCount:3];
    newHandler.packer = [WebServicePacker packerWithServerURL:serverURL userName:userName andPassword:password];
    return newHandler;
}

+ (NSURL *)serverURL
{
	NSRange range = [[AppDelegate App].serverAddress rangeOfString:SERVICES_LOCATION];
	if (range.location != NSNotFound) {
		return [NSURL URLWithString:[AppDelegate App].serverAddress];
	}
	return [NSURL URLWithString:[[AppDelegate App].serverAddress stringByAppendingFormat:@"%@", SERVICES_LOCATION ]];

//    return [NSURL URLWithString:@"http://222.85.160.25:8080/irmsgz/services/PdaUpload"];
}

/**
 * 获取当前用户的机构及下属机构的所有用户简单信息
 **/
-(void)getSupervisionOrgUserListBySynchronous:(void (^)(NSArray *, NSError *))asyncHanlder containLowerOrg:(BOOL)shouldContain
{
    NSDictionary *params = @{@"isContainLowerOrg":shouldContain?@"1":@"0"};// 1 包含下属机构信息 0 不包含
    NSString *soapBody = [self.packer messageForService:@"getSupervisionOrgUserList" andParams:params];
    
    NSMutableArray * allUserArray = [[NSMutableArray alloc]init];
    
    if (soapBody) {
        [self executeSynchronousWebService:@"getSupervisionOrgUserList" soapBody:soapBody andResultHandler:^(id dataXML, NSError *error) {
            if (error == nil) {
				
                TBXMLElement *xmlElement;
                [(NSValue *)dataXML getValue:&xmlElement];
                if (xmlElement) {
                    
                    TBXMLElement *r1=[TBXML childElementNamed:@"getSupervisionOrgUserListResponse" parentElement:xmlElement];
                    
                    TBXMLElement *r2=[TBXML childElementNamed:@"out" parentElement:r1];
                    
                    if (r2!=nil) {
                        if ([[TBXML valueOfAttributeNamed:@"xsi:nil" forElement:r2] isEqualToString:@"true"] ||
                            [TBXML textForElement:r2] == nil) {
                            
                            NSError * err = [NSError errorWithDomain:@"out is nil" code:0 userInfo:nil];
							
                            asyncHanlder(nil,err);
                        } else {
                            TBXMLElement *r3=[TBXML childElementNamed:@"ns1:UserInfoSimpleModel" parentElement:r2];
                            
                            while (r3) {
                                @autoreleasepool {
                                    NSValue *xmlData = [NSValue value:&r3 withObjCType:@encode(TBXMLElement *)];
                                    
                                    UserInfoSimpleModel * org = [UserInfoSimpleModel newModelFromXML:xmlData];
                                    
                                    [allUserArray addObject:org];
                                    
                                }
                                
                                r3=r3->nextSibling;
                            }
                            
                            asyncHanlder(allUserArray,error);
                        }
                        
                    }else
                    {
                        asyncHanlder(nil,error);
                    }
                    
                    
                }
            } else {
                //分析错误
                //即使分析错误也应该放回nil，而不是返回所谓的"数据为空"
                asyncHanlder(nil,error);
                NSLog(@"SupervisionOrgUserListResponse error  %@",error.description);
            }
        }];
    } else {
        NSLog(@"not found related packer for the service");
		
    }
}

-(void)getSupervisionOrgUserList:(void (^)(NSArray *, NSError *))asyncHanlder containLowerOrg:(BOOL)shouldContain
{
    NSDictionary *params = @{@"isContainLowerOrg":shouldContain?@"1":@"0"};// 1 包含下属机构信息 0 不包含
    NSString *soapBody = [self.packer messageForService:@"getSupervisionOrgUserList" andParams:params];
    
    NSMutableArray * allUserArray = [[NSMutableArray alloc]init];
    
    if (soapBody) {
        [self executeWebService:@"getSupervisionOrgUserList" soapBody:soapBody andResultHandler:^(id dataXML, NSError *error) {
            if (error == nil) {

                TBXMLElement *xmlElement;
                [(NSValue *)dataXML getValue:&xmlElement];
                if (xmlElement) {
                    
                    TBXMLElement *r1=[TBXML childElementNamed:@"getSupervisionOrgUserListResponse" parentElement:xmlElement];
                    
                    TBXMLElement *r2=[TBXML childElementNamed:@"out" parentElement:r1];
                    
                    if (r2!=nil) {
                        if ([[TBXML valueOfAttributeNamed:@"xsi:nil" forElement:r2] isEqualToString:@"true"] ||
                            [TBXML textForElement:r2] == nil) {
                            
                            NSError * err = [NSError errorWithDomain:@"out is nil" code:0 userInfo:nil];
							
                            asyncHanlder(nil,err);
                        } else {
                            TBXMLElement *r3=[TBXML childElementNamed:@"ns1:UserInfoSimpleModel" parentElement:r2];
                            
                            while (r3) {
                                @autoreleasepool {
                                    NSValue *xmlData = [NSValue value:&r3 withObjCType:@encode(TBXMLElement *)];
                                    
                                    UserInfoSimpleModel * org = [UserInfoSimpleModel newModelFromXML:xmlData];
                                    
                                    [allUserArray addObject:org];
                                    
                                }
                                
                                r3=r3->nextSibling;
                            }
                            
                            asyncHanlder(allUserArray,error);
                        }
                        
                    }else
                    {
                        asyncHanlder(nil,error);
                    }
                    
                    
                }
            } else {
                //分析错误
                //即使分析错误也应该放回nil，而不是返回所谓的"数据为空"
                asyncHanlder(nil,error);
                NSLog(@"SupervisionOrgUserListResponse error  %@",error.description);
            }
        }];
    } else {
        NSLog(@"not found related packer for the service");

    }
}
/**
 *获取当前用户简单信息
 */
- (void)getSupervisionUserInfo:(void (^)(UserInfoSimpleModel *, NSError *))asyncHanlder
{
    NSString *soapBody = [self.packer messageForService:@"getSupervisionUserInfo" andParams:nil];
    if (soapBody) {
        [self executeWebService:@"getSupervisionUserInfo" soapBody:soapBody andResultHandler:^(id dataXML, NSError *error) {
            if (error == nil) {
                //解析data，并找出与UserInfoModel对象的XML部分
                TBXMLElement *xmlElement;
                [(NSValue *)dataXML getValue:&xmlElement];
                if (xmlElement) {
                    
                    TBXMLElement *r1=[TBXML childElementNamed:@"getSupervisionUserInfoResponse" parentElement:xmlElement];
                    
                    TBXMLElement *r2=[TBXML childElementNamed:@"out" parentElement:r1];
                    if (r2!=nil) {
                        if ([[TBXML valueOfAttributeNamed:@"xsi:nil" forElement:r2] isEqualToString:@"true"] ||
//                            [[TBXML textForElement:r2] isEqualToString:@""] ||
                            [TBXML textForElement:r2] == nil) {

                            NSError * err = [NSError errorWithDomain:@"out is nil" code:0 userInfo:nil];
                            asyncHanlder(nil,err);
                        } else {
                            NSValue *xmlData = [NSValue value:&r2 withObjCType:@encode(TBXMLElement *)];
                            UserInfoSimpleModel *user = [UserInfoSimpleModel newModelFromXML:xmlData];
                            
                            asyncHanlder(user, error);
                        }
                        
                    }else
                    {
                        asyncHanlder(nil,error);
                    }
                    
                }

            } else {
                //分析错误
                asyncHanlder(NO,error);
                NSLog(@"superVisionUserInfo error  %@",error.description);
            }
        }];
    } else {

        NSLog(@"not found related packer for the service");
    }
    
}

-(void)getSupervisionUserOrgInfo:(void (^)(OrgInfoSimpleModel *, NSError *))asyncHanlder
{
    NSString *soapBody = [self.packer messageForService:@"getSupervisionUserOrgInfo" andParams:nil];
    if (soapBody) {
        [self executeWebService:@"getSupervisionUserOrgInfo" soapBody:soapBody andResultHandler:^(id dataXML, NSError *error) {
            if (error == nil) {
                //解析data，并找出与UserInfoModel对象的XML部分
                TBXMLElement *xmlElement;
                [(NSValue *)dataXML getValue:&xmlElement];
                if (xmlElement) {
                    
                    TBXMLElement *r1=[TBXML childElementNamed:@"getSupervisionUserOrgInfoResponse" parentElement:xmlElement];
                    
                    TBXMLElement *r2=[TBXML childElementNamed:@"out" parentElement:r1];
                    if (r2!=nil) {
                        if ([[TBXML valueOfAttributeNamed:@"xsi:nil" forElement:r2] isEqualToString:@"true"] ||
                            //                            [[TBXML textForElement:r2] isEqualToString:@""] ||
                            [TBXML textForElement:r2] == nil) {
                            
                            NSError * err = [NSError errorWithDomain:@"out is nil" code:0 userInfo:nil];
                            asyncHanlder(nil,err);
                        } else {
                            NSValue *xmlData = [NSValue value:&r2 withObjCType:@encode(TBXMLElement *)];
                            OrgInfoSimpleModel *org = [OrgInfoSimpleModel newModelFromXML:xmlData];
                            
                            asyncHanlder(org, error);
                        }
                        
                    }else
                    {
                        asyncHanlder(nil,error);
                    }
                    
                }
                
            } else {
                //分析错误
                asyncHanlder(NO,error);
                NSLog(@"getSupervisionUserOrgInfo error  %@",error.description);
            }
        }];
    } else {
        
        NSLog(@"not found related packer for the service");
    }
}

/**
 * 获取当前用户的机构及下属机构信息
 * @param asyncHanlder 异步返回请求结果，orgList包含零个或零个以上OrgInfoModel对象
 */
-(void)getSupervisionLowerOrgList:(NSString *)orgId withAsyncHanlder:(void (^)(NSArray *, NSError *))asyncHanlder
{
    NSDictionary * dicTemp = @{@"orgId": orgId};
    
    NSString *soapBody = [self.packer messageForService:@"getSupervisionLowerOrgList" andParams:dicTemp];
    
    NSMutableArray * orgArray = [[NSMutableArray alloc]init];
    
    if (soapBody) {
        [self executeWebService:@"getSupervisionLowerOrgList" soapBody:soapBody andResultHandler:^(id dataXML, NSError *error) {
            if (error == nil) {

                TBXMLElement *xmlElement;
                [(NSValue *)dataXML getValue:&xmlElement];
                if (xmlElement) {
                    
                    TBXMLElement *r1=[TBXML childElementNamed:@"getSupervisionLowerOrgListResponse" parentElement:xmlElement];
                    
                    TBXMLElement *r2=[TBXML childElementNamed:@"out" parentElement:r1];
                    
                    if (r2!=nil) {
                        if ([[TBXML valueOfAttributeNamed:@"xsi:nil" forElement:r2] isEqualToString:@"true"] ||
                            [TBXML textForElement:r2] == nil) {
                            
                            NSError * err = [NSError errorWithDomain:@"out is nil" code:0 userInfo:nil];
                            asyncHanlder(nil,err);
                        } else {
                            
                            TBXMLElement *r3=[TBXML childElementNamed:@"ns1:OrgInfoSimpleModel" parentElement:r2];
                            
                            while (r3) {
                                @autoreleasepool {
                                    NSValue *xmlData = [NSValue value:&r3 withObjCType:@encode(TBXMLElement *)];
                                    
                                    OrgInfoSimpleModel * org = [OrgInfoSimpleModel newModelFromXML:xmlData];
                                    
                                    [orgArray addObject:org];
                                    
                                    
                                }
                                
                                r3=r3->nextSibling;
                            }
                            
                            asyncHanlder(orgArray,error);
                        }
                    }
                }
            } else {
                //分析错误
                asyncHanlder(nil,error);
                NSLog(@"SupervisionLowerOrgListResponse error  %@",error.description);
            }
        }];
    } else {
        
        NSLog(@"not found related packer for the service");
    }
}
-(void)getSupervisionLowerOrgListBySynchronous:(NSString *)orgId withAsyncHanlder:(void (^)(NSArray *, NSError *))asyncHanlder
{
    NSDictionary * dicTemp = @{@"orgId": orgId};
    
    NSString *soapBody = [self.packer messageForService:@"getSupervisionLowerOrgList" andParams:dicTemp];
    
    NSMutableArray * orgArray = [[NSMutableArray alloc]init];
    
    if (soapBody) {
        [self executeSynchronousWebService:@"getSupervisionLowerOrgList" soapBody:soapBody andResultHandler:^(id dataXML, NSError *error) {
            if (error == nil) {
				
                TBXMLElement *xmlElement;
                [(NSValue *)dataXML getValue:&xmlElement];
                if (xmlElement) {
                    
                    TBXMLElement *r1=[TBXML childElementNamed:@"getSupervisionLowerOrgListResponse" parentElement:xmlElement];
                    
                    TBXMLElement *r2=[TBXML childElementNamed:@"out" parentElement:r1];
                    
                    if (r2!=nil) {
                        if ([[TBXML valueOfAttributeNamed:@"xsi:nil" forElement:r2] isEqualToString:@"true"] ||
                            [TBXML textForElement:r2] == nil) {
                            
                            NSError * err = [NSError errorWithDomain:@"out is nil" code:0 userInfo:nil];
                            asyncHanlder(nil,err);
                        } else {
                            
                            TBXMLElement *r3=[TBXML childElementNamed:@"ns1:OrgInfoSimpleModel" parentElement:r2];
                            
                            while (r3) {
                                @autoreleasepool {
                                    NSValue *xmlData = [NSValue value:&r3 withObjCType:@encode(TBXMLElement *)];
                                    
                                    OrgInfoSimpleModel * org = [OrgInfoSimpleModel newModelFromXML:xmlData];
                                    
                                    [orgArray addObject:org];
                                    
                                    
                                }
                                
                                r3=r3->nextSibling;
                            }
                            
                            asyncHanlder(orgArray,error);
                        }
                    }
                }
            } else {
                //分析错误
                asyncHanlder(nil,error);
                NSLog(@"SupervisionLowerOrgListResponse error  %@",error.description);
            }
        }];
    } else {
        
        NSLog(@"not found related packer for the service");
    }
}

/**
 * 获取当前待办的许可意见任务
 *
 */
-(void)getSupervisionUserSignTask:(void (^)(NSArray *, NSError *))asyncHanlder
{
    NSString *soapBody = [self.packer messageForService:@"getSupervisionUserSignTask" andParams:nil];
    
    NSMutableArray * currentTaskArray = [[NSMutableArray alloc]init];
    
    if (soapBody) {
        [self executeWebService:@"getSupervisionUserSignTask" soapBody:soapBody andResultHandler:^(id dataXML, NSError *error) {
            if (error == nil) {

                TBXMLElement *xmlElement;
                [(NSValue *)dataXML getValue:&xmlElement];
                if (xmlElement) {
                    
                    TBXMLElement *r1=[TBXML childElementNamed:@"getSupervisionUserSignTaskResponse" parentElement:xmlElement];
                    
                    TBXMLElement *r2=[TBXML childElementNamed:@"out" parentElement:r1];
                    
                    if (r2!=nil) {
                        if ([[TBXML valueOfAttributeNamed:@"xsi:nil" forElement:r2] isEqualToString:@"true"] ||
                            [TBXML textForElement:r2] == nil) {
                            
                            NSError * err = [NSError errorWithDomain:@"out is nil" code:0 userInfo:nil];
                            asyncHanlder(nil,err);
                        } else {
                            
                            TBXMLElement *r3=[TBXML childElementNamed:@"ns1:CurrentTaskModel" parentElement:r2];
                            
                            while (r3) {
                                @autoreleasepool {
                                    NSValue *xmlData = [NSValue value:&r3 withObjCType:@encode(TBXMLElement *)];
                                    
                                    CurrentTaskModel * currentTask = [CurrentTaskModel newModelFromXML:xmlData];
                                    
                                    [currentTaskArray addObject:currentTask];
                                    
                                    
                                }
                                
                                r3=r3->nextSibling;
                            }
                            
                            asyncHanlder(currentTaskArray,error);
                        }
                    }
                }
            } 
        }];
    } else {
        NSLog(@"not found related packer for the service");
    }
}

/**
 * 获取路线信息
 */
-(void)getSupervisionRoadList:(void (^)(NSMutableArray *, NSError *))asyncHanlder
{
    NSString *soapBody = [self.packer messageForService:@"getSupervisionRoadList" andParams:nil];
    
    NSMutableArray * roadModelArray = [[NSMutableArray alloc]init];
    
    if (soapBody) {
        [self executeWebService:@"getSupervisionRoadList" soapBody:soapBody andResultHandler:^(id dataXML, NSError *error) {
            if (error == nil) {

                TBXMLElement *xmlElement;
                [(NSValue *)dataXML getValue:&xmlElement];
                if (xmlElement) {
                    
                    TBXMLElement *r1=[TBXML childElementNamed:@"getSupervisionRoadListResponse" parentElement:xmlElement];
                    
                    TBXMLElement *r2=[TBXML childElementNamed:@"out" parentElement:r1];
                    
                    if (r2!=nil) {
                        if ([[TBXML valueOfAttributeNamed:@"xsi:nil" forElement:r2] isEqualToString:@"true"] ||
                            [TBXML textForElement:r2] == nil) {
                            
                            NSError * err = [NSError errorWithDomain:@"out is nil" code:0 userInfo:nil];
                            asyncHanlder(nil,err);
                        } else {
                            TBXMLElement *r3=[TBXML childElementNamed:@"ns1:RoadModel" parentElement:r2];
                            
                            while (r3) {
                                @autoreleasepool {
                                    NSValue *xmlData = [NSValue value:&r3 withObjCType:@encode(TBXMLElement *)];
                                    
                                    RoadModel * road = [RoadModel newModelFromXML:xmlData];
                                    
                                    [roadModelArray addObject:road];
                                    
                                    
                                }
                                
                                r3=r3->nextSibling;
                            }
                            
                            asyncHanlder(roadModelArray,error);
                            
                        }
                    }
                }
            } else {
                //分析错误
                //即使分析错误也应该放回nil，而不是返回所谓的"数据为空"
                asyncHanlder(nil,error);
                NSLog(@"SupervisionRoadListResponse error  %@",error.description);
            }
        }];
    } else {
        NSLog(@"not found related packer for the service");
    }
}

/**
 * 获取许可列表
 */
- (void)getSupervisionAllPermitList:(NSDictionary *)args withAsyncHanlder:(void (^)(NSArray *, NSError *))asyncHanlder
{
    NSString *soapBody = [self.packer messageForService:@"getSupervisionAllPermitList" andParams:args];
    
    NSMutableArray * allPermitArray = [[NSMutableArray alloc]init];
    
    if (soapBody) {
        [self executeWebService:@"getSupervisionAllPermitList" soapBody:soapBody andResultHandler:^(id dataXML, NSError *error) {
            //解析data，并生成CoreData对象
            
            if (error == nil) {

                TBXMLElement *xmlElement;
                [(NSValue *)dataXML getValue:&xmlElement];
                if (xmlElement) {
                    
                    TBXMLElement *r1=[TBXML childElementNamed:@"getSupervisionAllPermitListResponse" parentElement:xmlElement];
                    
                    TBXMLElement *r2=[TBXML childElementNamed:@"out" parentElement:r1];
                    
                    if (r2!=nil) {
                        if ([[TBXML valueOfAttributeNamed:@"xsi:nil" forElement:r2] isEqualToString:@"true"] ||
                            [TBXML textForElement:r2] == nil) {
                            
                            NSError * err = [NSError errorWithDomain:@"out is nil" code:0 userInfo:nil];
                            asyncHanlder(nil,err);
                        } else {
                            
                            TBXMLElement *r3=[TBXML childElementNamed:@"ns1:AllPermitModel" parentElement:r2];
                            
                            while (r3) {
                                @autoreleasepool {
                                    NSValue *xmlData = [NSValue value:&r3 withObjCType:@encode(TBXMLElement *)];
                                    
                                    AllPermitModel * allPermit = [AllPermitModel newModelFromXML:xmlData];
                                    
                                    [allPermitArray addObject:allPermit];
                                    
                                    
                                }
                                
                                r3=r3->nextSibling;
                            }
                            
                            asyncHanlder(allPermitArray,error);
                        }
                    }
                    
                }
            } else {
                //分析错误
                //即使分析错误也应该放回nil，而不是返回所谓的"数据为空"
                asyncHanlder(nil,error);
                NSLog(@"SupervisionAllPermitListResponse error  %@",error.description);
            }
        }];
    } else {
        NSLog(@"not found related packer for the service");
    }
}

/**
 * 获取许可详细信息
 **/
-(void)getSupervisionPermitInfo:(NSString *)permitId withAsyncHanlder:(void (^)(AllPermitModel *, NSError *))asyncHanlder
{
    NSDictionary * dicTemp = @{@"permitId": permitId};
    
    NSString *soapBody = [self.packer messageForService:@"getSupervisionPermitInfo" andParams:dicTemp];
    if (soapBody) {
        [self executeWebService:@"getSupervisionPermitInfo" soapBody:soapBody andResultHandler:^(id dataXML, NSError *error) {
            if (error == nil) {
                //解析data，并找出与UserInfoModel对象的XML部分
                TBXMLElement *xmlElement;
                [(NSValue *)dataXML getValue:&xmlElement];
                if (xmlElement) {
                    
                    TBXMLElement *r1=[TBXML childElementNamed:@"getSupervisionPermitInfoResponse" parentElement:xmlElement];
                    
                    TBXMLElement *r2=[TBXML childElementNamed:@"out" parentElement:r1];
                    
                    if (r2!=nil) {
                        if ([[TBXML valueOfAttributeNamed:@"xsi:nil" forElement:r2] isEqualToString:@"true"] ||
                            [TBXML textForElement:r2] == nil) {
                            
                            NSError * err = [NSError errorWithDomain:@"out is nil" code:0 userInfo:nil];
                            asyncHanlder(nil,err);
                        } else {
                            
                            NSValue *xmlData = [NSValue value:&r2 withObjCType:@encode(TBXMLElement *)];
                            AllPermitModel *permit = [AllPermitModel newModelFromXML:xmlData];
                            
                            asyncHanlder(permit, error);
                        }
                    }
                    
                }
                
                
            } else {
                //分析错误
                asyncHanlder(nil,error);
                NSLog(@"superVisionUserInfo error  %@",error.description);
            }
        }];
    } else {
        NSLog(@"not found related packer for the service");
    }
}

/**
 * 获取许可文书、附件信息
 **/
-(void)getSupervisionPermitReportAndAttechmentList:(NSString *)permitId withAsyncHanlder:(void (^)(NSArray *, NSError *))asyncHanlder
{
    NSDictionary * dicTemp = @{@"permitId": permitId};
    
    NSString *soapBody = [self.packer messageForService:@"getSupervisionPermitReportAndAttechmentList" andParams:dicTemp];
    
    NSMutableArray * attechArray = [[NSMutableArray alloc]init];
    
    if (soapBody) {
        [self executeWebService:@"getSupervisionPermitReportAndAttechmentList" soapBody:soapBody andResultHandler:^(id dataXML, NSError *error) {
            if (error == nil) {

                TBXMLElement *xmlElement;
                [(NSValue *)dataXML getValue:&xmlElement];
                if (xmlElement) {
                    
                    TBXMLElement *r1=[TBXML childElementNamed:@"getSupervisionPermitReportAndAttechmentListResponse" parentElement:xmlElement];
                    
                    TBXMLElement *r2=[TBXML childElementNamed:@"out" parentElement:r1];
                    
                    if (r2!=nil) {
                        if ([[TBXML valueOfAttributeNamed:@"xsi:nil" forElement:r2] isEqualToString:@"true"] ||
                            [TBXML textForElement:r2] == nil) {
                            
                            NSError * err = [NSError errorWithDomain:@"out is nil" code:0 userInfo:nil];
                            asyncHanlder(nil,err);
                        } else {
                            TBXMLElement *r3=[TBXML childElementNamed:@"ns1:ReportAndAttechmentModel" parentElement:r2];
                            
                            while (r3) {
                                @autoreleasepool {
                                    NSValue *xmlData = [NSValue value:&r3 withObjCType:@encode(TBXMLElement *)];
                                    
                                    ReportAndAttechmentModel * road = [ReportAndAttechmentModel newModelFromXML:xmlData];
                                    
                                    [attechArray addObject:road];
                                    
                                    
                                }
                                
                                r3=r3->nextSibling;
                            }
                            
                            asyncHanlder(attechArray,error);
                        }
                    }
                }
            } else {
                //分析错误
                //即使分析错误也应该放回nil，而不是返回所谓的"数据为空"
                asyncHanlder(nil,error);
                NSLog(@"SupervisionRoadListResponse error  %@",error.description);
            }
        }];
    } else {

        NSLog(@"not found related packer for the service");
    }
}

/**
 * 获取案件列表信息
 */
-(void)getSupervisionAllCaseList:(NSDictionary *)args withAsyncHanlder:(void (^)(NSArray *, NSError *))asyncHanlder
{
    NSString *soapBody = [self.packer messageForService:@"getSupervisionAllCaseList" andParams:args];
    
    NSMutableArray * caseInfoArray = [[NSMutableArray alloc]init];
    
    if (soapBody) {
        [self executeWebService:@"getSupervisionAllCaseList" soapBody:soapBody andResultHandler:^(id dataXML, NSError *error) {
            //解析data，并生成CoreData对象
            
            if (error == nil) {
                
                TBXMLElement *xmlElement;
                [(NSValue *)dataXML getValue:&xmlElement];
                if (xmlElement) {
                    
                    TBXMLElement *r1=[TBXML childElementNamed:@"getSupervisionAllCaseListResponse" parentElement:xmlElement];
                    
                    TBXMLElement *r2=[TBXML childElementNamed:@"out" parentElement:r1];
                    
                    if (r2!=nil) {
                        if ([[TBXML valueOfAttributeNamed:@"xsi:nil" forElement:r2] isEqualToString:@"true"] ||
                            [TBXML textForElement:r2] == nil) {
                            
                            NSError * err = [NSError errorWithDomain:@"out is nil" code:0 userInfo:nil];
                            asyncHanlder(nil,err);
                        } else {
                            
                            TBXMLElement *r3=[TBXML childElementNamed:@"ns1:AllCaseModel" parentElement:r2];
                            
                            while (r3) {
                                @autoreleasepool {
                                    NSValue *xmlData = [NSValue value:&r3 withObjCType:@encode(TBXMLElement *)];
                                    
                                    AllCaseModel * caseInfo = [AllCaseModel newModelFromXML:xmlData];
                                    
                                    [caseInfoArray addObject:caseInfo];
                                    
                                    
                                }
                                
                                r3=r3->nextSibling;
                            }
                            
                            asyncHanlder(caseInfoArray,error);
                        }
                    }
                    
                }
            } else {
                //分析错误
				//即使分析错误也应该放回nil，而不是返回所谓的"数据为空"
                asyncHanlder(nil,error);
                NSLog(@"SupervisionAllCaseListResponse error  %@",error.description);
            }
        }];
    } else {
        NSLog(@"not found related packer for the service");
    }
}

/**
 * 获取案件详细信息
 */
-(void)getSupervisionCaseInfo:(NSString *)caseId withAsyncHanlder:(void (^)(AllCaseModel *, NSError *))asyncHanlder
{
    NSDictionary * dicTemp = @{@"caseId": caseId};
    
    NSString *soapBody = [self.packer messageForService:@"getSupervisionCaseInfo" andParams:dicTemp];
    if (soapBody) {
        [self executeWebService:@"getSupervisionCaseInfo" soapBody:soapBody andResultHandler:^(id dataXML, NSError *error) {
            if (error == nil) {
                //解析data，并找出与UserInfoModel对象的XML部分
                TBXMLElement *xmlElement;
                [(NSValue *)dataXML getValue:&xmlElement];
                if (xmlElement) {
                    
                    TBXMLElement *r1=[TBXML childElementNamed:@"getSupervisionCaseInfoResponse" parentElement:xmlElement];
                    
                    TBXMLElement *r2=[TBXML childElementNamed:@"out" parentElement:r1];
                    
                    if (r2!=nil) {
                        if ([[TBXML valueOfAttributeNamed:@"xsi:nil" forElement:r2] isEqualToString:@"true"] ||
                            [TBXML textForElement:r2] == nil) {
                            
                            NSError * err = [NSError errorWithDomain:@"out is nil" code:0 userInfo:nil];
                            asyncHanlder(nil,err);
                        } else {
                            NSValue *xmlData = [NSValue value:&r2 withObjCType:@encode(TBXMLElement *)];
                            
                            AllCaseModel *caseModel = [AllCaseModel newModelFromXML:xmlData];
                            
                            asyncHanlder(caseModel, error);
                        }
                    }
                    
                }
                
                
            } else {
                //分析错误
                asyncHanlder(Nil,error);
                NSLog(@"superVisionUserInfo error  %@",error.description);
            }
        }];
    } else {
        NSLog(@"not found related packer for the service");
    }
}

/**
 * 获取案件文书、附件信息
 **/
-(void)getSupervisionCaseReportAndAttechmentList:(NSString *)caseId withAsyncHanlder:(void (^)(NSArray *, NSError *))asyncHanlder
{
    NSDictionary * dicTemp = @{@"caseId": caseId};
    
    NSString *soapBody = [self.packer messageForService:@"getSupervisionCaseReportAndAttechmentList" andParams:dicTemp];
    
    NSMutableArray * caseReportArray = [[NSMutableArray alloc]init];
    
    if (soapBody) {
        [self executeWebService:@"getSupervisionCaseReportAndAttechmentList" soapBody:soapBody andResultHandler:^(id dataXML, NSError *error) {
            //解析data，并生成CoreData对象
            
            if (error == nil) {
                
                TBXMLElement *xmlElement;
                [(NSValue *)dataXML getValue:&xmlElement];
                if (xmlElement) {
                    
                    TBXMLElement *r1=[TBXML childElementNamed:@"getSupervisionCaseReportAndAttechmentListResponse" parentElement:xmlElement];
                    
                    TBXMLElement *r2=[TBXML childElementNamed:@"out" parentElement:r1];
                    
                    
                    if (r2!=nil) {
                        if ([[TBXML valueOfAttributeNamed:@"xsi:nil" forElement:r2] isEqualToString:@"true"] ||
                            [TBXML textForElement:r2] == nil) {
                            
                            NSError * err = [NSError errorWithDomain:@"out is nil" code:0 userInfo:nil];
                            asyncHanlder(nil,err);
                        } else {
                            
                            TBXMLElement *r3=[TBXML childElementNamed:@"ns1:ReportAndAttechmentModel" parentElement:r2];
                            
                            while (r3) {
                                @autoreleasepool {
                                    NSValue *xmlData = [NSValue value:&r3 withObjCType:@encode(TBXMLElement *)];
                                    
                                    ReportAndAttechmentModel * caseReport = [ReportAndAttechmentModel newModelFromXML:xmlData];
                                    
                                    [caseReportArray addObject:caseReport];
                                    
                                    
                                }
                                
                                r3=r3->nextSibling;
                            }
                            
                            asyncHanlder(caseReportArray,error);
                        }
                    }
                    
                }
            } else {
                //分析错误
                //即使分析错误也应该放回nil，而不是返回所谓的"数据为空"
                asyncHanlder(nil,error);
                NSLog(@"SupervisionCaseReportAndAttechmentListResponse error  %@",error.description);
            }
        }];
    } else {
        NSLog(@"not found related packer for the service");
    }
}

/**
 * 获取巡查列表信息
 */
-(void)getSupervisionAllInspectionList:(NSDictionary *)args withAsyncHanlder:(void (^)(NSArray *, NSError *))asyncHanlder
{
    NSString *soapBody = [self.packer messageForService:@"getSupervisionAllInspectionList" andParams:args];
    
    NSMutableArray * inspectionArray = [[NSMutableArray alloc]init];
    
    if (soapBody) {
        [self executeWebService:@"getSupervisionAllInspectionList" soapBody:soapBody andResultHandler:^(id dataXML, NSError *error) {
            //解析data，并生成CoreData对象
            
            if (error == nil) {
                
                TBXMLElement *xmlElement;
                [(NSValue *)dataXML getValue:&xmlElement];
                if (xmlElement) {
                    
                    TBXMLElement *r1=[TBXML childElementNamed:@"getSupervisionAllInspectionListResponse" parentElement:xmlElement];
                    
                    TBXMLElement *r2=[TBXML childElementNamed:@"out" parentElement:r1];
                    
                    
                    if (r2!=nil) {
                        if ([[TBXML valueOfAttributeNamed:@"xsi:nil" forElement:r2] isEqualToString:@"true"] ||
                            [TBXML textForElement:r2] == nil) {
                            
                            NSError * err = [NSError errorWithDomain:@"out is nil" code:0 userInfo:nil];
                            asyncHanlder(nil,err);
                        } else {
                            TBXMLElement *r3=[TBXML childElementNamed:@"ns1:InspectionModel" parentElement:r2];
                            
                            while (r3) {
                                @autoreleasepool {
                                    NSValue *xmlData = [NSValue value:&r3 withObjCType:@encode(TBXMLElement *)];
                                    
                                    InspectionModel * inspection = [InspectionModel newModelFromXML:xmlData];
                                    
                                    [inspectionArray addObject:inspection];
                                    
                                }
                                
                                r3=r3->nextSibling;
                            }
                            asyncHanlder(inspectionArray,error);
                        }
                    }
                    
                }
            } else {
                //分析错误
                //即使分析错误也应该放回nil，而不是返回所谓的"数据为空"
                asyncHanlder(nil,error);
                NSLog(@"getSupervisionAllInspectionListResponse error  %@",error.description);
            }
        }];
    } else {
        NSLog(@"not found related packer for the service");
    }
}

/**
 * 获取法律法规列表
 */
-(void)getSupervisionLawsList:(void (^)(NSArray *, NSError *))asyncHanlder
{
    NSString *soapBody = [self.packer messageForService:@"getSupervisionLawsList" andParams:nil];
    
    NSMutableArray * lawsArray = [[NSMutableArray alloc]init];
    
    if (soapBody) {
        [self executeWebService:@"getSupervisionLawsList" soapBody:soapBody andResultHandler:^(id dataXML, NSError *error) {
            if (error == nil) {

                TBXMLElement *xmlElement;
                [(NSValue *)dataXML getValue:&xmlElement];
                if (xmlElement) {
                    
                    TBXMLElement *r1=[TBXML childElementNamed:@"getSupervisionLawsListResponse" parentElement:xmlElement];
                    
                    TBXMLElement *r2=[TBXML childElementNamed:@"out" parentElement:r1];
                    
                    if (r2!=nil) {
                        if ([[TBXML valueOfAttributeNamed:@"xsi:nil" forElement:r2] isEqualToString:@"true"] ||
                            [TBXML textForElement:r2] == nil) {
                            
                            NSError * err = [NSError errorWithDomain:@"out is nil" code:0 userInfo:nil];
                            asyncHanlder(nil,err);
                        } else {
                            
                            TBXMLElement *r3=[TBXML childElementNamed:@"ns1:LawsModel" parentElement:r2];
                            
                            while (r3) {
                                @autoreleasepool {
                                    NSValue *xmlData = [NSValue value:&r3 withObjCType:@encode(TBXMLElement *)];
                                    
                                    LawsModel * laws = [LawsModel newModelFromXML:xmlData];
                                    
                                    [lawsArray addObject:laws];
                                    
                                    
                                }
                                
                                r3=r3->nextSibling;
                            }
                            
                            asyncHanlder(lawsArray,error);
                        }
                    }
                    
                }
            } else {
                //分析错误
                //即使分析错误也应该放回nil，而不是返回所谓的"数据为空"
                asyncHanlder(nil,error);
                NSLog(@"getSupervisionLawsListResponse error  %@",error.description);
            }
        }];
    } else {
        NSLog(@"not found related packer for the service");
    }
}

-(void)getSupervisionRoadassetPrice:(void (^)(NSArray *, NSError *))asyncHanlder
{
    NSString *soapBody = [self.packer messageForService:@"getSupervisionRoadassetPrice" andParams:nil];
    
    NSMutableArray * lawsArray = [[NSMutableArray alloc]init];
    
    if (soapBody) {
        [self executeWebService:@"getSupervisionRoadassetPrice" soapBody:soapBody andResultHandler:^(id dataXML, NSError *error) {
            if (error == nil) {

                TBXMLElement *xmlElement;
                [(NSValue *)dataXML getValue:&xmlElement];
                if (xmlElement) {
                    
                    TBXMLElement *r1=[TBXML childElementNamed:@"getSupervisionRoadassetPriceResponse" parentElement:xmlElement];
                    
                    TBXMLElement *r2=[TBXML childElementNamed:@"out" parentElement:r1];
                    
                    if (r2!=nil) {
                        if ([[TBXML valueOfAttributeNamed:@"xsi:nil" forElement:r2] isEqualToString:@"true"] ||
                            [TBXML textForElement:r2] == nil) {
                            
                            NSError * err = [NSError errorWithDomain:@"out is nil" code:0 userInfo:nil];
                            asyncHanlder(nil,err);
                        } else {
                            
                            TBXMLElement *r3=[TBXML childElementNamed:@"ns1:RoadAssetPriceModel" parentElement:r2];
                            
                            while (r3) {
                                @autoreleasepool {
                                    NSValue *xmlData = [NSValue value:&r3 withObjCType:@encode(TBXMLElement *)];
                                    
                                    RoadAssetPriceModel * laws = [RoadAssetPriceModel newModelFromXML:xmlData];
                                    
                                    [lawsArray addObject:laws];
                                    
                                    
                                }
                                
                                r3=r3->nextSibling;
                            }
                            
                            asyncHanlder(lawsArray,error);
                        }
                    }
                    
                }
            } else {
                //分析错误
                //即使分析错误也应该放回nil，而不是返回所谓的"数据为空"
                asyncHanlder(nil,error);
                NSLog(@"getSupervisionLawsListResponse error  %@",error.description);
            }
        }];
    } else {
        NSLog(@"not found related packer for the service");
    }
}
-(void)getSupervisionRoadassetPriceBySynchronous:(void (^)(NSArray *, NSError *))asyncHanlder
{
    NSString *soapBody = [self.packer messageForService:@"getSupervisionRoadassetPrice" andParams:nil];
    
    NSMutableArray * lawsArray = [[NSMutableArray alloc]init];
    
    if (soapBody) {
        [self executeSynchronousWebService:@"getSupervisionRoadassetPrice" soapBody:soapBody andResultHandler:^(id dataXML, NSError *error) {
            if (error == nil) {
				
                TBXMLElement *xmlElement;
                [(NSValue *)dataXML getValue:&xmlElement];
                if (xmlElement) {
                    
                    TBXMLElement *r1=[TBXML childElementNamed:@"getSupervisionRoadassetPriceResponse" parentElement:xmlElement];
                    
                    TBXMLElement *r2=[TBXML childElementNamed:@"out" parentElement:r1];
                    
                    if (r2!=nil) {
                        if ([[TBXML valueOfAttributeNamed:@"xsi:nil" forElement:r2] isEqualToString:@"true"] ||
                            [TBXML textForElement:r2] == nil) {
                            
                            NSError * err = [NSError errorWithDomain:@"out is nil" code:0 userInfo:nil];
                            asyncHanlder(nil,err);
                        } else {
                            
                            TBXMLElement *r3=[TBXML childElementNamed:@"ns1:RoadAssetPriceModel" parentElement:r2];
                            
                            while (r3) {
                                @autoreleasepool {
                                    NSValue *xmlData = [NSValue value:&r3 withObjCType:@encode(TBXMLElement *)];
                                    
                                    RoadAssetPriceModel * laws = [RoadAssetPriceModel newModelFromXML:xmlData];
                                    
                                    [lawsArray addObject:laws];
                                    
                                    
                                }
                                
                                r3=r3->nextSibling;
                            }
                            
                            asyncHanlder(lawsArray,error);
                        }
                    }
                    
                }
            } else {
                //分析错误
                //即使分析错误也应该放回nil，而不是返回所谓的"数据为空"
                asyncHanlder(nil,error);
                NSLog(@"getSupervisionLawsListResponse error  %@",error.description);
            }
        }];
    } else {
        NSLog(@"not found related packer for the service");
    }
}
-(void)getSupervisionRoadEngrossPrice:(void (^)(NSArray *, NSError *))asyncHanlder
{
    NSString *soapBody = [self.packer messageForService:@"getSupervisionRoadEngrossPrice" andParams:nil];
    
    NSMutableArray * lawsArray = [[NSMutableArray alloc]init];
    
    if (soapBody) {
        [self executeWebService:@"getSupervisionRoadEngrossPrice" soapBody:soapBody andResultHandler:^(id dataXML, NSError *error) {
            if (error == nil) {
                
                TBXMLElement *xmlElement;
                [(NSValue *)dataXML getValue:&xmlElement];
                if (xmlElement) {
                    
                    TBXMLElement *r1=[TBXML childElementNamed:@"getSupervisionRoadEngrossPriceResponse" parentElement:xmlElement];
                    
                    TBXMLElement *r2=[TBXML childElementNamed:@"out" parentElement:r1];
                    
                    if (r2!=nil) {
                        if ([[TBXML valueOfAttributeNamed:@"xsi:nil" forElement:r2] isEqualToString:@"true"] ||
                            [TBXML textForElement:r2] == nil) {
                            
                            NSError * err = [NSError errorWithDomain:@"out is nil" code:0 userInfo:nil];
                            asyncHanlder(nil,err);
                        } else {
                            
                            TBXMLElement *r3=[TBXML childElementNamed:@"ns1:RoadEngrossPriceModel" parentElement:r2];
                            
                            while (r3) {
                                @autoreleasepool {
                                    NSValue *xmlData = [NSValue value:&r3 withObjCType:@encode(TBXMLElement *)];
                                    
                                    RoadEngrossPriceModel * laws = [RoadEngrossPriceModel newModelFromXML:xmlData];
                                    
                                    [lawsArray addObject:laws];

                                }
                                
                                r3=r3->nextSibling;
                            }
                            
                            asyncHanlder(lawsArray,error);
                        }
                    }
                    
                }
            } else {
                //分析错误
                //即使分析错误也应该放回nil，而不是返回所谓的"数据为空"
                asyncHanlder(nil,error);
                NSLog(@"RoadEngrossPriceModel error  %@",error.description);
            }
        }];
    } else {
        NSLog(@"not found related packer for the service");
    }
}
-(void)getSupervisionRoadEngrossPriceBySynchronous:(void (^)(NSArray *, NSError *))asyncHanlder
{
    NSString *soapBody = [self.packer messageForService:@"getSupervisionRoadEngrossPrice" andParams:nil];
    
    NSMutableArray * lawsArray = [[NSMutableArray alloc]init];
    
    if (soapBody) {
        [self executeSynchronousWebService:@"getSupervisionRoadEngrossPrice" soapBody:soapBody andResultHandler:^(id dataXML, NSError *error) {
            if (error == nil) {
                
                TBXMLElement *xmlElement;
                [(NSValue *)dataXML getValue:&xmlElement];
                if (xmlElement) {
                    
                    TBXMLElement *r1=[TBXML childElementNamed:@"getSupervisionRoadEngrossPriceResponse" parentElement:xmlElement];
                    
                    TBXMLElement *r2=[TBXML childElementNamed:@"out" parentElement:r1];
                    
                    if (r2!=nil) {
                        if ([[TBXML valueOfAttributeNamed:@"xsi:nil" forElement:r2] isEqualToString:@"true"] ||
                            [TBXML textForElement:r2] == nil) {
                            
                            NSError * err = [NSError errorWithDomain:@"out is nil" code:0 userInfo:nil];
                            asyncHanlder(nil,err);
                        } else {
                            
                            TBXMLElement *r3=[TBXML childElementNamed:@"ns1:RoadEngrossPriceModel" parentElement:r2];
                            
                            while (r3) {
                                @autoreleasepool {
                                    NSValue *xmlData = [NSValue value:&r3 withObjCType:@encode(TBXMLElement *)];
                                    
                                    RoadEngrossPriceModel * laws = [RoadEngrossPriceModel newModelFromXML:xmlData];
                                    
                                    [lawsArray addObject:laws];
									
                                }
                                
                                r3=r3->nextSibling;
                            }
                            
                            asyncHanlder(lawsArray,error);
                        }
                    }
                    
                }
            } else {
                //分析错误
                //即使分析错误也应该放回nil，而不是返回所谓的"数据为空"
                asyncHanlder(nil,error);
                NSLog(@"RoadEngrossPriceModel error  %@",error.description);
            }
        }];
    } else {
        NSLog(@"not found related packer for the service");
    }
}

/**
 * 获取通知列表
 **/
-(void)getSupervisionOrgArticleList:(NSString *)pageNum withAsyncHanlder:(void (^)(NSArray *, NSError *))asyncHanlder
{
    NSDictionary * dicTemp = nil;
    
    if (pageNum!=nil) {
        dicTemp = @{@"pageNum": pageNum};
    }

    NSString *soapBody = [self.packer messageForService:@"getSupervisionOrgArticleList" andParams:dicTemp];
    
    NSMutableArray * orgArticleArray = [[NSMutableArray alloc]init];
    
    if (soapBody) {
        [self executeWebService:@"getSupervisionOrgArticleList" soapBody:soapBody andResultHandler:^(id dataXML, NSError *error) {
            //解析data，并生成CoreData对象
            
            if (error == nil) {
                
                TBXMLElement *xmlElement;
                [(NSValue *)dataXML getValue:&xmlElement];
                if (xmlElement) {
                    
                    TBXMLElement *r1=[TBXML childElementNamed:@"getSupervisionOrgArticleListResponse" parentElement:xmlElement];
                    
                    TBXMLElement *r2=[TBXML childElementNamed:@"out" parentElement:r1];
                    
                    if (r2!=nil) {
                        if ([[TBXML valueOfAttributeNamed:@"xsi:nil" forElement:r2] isEqualToString:@"true"] ||
                            [TBXML textForElement:r2] == nil) {
                            
                            NSError * err = [NSError errorWithDomain:@"out is nil" code:0 userInfo:nil];
                            asyncHanlder(nil,err);
                        } else {
                            TBXMLElement *r3=[TBXML childElementNamed:@"ns1:OrgArticleModel" parentElement:r2];
                            
                            while (r3) {
                                @autoreleasepool {
                                    NSValue *xmlData = [NSValue value:&r3 withObjCType:@encode(TBXMLElement *)];
                                    
                                    OrgArticleModel * orgArticle = [OrgArticleModel newModelFromXML:xmlData];
                                    
                                    [orgArticleArray addObject:orgArticle];
                                    
                                    
                                }
                                
                                r3=r3->nextSibling;
                            }
                            
                            asyncHanlder(orgArticleArray,error);
                            
                        }
                    }
                    
                }
            } else {
                //分析错误
                //即使分析错误也应该放回nil，而不是返回所谓的"数据为空"
                asyncHanlder(nil,error);
                NSLog(@"getSupervisionOrgArticleList error  %@",error.description);
            }
        }];
    } else {
        NSLog(@"not found related packer for the service");
    }
}

/**
 * 获取公路占利用信息
 **/
-(void)getSupervisionRoadEngrossList:(NSDictionary *)args withAsyncHanlder:(void (^)(NSArray *, NSError *))asyncHanlder
{
    NSString *soapBody = [self.packer messageForService:@"getSupervisionRoadEngrossList" andParams:args];
    
    NSMutableArray * roadEngrossArray = [[NSMutableArray alloc]init];
    
    if (soapBody) {
        [self executeWebService:@"getSupervisionRoadEngrossList" soapBody:soapBody andResultHandler:^(id dataXML, NSError *error) {
            //解析data，并生成CoreData对象
            
            if (error == nil) {
                
                TBXMLElement *xmlElement;
                [(NSValue *)dataXML getValue:&xmlElement];
                if (xmlElement) {
                    
                    TBXMLElement *r1=[TBXML childElementNamed:@"getSupervisionRoadEngrossListResponse" parentElement:xmlElement];
                    
                    TBXMLElement *r2=[TBXML childElementNamed:@"out" parentElement:r1];
                    
                    if (r2!=nil) {
                        if ([[TBXML valueOfAttributeNamed:@"xsi:nil" forElement:r2] isEqualToString:@"true"] ||
                            [TBXML textForElement:r2] == nil) {
                            
                            NSError * err = [NSError errorWithDomain:@"out is nil" code:0 userInfo:nil];
                            asyncHanlder(nil,err);
                        } else {
                            TBXMLElement *r3=[TBXML childElementNamed:@"ns1:RoadEngrossModel" parentElement:r2];
                            
                            while (r3) {
                                @autoreleasepool {
                                    NSValue *xmlData = [NSValue value:&r3 withObjCType:@encode(TBXMLElement *)];
                                    
                                    RoadEngrossModel * roadEngross = [RoadEngrossModel newModelFromXML:xmlData];
                                    
                                    [roadEngrossArray addObject:roadEngross];
                                    
                                    
                                }
                                
                                r3=r3->nextSibling;
                            }
                            
                            asyncHanlder(roadEngrossArray,error);
                        }
                    }
                    
                }
            } else {
                //分析错误
                //即使分析错误也应该放回nil，而不是返回所谓的"数据为空"
                asyncHanlder(nil,error);
                NSLog(@"getSupervisionRoadEngrossList error  %@",error.description);
            }
        }];
    } else {
        NSLog(@"not found related packer for the service");
    }
}

/**
 * 获取法律法规明细列表
 */
-(void)getSupervisionLawItemList:(NSDictionary *)args withAsyncHanlder:(void (^)(NSArray *, NSError *))asyncHanlder
{
    NSString *soapBody = [self.packer messageForService:@"getSupervisionLawItemList" andParams:args];
    
     NSMutableArray * lawInfoArray = [[NSMutableArray alloc]init];
    
    if (soapBody) {
        [self executeWebService:@"getSupervisionLawItemList" soapBody:soapBody andResultHandler:^(id dataXML, NSError *error) {
            //解析data，并生成CoreData对象
            
            if (error == nil) {
                
                TBXMLElement *xmlElement;
                [(NSValue *)dataXML getValue:&xmlElement];
                if (xmlElement) {
                    
                    TBXMLElement *r1=[TBXML childElementNamed:@"getSupervisionLawItemListResponse" parentElement:xmlElement];
                    
                    TBXMLElement *r2=[TBXML childElementNamed:@"out" parentElement:r1];
                    
                    if (r2!=nil) {
                        if ([[TBXML valueOfAttributeNamed:@"xsi:nil" forElement:r2] isEqualToString:@"true"] ||
                            [TBXML textForElement:r2] == nil) {
                            
                            NSError * err = [NSError errorWithDomain:@"out is nil" code:0 userInfo:nil];
                            asyncHanlder(nil,err);
                        } else {
                            TBXMLElement *r3=[TBXML childElementNamed:@"ns1:LawItemsModel" parentElement:r2];
                            
                            while (r3) {
                                @autoreleasepool {
                                    NSValue *xmlData = [NSValue value:&r3 withObjCType:@encode(TBXMLElement *)];
                                    
                                    LawItemsModel * lawInfo = [LawItemsModel newModelFromXML:xmlData];
                                    
                                    [lawInfoArray addObject:lawInfo];
                                    
                                    
                                }
                                
                                r3=r3->nextSibling;
                            }
                            
                            asyncHanlder(lawInfoArray,error);
                        }
                    }
                    
                }
            } else {
                //分析错误
                //即使分析错误也应该放回nil，而不是返回所谓的"数据为空"
                asyncHanlder(nil,error);
                NSLog(@"getSupervisionLawItemList error  %@",error.description);
            }
        }];
    } else {
        NSLog(@"not found related packer for the service");
    }
}

/**
 * 获取路政统计汇总数据（当月）
 */
-(void)getSupervisionRptStatisticsList:(NSString *)orgId withAsyncHanlder:(void (^)(NSArray *, NSError *))asyncHanlder
{
    if (!orgId) {
        orgId=@"";
    }
    NSDictionary * dicTemp = @{@"orgId": orgId};
    
    NSString *soapBody = [self.packer messageForService:@"getSupervisionRptStatisticsList" andParams:dicTemp];
    
    NSMutableArray * statisticsArray = [[NSMutableArray alloc]init];
    
    if (soapBody) {
        [self executeWebService:@"getSupervisionRptStatisticsList" soapBody:soapBody andResultHandler:^(id dataXML, NSError *error) {
            //解析data，并生成CoreData对象
            
            if (error == nil) {
                
                TBXMLElement *xmlElement;
                [(NSValue *)dataXML getValue:&xmlElement];
                if (xmlElement) {
                    
                    TBXMLElement *r1=[TBXML childElementNamed:@"getSupervisionRptStatisticsListResponse" parentElement:xmlElement];
                    
                    TBXMLElement *r2=[TBXML childElementNamed:@"out" parentElement:r1];
                    
                    if (r2!=nil) {
                        if ([[TBXML valueOfAttributeNamed:@"xsi:nil" forElement:r2] isEqualToString:@"true"] ||
                            [TBXML textForElement:r2] == nil) {
                            
                            NSError * err = [NSError errorWithDomain:@"out is nil" code:0 userInfo:nil];
                            asyncHanlder(nil,err);
                        } else {
                            TBXMLElement *r3=[TBXML childElementNamed:@"ns1:Rpt_statisticsModel" parentElement:r2];
                            
                            while (r3) {
                                @autoreleasepool {
                                    NSValue *xmlData = [NSValue value:&r3 withObjCType:@encode(TBXMLElement *)];
                                    
                                    Rpt_statisticsModel * statistics = [Rpt_statisticsModel newModelFromXML:xmlData];
                                    
                                    [statisticsArray addObject:statistics];
                                    
                                    
                                }
                                
                                r3=r3->nextSibling;
                            }
                            asyncHanlder(statisticsArray,error);
                        }
                    }
                    
                }
            } else {
                //分析错误
                //即使分析错误也应该放回nil，而不是返回所谓的"数据为空"
                asyncHanlder(nil,error);
                NSLog(@"getSupervisionRptStatisticsList error  %@",error.description);
            }
        }];
    } else {
        NSLog(@"not found related packer for the service");
    }
}

/**
 * 获取巡查详细信息
 */
-(void)getSupervisionInspectionInfo:(NSString *)inspectionId withAsyncHanlder:(void (^)(InspectionModel *, NSError *))asyncHanlder
{
    NSDictionary * dicTemp = @{@"inspectionId": inspectionId};
    
    NSString *soapBody = [self.packer messageForService:@"getSupervisionInspectionInfo" andParams:dicTemp];
    if (soapBody) {
        [self executeWebService:@"getSupervisionInspectionInfo" soapBody:soapBody andResultHandler:^(id dataXML, NSError *error) {
            if (error == nil) {
                //解析data，并找出与UserInfoModel对象的XML部分
                TBXMLElement *xmlElement;
                [(NSValue *)dataXML getValue:&xmlElement];
                if (xmlElement) {
                    
                    TBXMLElement *r1=[TBXML childElementNamed:@"getSupervisionInspectionInfoResponse" parentElement:xmlElement];
                    
                    TBXMLElement *r2=[TBXML childElementNamed:@"out" parentElement:r1];
                    
                    if (r2!=nil) {
                        if ([[TBXML valueOfAttributeNamed:@"xsi:nil" forElement:r2] isEqualToString:@"true"] ||
                            [TBXML textForElement:r2] == nil) {
                            
                            NSError * err = [NSError errorWithDomain:@"out is nil" code:0 userInfo:nil];
                            asyncHanlder(nil,err);
                        } else {
                            
                            NSValue *xmlData = [NSValue value:&r2 withObjCType:@encode(TBXMLElement *)];
                            
                            InspectionModel *inspection = [InspectionModel newModelFromXML:xmlData];
                            
                            asyncHanlder(inspection, error);
                        }
                    }
                    
                }
                
                
            } else {
                //分析错误
                asyncHanlder(nil,error);
                NSLog(@"getSupervisionInspectionInfo error  %@",error.description);
            }
        }];
    } else {
        NSLog(@"not found related packer for the service");
    }
}

/**
 *获取巡查文书、附件信息
 */
-(void)getSupervisionInspectionReportAndAttechmentList:(NSString *)inspectionId withAsyncHanlder:(void (^)(NSArray *, NSError *))asyncHanlder
{
    NSDictionary * dicTemp = @{@"inspectionId": inspectionId};
    
    NSString *soapBody = [self.packer messageForService:@"getSupervisionInspectionReportAndAttechmentList" andParams:dicTemp];
    
    NSMutableArray * inspectionReportArray = [[NSMutableArray alloc]init];
    
    if (soapBody) {
        [self executeWebService:@"getSupervisionInspectionReportAndAttechmentList" soapBody:soapBody andResultHandler:^(id dataXML, NSError *error) {
            //解析data，并生成CoreData对象
            
            if (error == nil) {
                
                TBXMLElement *xmlElement;
                [(NSValue *)dataXML getValue:&xmlElement];
                if (xmlElement) {
                    
                    TBXMLElement *r1=[TBXML childElementNamed:@"getSupervisionInspectionReportAndAttechmentListResponse" parentElement:xmlElement];
                    
                    TBXMLElement *r2=[TBXML childElementNamed:@"out" parentElement:r1];
                    
                    if (r2!=nil) {
                        if ([[TBXML valueOfAttributeNamed:@"xsi:nil" forElement:r2] isEqualToString:@"true"] ||
                            [TBXML textForElement:r2] == nil) {
                            
                            NSError * err = [NSError errorWithDomain:@"out is nil" code:0 userInfo:nil];
                            asyncHanlder(nil,err);
                        } else {
                            TBXMLElement *r3=[TBXML childElementNamed:@"ns1:ReportAndAttechmentModel" parentElement:r2];
                            
                            while (r3) {
                                @autoreleasepool {
                                    NSValue *xmlData = [NSValue value:&r3 withObjCType:@encode(TBXMLElement *)];
                                    
                                    ReportAndAttechmentModel * inspectionReport = [ReportAndAttechmentModel newModelFromXML:xmlData];
                                    
                                    [inspectionReportArray addObject:inspectionReport];
                                    
                                    
                                }
                                
                                r3=r3->nextSibling;
                            }
                            asyncHanlder(inspectionReportArray,error);
                        }
                    }
                    
                }
            } else {
                //分析错误
                //即使分析错误也应该放回nil，而不是返回所谓的"数据为空"
                asyncHanlder(nil,error);
                NSLog(@"getSupervisionInspectionReportAndAttechmentList error  %@",error.description);
            }
        }];
    } else {
        NSLog(@"not found related packer for the service");
    }
}


/**
 *获取占利用档案卡片
 */
-(void)getSupervisionRoadEngrossReportAndAttechmentList:(NSString *)roadEngrossId withAsyncHanlder:(void (^)(NSString *, NSError *))asyncHanlder
{
    NSDictionary * dicTemp = @{@"roadEngrossId": roadEngrossId};
    
    NSString *soapBody = [self.packer messageForService:@"getSupervisionRoadEngrossReportAndAttechmentList" andParams:dicTemp];
    
	__block NSString * url;
    
    if (soapBody) {
        [self executeWebService:@"getSupervisionRoadEngrossReportAndAttechmentList" soapBody:soapBody andResultHandler:^(id dataXML, NSError *error) {
            //解析data，并生成CoreData对象
            
            if (error == nil) {
                
                TBXMLElement *xmlElement;
                [(NSValue *)dataXML getValue:&xmlElement];
                if (xmlElement) {
                    
                    TBXMLElement *r1=[TBXML childElementNamed:@"getSupervisionRoadEngrossReportAndAttechmentListResponse" parentElement:xmlElement];
                    
                    TBXMLElement *r2=[TBXML childElementNamed:@"out" parentElement:r1];
                    
                    if (r2!=nil) {
                        if ([[TBXML valueOfAttributeNamed:@"xsi:nil" forElement:r2] isEqualToString:@"true"] ||
                            [TBXML textForElement:r2] == nil) {
                            
                            NSError * err = [NSError errorWithDomain:@"out is nil" code:0 userInfo:nil];
                            asyncHanlder(nil,err);
                        } else {
                            TBXMLElement *r3=[TBXML childElementNamed:@"url" parentElement:r2];
                            url = [TBXML textForElement:r3];
                            asyncHanlder(url,error);
                        }
                    }
                    
                }
            } else {
                //分析错误
                //即使分析错误也应该放回nil，而不是返回所谓的"数据为空"
                asyncHanlder(nil,error);
                NSLog(@"getSupervisionRoadEngrossReportAndAttechmentList error  %@",error.description);
            }
        }];
    } else {
        NSLog(@"not found related packer for the service");
    }
}
/**
 * 获取路政统计汇总数据（历史数据）
 */
-(void)getSupervisionRptStatisticsHistoryList:(NSDictionary *)args withAsyncHanlder:(void (^)(NSArray *, NSError *))asyncHanlder
{
    NSString *soapBody = [self.packer messageForService:@"getSupervisionRptStatisticsHistoryList" andParams:args];
    
    NSMutableArray * statisHisArray = [[NSMutableArray alloc]init];
    
    if (soapBody) {
        [self executeWebService:@"getSupervisionRptStatisticsHistoryList" soapBody:soapBody andResultHandler:^(id dataXML, NSError *error) {
            //解析data，并生成CoreData对象
            
            if (error == nil) {
                
                TBXMLElement *xmlElement;
                [(NSValue *)dataXML getValue:&xmlElement];
                if (xmlElement) {
                    
                    TBXMLElement *r1=[TBXML childElementNamed:@"getSupervisionRptStatisticsHistoryListResponse" parentElement:xmlElement];
                    
                    TBXMLElement *r2=[TBXML childElementNamed:@"out" parentElement:r1];
                    
                    if (r2!=nil) {
                        if ([[TBXML valueOfAttributeNamed:@"xsi:nil" forElement:r2] isEqualToString:@"true"] ||
                            [TBXML textForElement:r2] == nil) {
                            
                            NSError * err = [NSError errorWithDomain:@"out is nil" code:0 userInfo:nil];
                            asyncHanlder(nil,err);
                        } else {
                            TBXMLElement *r3=[TBXML childElementNamed:@"ns1:Rpt_statisticsModel" parentElement:r2];
                            
                            while (r3) {
                                @autoreleasepool {
                                    NSValue *xmlData = [NSValue value:&r3 withObjCType:@encode(TBXMLElement *)];
                                    
                                    Rpt_statisticsModel * statisHis = [Rpt_statisticsModel newModelFromXML:xmlData];
                                    
                                    [statisHisArray addObject:statisHis];
                                    
                                    
                                }
                                
                                r3=r3->nextSibling;
                            }
                            
                            asyncHanlder(statisHisArray,error);
                        }
                    }
                    
                }
            } else {
                //分析错误
                //即使分析错误也应该放回nil，而不是返回所谓的"数据为空"
                asyncHanlder(nil,error);
                NSLog(@"getSupervisionRptStatisticsHistoryList error  %@",error.description);
            }
        }];
    } else {
        NSLog(@"not found related packer for the service");
    }
}

/**
 * 获取案件列表信息数量
 */
-(void)getSupervisionAllCaseListSize:(NSDictionary *)args withAsyncHanlder:(void (^)(int, NSError *))asyncHanlder
{
    
    NSString *soapBody = [self.packer messageForService:@"getSupervisionAllCaseListSize" andParams:args];
    if (soapBody) {
        [self executeWebService:@"getSupervisionAllCaseListSize" soapBody:soapBody andResultHandler:^(id dataXML, NSError *error) {
            if (error == nil) {
                //解析data，并找出与UserInfoModel对象的XML部分
                TBXMLElement *xmlElement;
                [(NSValue *)dataXML getValue:&xmlElement];
                if (xmlElement) {
                    
                    TBXMLElement *r1=[TBXML childElementNamed:@"getSupervisionAllCaseListSizeResponse" parentElement:xmlElement];
                    
                    TBXMLElement *r2=[TBXML childElementNamed:@"out" parentElement:r1];
                    
                    if (r2!=nil) {
                        if ([[TBXML valueOfAttributeNamed:@"xsi:nil" forElement:r2] isEqualToString:@"true"] ||
                            [TBXML textForElement:r2] == nil) {
                            
                            NSError * err = [NSError errorWithDomain:@"out is nil" code:0 userInfo:nil];
                            asyncHanlder(0,err);
                        } else {
                            NSString * listSize = [TBXML textForElement:r2];
                            
                            asyncHanlder([listSize intValue], error);
                        }
                    }
                    
                }
                
                
            } else {
                //分析错误
                asyncHanlder(0,error);
                NSLog(@"getSupervisionAllCaseListSize error  %@",error.description);
            }
        }];
    } else {
        NSLog(@"not found related packer for the service");
    }
}

/**
 * 获取巡查列表信息数量
 **/
-(void)getSupervisionAllInspectionListSize:(NSDictionary *)args withAsyncHanlder:(void (^)(int, NSError *))asyncHanlder
{
    NSString *soapBody = [self.packer messageForService:@"getSupervisionAllInspectionListSize" andParams:args];
    if (soapBody) {
        [self executeWebService:@"getSupervisionAllInspectionListSize" soapBody:soapBody andResultHandler:^(id dataXML, NSError *error) {
            if (error == nil) {
                //解析data，并找出与UserInfoModel对象的XML部分
                TBXMLElement *xmlElement;
                [(NSValue *)dataXML getValue:&xmlElement];
                if (xmlElement) {
                    
                    TBXMLElement *r1=[TBXML childElementNamed:@"getSupervisionAllInspectionListSizeResponse" parentElement:xmlElement];
                    
                    TBXMLElement *r2=[TBXML childElementNamed:@"out" parentElement:r1];
                    
                    if (r2!=nil) {
                        if ([[TBXML valueOfAttributeNamed:@"xsi:nil" forElement:r2] isEqualToString:@"true"] ||
                            [TBXML textForElement:r2] == nil) {
                            
                            NSError * err = [NSError errorWithDomain:@"out is nil" code:0 userInfo:nil];
                            asyncHanlder(0,err);
                        } else {
                            NSString * listSize = [TBXML textForElement:r2];
                            
                            asyncHanlder([listSize intValue], error);
                        }
                    }
                    
                }
                
                
            } else {
                //分析错误
                asyncHanlder(0,error);
                NSLog(@"getSupervisionAllInspectionListSize error  %@",error.description);
            }
        }];
    } else {
        NSLog(@"not found related packer for the service");
    }
}

/**
 * 获取公路占利用信息数量
 ***/
-(void)getSupervisionRoadEngrossListSize:(NSDictionary *)args withAsyncHanlder:(void (^)(int, NSError *))asyncHanlder
{
    NSString *soapBody = [self.packer messageForService:@"getSupervisionRoadEngrossListSize" andParams:args];
    if (soapBody) {
        [self executeWebService:@"getSupervisionRoadEngrossListSize" soapBody:soapBody andResultHandler:^(id dataXML, NSError *error) {
            if (error == nil) {
                //解析data，并找出与UserInfoModel对象的XML部分
                TBXMLElement *xmlElement;
                [(NSValue *)dataXML getValue:&xmlElement];
                if (xmlElement) {
                    
                    TBXMLElement *r1=[TBXML childElementNamed:@"getSupervisionRoadEngrossListSizeResponse" parentElement:xmlElement];
                    
                    TBXMLElement *r2=[TBXML childElementNamed:@"out" parentElement:r1];
                    
                    if (r2!=nil) {
                        if ([[TBXML valueOfAttributeNamed:@"xsi:nil" forElement:r2] isEqualToString:@"true"] ||
                            [TBXML textForElement:r2] == nil) {
                            
                            NSError * err = [NSError errorWithDomain:@"out is nil" code:0 userInfo:nil];
                            asyncHanlder(0,err);
                        } else {
                            NSString * listSize = [TBXML textForElement:r2];
                            
                            asyncHanlder([listSize intValue], error);
                        }
                    }
                    
                }
                
                
            } else {
                //分析错误
                asyncHanlder(nil,error);
                NSLog(@"getSupervisionRoadEngrossListSize error  %@",error.description);
            }
        }];
    } else {
        NSLog(@"not found related packer for the service");
    }
}

/**
 * 获取许可列表数量
 **/
-(void)getSupervisionAllPermitListSize:(NSDictionary *)args withAsyncHanlder:(void (^)(int, NSError *))asyncHanlder
{
    NSString *soapBody = [self.packer messageForService:@"getSupervisionAllPermitListSize" andParams:args];
    if (soapBody) {
        [self executeWebService:@"getSupervisionAllPermitListSize" soapBody:soapBody andResultHandler:^(id dataXML, NSError *error) {
            if (error == nil) {
                //解析data，并找出与UserInfoModel对象的XML部分
                TBXMLElement *xmlElement;
                [(NSValue *)dataXML getValue:&xmlElement];
                if (xmlElement) {
                    
                    TBXMLElement *r1=[TBXML childElementNamed:@"getSupervisionAllPermitListSizeResponse" parentElement:xmlElement];
                    
                    TBXMLElement *r2=[TBXML childElementNamed:@"out" parentElement:r1];
                    
                    if (r2!=nil) {
                        if ([[TBXML valueOfAttributeNamed:@"xsi:nil" forElement:r2] isEqualToString:@"true"] ||
                            [TBXML textForElement:r2] == nil) {
                            
                            NSError * err = [NSError errorWithDomain:@"out is nil" code:0 userInfo:nil];
                            asyncHanlder(0,err);
                        } else {
                            NSString * listSize = [TBXML textForElement:r2];
                            
                            asyncHanlder([listSize intValue], error);
                        }
                    }
                    
                }
                
                
            } else {
                //分析错误
                asyncHanlder(0,error);
                NSLog(@"getSupervisionAllPermitListSize error  %@",error.description);
            }
        }];
    } else {
        NSLog(@"not found related packer for the service");
    }
}

-(void)getSupervisionOrgArticleListSize:(void (^)(int, NSError *))asyncHanlder
{
    NSString *soapBody = [self.packer messageForService:@"getSupervisionOrgArticleListSize" andParams:nil];
    if (soapBody) {
        [self executeWebService:@"getSupervisionOrgArticleListSize" soapBody:soapBody andResultHandler:^(id dataXML, NSError *error) {
            if (error == nil) {
                //解析data，并找出与UserInfoModel对象的XML部分
                TBXMLElement *xmlElement;
                [(NSValue *)dataXML getValue:&xmlElement];
                if (xmlElement) {
                    
                    TBXMLElement *r1=[TBXML childElementNamed:@"getSupervisionOrgArticleListSizeResponse" parentElement:xmlElement];
                    
                    TBXMLElement *r2=[TBXML childElementNamed:@"out" parentElement:r1];
                    
                    if (r2!=nil) {
                        if ([[TBXML valueOfAttributeNamed:@"xsi:nil" forElement:r2] isEqualToString:@"true"] ||
                            [TBXML textForElement:r2] == nil) {
                            
                            NSError * err = [NSError errorWithDomain:@"out is nil" code:0 userInfo:nil];
                            asyncHanlder(0,err);
                        } else {
                            NSString * listSize = [TBXML textForElement:r2];
                            
                            asyncHanlder([listSize intValue], error);
                        }
                    }
                    
                }
                
                
            } else {
                //分析错误
                asyncHanlder(0,error);
                NSLog(@"getSupervisionOrgArticleListSize error  %@",error.description);
            }
        }];
    } else {
        NSLog(@"not found related packer for the service");
    }
}

-(void)getSupervisionMessageListSize:(void (^)(int, NSError *))asyncHanlder
{
    NSString *soapBody = [self.packer messageForService:@"getSupervisionMessageListSize" andParams:nil];
    if (soapBody) {
        [self executeWebService:@"getSupervisionMessageListSize" soapBody:soapBody andResultHandler:^(id dataXML, NSError *error) {
            if (error == nil) {
                //解析data，并找出与UserInfoModel对象的XML部分
                TBXMLElement *xmlElement;
                [(NSValue *)dataXML getValue:&xmlElement];
                if (xmlElement) {
                    
                    TBXMLElement *r1=[TBXML childElementNamed:@"getSupervisionMessageListSizeResponse" parentElement:xmlElement];
                    
                    TBXMLElement *r2=[TBXML childElementNamed:@"out" parentElement:r1];
                    
                    if (r2!=nil) {
                        if ([[TBXML valueOfAttributeNamed:@"xsi:nil" forElement:r2] isEqualToString:@"true"] ||
                            [TBXML textForElement:r2] == nil) {
                            
                            NSError * err = [NSError errorWithDomain:@"out is nil" code:0 userInfo:nil];
                            asyncHanlder(0,err);
                        } else {
                            NSString * listSize = [TBXML textForElement:r2];
                            
                            asyncHanlder([listSize intValue], error);
                        }
                    }
                    
                }
                
                
            } else {
                //分析错误
                
                NSLog(@"getSupervisionMessageListSize error  %@",error.description);
            }
        }];
    } else {
        NSLog(@"not found related packer for the service");
    }
}

/**
 * 获取法律法规明细列表数量
 **/
-(void)getSupervisionLawItemListSize:(NSString *)lawId withAsyncHanlder:(void (^)(int, NSError *))asyncHanlder
{
    NSDictionary * dicTemp = @{@"lawId": lawId};
    
    NSString *soapBody = [self.packer messageForService:@"getSupervisionLawItemListSize" andParams:dicTemp];
    
    if (soapBody) {
        [self executeWebService:@"getSupervisionLawItemListSize" soapBody:soapBody andResultHandler:^(id dataXML, NSError *error) {
            if (error == nil) {
                //解析data，并找出与UserInfoModel对象的XML部分
                TBXMLElement *xmlElement;
                [(NSValue *)dataXML getValue:&xmlElement];
                if (xmlElement) {
                    
                    TBXMLElement *r1=[TBXML childElementNamed:@"getSupervisionLawItemListSizeResponse" parentElement:xmlElement];
                    
                    TBXMLElement *r2=[TBXML childElementNamed:@"out" parentElement:r1];
                    
                    if (r2!=nil) {
                        if ([[TBXML valueOfAttributeNamed:@"xsi:nil" forElement:r2] isEqualToString:@"true"] ||
                            [TBXML textForElement:r2] == nil) {
                            
                            NSError * err = [NSError errorWithDomain:@"out is nil" code:0 userInfo:nil];
                            asyncHanlder(0,err);
                        } else {
                            NSString * listSize = [TBXML textForElement:r2];
                            
                            asyncHanlder([listSize intValue], error);
                        }
                    }
                    
                }
                
            } else {
                //分析错误
                
                NSLog(@"getSupervisionLawItemListSize error  %@",error.description);
            }
        }];
    } else {
        NSLog(@"not found related packer for the service");
    }
}

/**
 * 获取消息列表
 **/
-(void)getSupervisionMessageList:(NSString *)pageNum withAsyncHanlder:(void (^)(NSArray *, NSError *))asyncHanlder
{
    NSDictionary * dicTemp = nil;
    
    if (pageNum!=nil) {
        dicTemp = @{@"pageNum": pageNum};
    }
    
    NSString *soapBody = [self.packer messageForService:@"getSupervisionMessageList" andParams:dicTemp];
    
    NSMutableArray * messageArray = [[NSMutableArray alloc]init];
    
    if (soapBody) {
        [self executeWebService:@"getSupervisionMessageList" soapBody:soapBody andResultHandler:^(id dataXML, NSError *error) {
            //解析data，并生成CoreData对象
            
            if (error == nil) {
                
                TBXMLElement *xmlElement;
                [(NSValue *)dataXML getValue:&xmlElement];
                if (xmlElement) {
                    
                    TBXMLElement *r1=[TBXML childElementNamed:@"getSupervisionMessageListResponse" parentElement:xmlElement];
                    
                    TBXMLElement *r2=[TBXML childElementNamed:@"out" parentElement:r1];
                    
                    if (r2!=nil) {
                        if ([[TBXML valueOfAttributeNamed:@"xsi:nil" forElement:r2] isEqualToString:@"true"] ||
                            [TBXML textForElement:r2] == nil) {
                            
                            NSError * err = [NSError errorWithDomain:@"out is nil" code:0 userInfo:nil];
                            asyncHanlder(0,err);
                        } else {
                            TBXMLElement *r3=[TBXML childElementNamed:@"ns1:MessageModel" parentElement:r2];
                            
                            while (r3) {
                                @autoreleasepool {
                                    NSValue *xmlData = [NSValue value:&r3 withObjCType:@encode(TBXMLElement *)];
                                    
                                    MessageModel * message = [MessageModel newModelFromXML:xmlData];
                                    
                                    [messageArray addObject:message];
                                    
                                }
                                
                                r3=r3->nextSibling;
                            }
                            
                            asyncHanlder(messageArray,error);
                        }
                    }
                    
                }
            } else {
                //分析错误
                //即使分析错误也应该放回nil，而不是返回所谓的"数据为空"
                asyncHanlder(nil,error);
                NSLog(@"getSupervisionMessageList error  %@",error.description);
            }
        }];
    } else {
        NSLog(@"not found related packer for the service");
    }
}

/**
 * 获取人员列表
 **/
-(void)getSupervisionEmployeeInfoList:(NSDictionary *)args withAsyncHanlder:(void (^)(NSArray *, NSError *))asyncHanlder
{

        
    NSString *soapBody = [self.packer messageForService:@"getSupervisionEmployeeInfoList" andParams:args];
    
    NSMutableArray * employeeArray = [[NSMutableArray alloc]init];
    
    if (soapBody) {
        [self executeWebService:@"getSupervisionEmployeeInfoList" soapBody:soapBody andResultHandler:^(id dataXML, NSError *error) {
            //解析data，并生成CoreData对象
            
            if (error == nil) {
                
                TBXMLElement *xmlElement;
                [(NSValue *)dataXML getValue:&xmlElement];
                if (xmlElement) {
                    
                    TBXMLElement *r1=[TBXML childElementNamed:@"getSupervisionEmployeeInfoListResponse" parentElement:xmlElement];
                    
                    TBXMLElement *r2=[TBXML childElementNamed:@"out" parentElement:r1];
                    
                    if (r2!=nil) {
                        if ([[TBXML valueOfAttributeNamed:@"xsi:nil" forElement:r2] isEqualToString:@"true"] ||
                            [TBXML textForElement:r2] == nil) {
                            
                            NSError * err = [NSError errorWithDomain:@"out is nil" code:0 userInfo:nil];
                            asyncHanlder(0,err);
                        } else {
                            TBXMLElement *r3=[TBXML childElementNamed:@"ns1:EmployeeInfoModel" parentElement:r2];
                            
                            while (r3) {
                                @autoreleasepool {
                                    NSValue *xmlData = [NSValue value:&r3 withObjCType:@encode(TBXMLElement *)];
                                    
                                    EmployeeInfoModel * employee = [EmployeeInfoModel newModelFromXML:xmlData];
                                    
                                    [employeeArray addObject:employee];
                                    
                                }
                                
                                r3=r3->nextSibling;
                            }
                            
                            asyncHanlder(employeeArray,error);
                        }
                    }
                    
                }
            } else {
                //分析错误
                //即使分析错误也应该放回nil，而不是返回所谓的"数据为空"
                asyncHanlder(nil,error);
                NSLog(@"getSupervisionEmployeeInfoList error  %@",error.description);
            }
        }];
    } else {
        NSLog(@"not found related packer for the service");
    }
}

-(void)uploadSupervisionOrgArticle:(OrgArticleModel *)orgArticleModel withAsyncHanlder:(void (^)(BOOL, NSError *))asyncHanlder
{
    NSString *orgArticleString = self.packer.formXMLElementForObj(orgArticleModel, @"proj",3);

    NSDictionary * dicTemp = @{@"orgArticleModel": orgArticleString};
    
    NSString *soapBody = [self.packer messageForService:@"uploadSupervisionOrgArticle" andParams:dicTemp];
    
    if (soapBody) {
        [self executeWebService:@"uploadSupervisionOrgArticle" soapBody:soapBody andResultHandler:^(id dataXML, NSError *error) {
            if (error == nil) {
                //解析data，并找出与UserInfoModel对象的XML部分
                TBXMLElement *xmlElement;
                [(NSValue *)dataXML getValue:&xmlElement];
                if (xmlElement) {
                    
                    TBXMLElement *r1=[TBXML childElementNamed:@"uploadSupervisionOrgArticleResponse" parentElement:xmlElement];
                    
                    TBXMLElement *r2=[TBXML childElementNamed:@"out" parentElement:r1];
                    
                    if (r2!=nil) {
                        if ([[TBXML valueOfAttributeNamed:@"xsi:nil" forElement:r2] isEqualToString:@"true"] ||
                            [TBXML textForElement:r2] == nil) {
                            
                            NSError * err = [NSError errorWithDomain:@"out is nil" code:0 userInfo:nil];
                            asyncHanlder(0,err);
                        } else {
                            NSString * result = [TBXML textForElement:r2];
                            
                            asyncHanlder(result.boolValue, error);
                        }
                    }
                    
                }
                
            } else {
                //分析错误
                
                NSLog(@"uploadSupervisionOrgArticleResponse error  %@",error.description);
            }
        }];
    }
}

-(void)uploadSupervisionMessage:(MessageModel *)messageModel withAsyncHanlder:(void (^)(BOOL, NSError *))asyncHanlder
{
    NSString *messageString = self.packer.formXMLElementForObj(messageModel, @"msg",3);
    
    NSDictionary * dicTemp = @{@"messageModel": messageString};
    
    NSString *soapBody = [self.packer messageForService:@"uploadSupervisionMessage" andParams:dicTemp];
    
    if (soapBody) {
        [self executeWebService:@"uploadSupervisionMessage" soapBody:soapBody andResultHandler:^(id dataXML, NSError *error) {
            if (error == nil) {
                //解析data，并找出与UserInfoModel对象的XML部分
                TBXMLElement *xmlElement;
                [(NSValue *)dataXML getValue:&xmlElement];
                if (xmlElement) {
                    
                    TBXMLElement *r1=[TBXML childElementNamed:@"uploadSupervisionMessageResponse" parentElement:xmlElement];
                    if(r1 != nil){
						TBXMLElement *r2=[TBXML childElementNamed:@"out" parentElement:r1];
                    
						if (r2!=nil) {
							if ([[TBXML valueOfAttributeNamed:@"xsi:nil" forElement:r2] isEqualToString:@"true"] ||
								[TBXML textForElement:r2] == nil) {
                            
								NSError * err = [NSError errorWithDomain:@"out is nil" code:0 userInfo:nil];
								asyncHanlder(0,err);
							} else {
								NSString * result = [TBXML textForElement:r2];
                            
								asyncHanlder(result.boolValue, error);
							}
						}
					}else{
						 NSLog(@"uploadSupervisionMessage error  %@",error.description);
					}
                }
                
            } else {
                //分析错误
                
                NSLog(@"uploadSupervisionMessage error  %@",error.description);
            }
        }];
    }
}

-(void)getSupervisionWorkflowList:(NSString *)permitId withAsyncHanlder:(void (^)(NSArray *, NSError *))asyncHanlder
{
    NSDictionary * dicTemp = @{@"permitId": permitId};
    
    NSString *soapBody = [self.packer messageForService:@"getSupervisionWorkflowList" andParams:dicTemp];
    
    NSMutableArray * taskArray = [[NSMutableArray alloc]init];
    
    if (soapBody) {
        [self executeWebService:@"getSupervisionWorkflowList" soapBody:soapBody andResultHandler:^(id dataXML, NSError *error) {
            //解析data，并生成CoreData对象
            
            if (error == nil) {
                
                TBXMLElement *xmlElement;
                [(NSValue *)dataXML getValue:&xmlElement];
                if (xmlElement) {
                    
                    TBXMLElement *r1=[TBXML childElementNamed:@"getSupervisionWorkflowListResponse" parentElement:xmlElement];
                    
                    TBXMLElement *r2=[TBXML childElementNamed:@"out" parentElement:r1];
                    
                    if (r2!=nil) {
                        if ([[TBXML valueOfAttributeNamed:@"xsi:nil" forElement:r2] isEqualToString:@"true"] ||
                            [TBXML textForElement:r2] == nil) {
                            
                            NSError * err = [NSError errorWithDomain:@"out is nil" code:0 userInfo:nil];
                            asyncHanlder(0,err);
                        } else {
                            TBXMLElement *r3=[TBXML childElementNamed:@"ns1:TaskSimpleModel" parentElement:r2];
                            
                            while (r3) {
                                @autoreleasepool {
                                    NSValue *xmlData = [NSValue value:&r3 withObjCType:@encode(TBXMLElement *)];
                                    
                                    TaskSimpleModel * task = [TaskSimpleModel newModelFromXML:xmlData];
                                    
                                    [taskArray addObject:task];
                                    
                                    
                                }
                                
                                r3=r3->nextSibling;
                            }
                            
                            asyncHanlder(taskArray,error);
                        }
                    }
                    
                }
            } else {
                //分析错误
                NSError * err = [NSError errorWithDomain:@"out is nil" code:0 userInfo:nil];
                asyncHanlder(0,err);
                NSLog(@"getSupervisionWorkflowList error  %@",error.description);
            }
        }];
    } else {
        NSLog(@"not found related packer for the service");
    }
}

-(void)uploadSupervisionSign:(AppSignModel *)appSign withAsyncHanlder:(void (^)(BOOL, NSError *))asyncHanlder
{
    NSString *appSignString = self.packer.formXMLElementForObj(appSign, @"per2",3);
    
    NSDictionary * dicTemp = @{@"appSignModel": appSignString};
    
    NSString *soapBody = [self.packer messageForService:@"uploadSupervisionSign" andParams:dicTemp];
    
    if (soapBody) {
        [self executeWebService:@"uploadSupervisionSign" soapBody:soapBody andResultHandler:^(id dataXML, NSError *error) {
            if (error == nil) {
                //解析data，并找出与UserInfoModel对象的XML部分
                TBXMLElement *xmlElement;
                [(NSValue *)dataXML getValue:&xmlElement];
                if (xmlElement) {
                    
                    TBXMLElement *r1=[TBXML childElementNamed:@"uploadSupervisionSignResponse" parentElement:xmlElement];
                    
                    TBXMLElement *r2=[TBXML childElementNamed:@"out" parentElement:r1];
                    
                    if (r2!=nil) {
                        if ([[TBXML valueOfAttributeNamed:@"xsi:nil" forElement:r2] isEqualToString:@"true"] ||
                            [TBXML textForElement:r2] == nil) {
                            
                            NSError * err = [NSError errorWithDomain:@"out is nil" code:0 userInfo:nil];
                            asyncHanlder(0,err);
                        } else {
                            NSString * result = [TBXML textForElement:r2];
                            
                            asyncHanlder(result.boolValue, error);
                        }
                    }
                    
                }
                
            } else {
                //分析错误
                
                NSError * err = [NSError errorWithDomain:@"uploadSupervisionSign error " code:0 userInfo:nil];
                asyncHanlder(0,err);
            }
        }];
    }
}

-(void)readSupervisionOrgArticle:(NSString *)orgArticleId withAsyncHanlder:(void (^)(BOOL, NSError *))asyncHanlder
{
    NSDictionary * dicTemp = @{@"orgArticleId": orgArticleId};
    
    NSString *soapBody = [self.packer messageForService:@"readSupervisionOrgArticle" andParams:dicTemp];
    
    if (soapBody) {
        [self executeWebService:@"readSupervisionOrgArticle" soapBody:soapBody andResultHandler:^(id dataXML, NSError *error) {
            if (error == nil) {
                //解析data，并找出与UserInfoModel对象的XML部分
                TBXMLElement *xmlElement;
                [(NSValue *)dataXML getValue:&xmlElement];
                if (xmlElement) {
                    
                    TBXMLElement *r1=[TBXML childElementNamed:@"readSupervisionOrgArticleResponse" parentElement:xmlElement];
                    
                    TBXMLElement *r2=[TBXML childElementNamed:@"out" parentElement:r1];
                    
                    if (r2!=nil) {
                        if ([[TBXML valueOfAttributeNamed:@"xsi:nil" forElement:r2] isEqualToString:@"true"] ||
                            [TBXML textForElement:r2] == nil) {
                            
                            NSError * err = [NSError errorWithDomain:@"out is nil" code:0 userInfo:nil];
                            asyncHanlder(0,err);
                        } else {
                            NSString * result = [TBXML textForElement:r2];
                            
                            asyncHanlder(result.boolValue, error);
                        }
                    }
                    
                }
                
            } else {
                //分析错误
                
                NSLog(@"readSupervisionOrgArticle error  %@",error.description);
            }
        }];
    }
}

-(void)readSupervisionMessage:(NSString *)messageId withAsyncHanlder:(void (^)(BOOL, NSError *))asyncHanlder
{
    NSDictionary * dicTemp = @{@"messageId": messageId};
    
    NSString *soapBody = [self.packer messageForService:@"readSupervisionMessage" andParams:dicTemp];
    
    if (soapBody) {
        [self executeWebService:@"readSupervisionMessage" soapBody:soapBody andResultHandler:^(id dataXML, NSError *error) {
            if (error == nil) {
                //解析data，并找出与UserInfoModel对象的XML部分
                TBXMLElement *xmlElement;
                [(NSValue *)dataXML getValue:&xmlElement];
                if (xmlElement) {
                    
                    TBXMLElement *r1=[TBXML childElementNamed:@"readSupervisionMessageResponse" parentElement:xmlElement];
                    
                    TBXMLElement *r2=[TBXML childElementNamed:@"out" parentElement:r1];
                    
                    if (r2!=nil) {
                        if ([[TBXML valueOfAttributeNamed:@"xsi:nil" forElement:r2] isEqualToString:@"true"] ||
                            [TBXML textForElement:r2] == nil) {
                            
                            NSError * err = [NSError errorWithDomain:@"out is nil" code:0 userInfo:nil];
                            asyncHanlder(0,err);
                        } else {
                            NSString * result = [TBXML textForElement:r2];
                            
                            asyncHanlder(result.boolValue, error);
                        }
                    }
                    
                }
                
            } else {
                //分析错误
                
                NSLog(@"readSupervisionMessage error  %@",error.description);
            }
        }];
    }
}

- (void)executeWebService:(NSString *)serviceName soapBody:(NSString *)soapBody andResultHandler:(void(^)(id dataXML, NSError *error))handler
{
    
    //组成最后的请求格式
    NSString *soapMessage=[NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"\n"
                           "xmlns:web=\"http://webserv.ifreeway.com\"\n"
                           "xmlns:proj=\"http://project.workflow.common.ifreeway.com\"\n"
                           "xmlns:per=\"http://permit.irmsgd.ifreeway.com\"\n"
                           "xmlns:per2=\"http://ipad.permit.irmsgd.ifreeway.com\"\n"
                           "xmlns:msg=\"http://model.message.cooperate.irmsgd.ifreeway.com\"\n"
                           "xmlns:mod=\"http://model.newinspection.inspection.irmsgd.ifreeway.com\"\n"
                           "xmlns:mod1=\"http://model.inspectionrecord.inspection.irmsgd.ifreeway.com\"\n"
                           "xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"\n"
                           "xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">\n"
                           "<soapenv:Body>\n"
                           "%@"
                           "</soapenv:Body>\n"
                           "</soapenv:Envelope>",soapBody];
    //请求网络
    NSURL *url = [[self class] serverURL];
    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:url];
    [theRequest setTimeoutInterval:240];
    NSString *msgLength=[NSString stringWithFormat:@"%d",[soapMessage length]];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: [NSString stringWithFormat:@"http://webserv.ifreeway.com/%@",serviceName] forHTTPHeaderField:@"SOAPAction"];
    
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:enc]];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [NSURLConnection sendAsynchronousRequest:theRequest queue:self.queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        if (data.length > 0 && error == nil) {
            
            NSError * error = nil;
            
            NSString *theXML = [[NSString alloc] initWithBytes: [data bytes] length:[data length] encoding:NSUTF8StringEncoding];
            //对返回请求返回的data转后成xml之后先过滤一部分错误，如error虽然为nil，但data中报告了错误，error只能提示服务器错误或网络错误
            TBXML *tbxml=[TBXML newTBXMLWithXMLString:theXML error:&error];
            TBXMLElement *root=tbxml.rootXMLElement;
            TBXMLElement *rf=[TBXML childElementNamed:@"soap:Body" parentElement:root];
            
            NSValue *dataXML = [NSValue value:&rf withObjCType:@encode(TBXMLElement *)];
            
            handler(dataXML, error);
            
            //对xml中表示数据的部分进行提取，转交给handler
        } else if (error != nil && error.code == NSURLErrorTimedOut) {
            
            NSError * err = [NSError errorWithDomain:@"oap server response NSURLErrorTimedOut ... " code:0 userInfo:nil];
            handler(@"NSURLErrorTimedOut",err);
            
            
        } else if (error != nil) {
            NSError * err = [NSError errorWithDomain:SOAP_SERVER_RESPONSE_ERROR code:0 userInfo:nil];
            handler(SOAP_SERVER_RESPONSE_ERROR,err);
        }else if (data.length==0)
        {
            NSError * err = [NSError errorWithDomain:DATA_IS_EMPTY code:0 userInfo:nil];
            
            handler(@[DATA_IS_EMPTY],err);
        }else
        {
            NSError * err = [NSError errorWithDomain:DATA_IS_EMPTY code:0 userInfo:nil];

            handler(@[DATA_IS_EMPTY],err);
        }
    }];
    
}

- (void)executeSynchronousWebService:(NSString *)serviceName soapBody:(NSString *)soapBody andResultHandler:(void(^)(id dataXML, NSError *error))handler
{
    
    //组成最后的请求格式
    NSString *soapMessage=[NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"\n"
                           "xmlns:web=\"http://webserv.ifreeway.com\"\n"
                           "xmlns:proj=\"http://project.workflow.common.ifreeway.com\"\n"
                           "xmlns:per=\"http://permit.irmsgd.ifreeway.com\"\n"
                           "xmlns:per2=\"http://ipad.permit.irmsgd.ifreeway.com\"\n"
                           "xmlns:msg=\"http://model.message.cooperate.irmsgd.ifreeway.com\"\n"
                           "xmlns:mod=\"http://model.newinspection.inspection.irmsgd.ifreeway.com\"\n"
                           "xmlns:mod1=\"http://model.inspectionrecord.inspection.irmsgd.ifreeway.com\"\n"
                           "xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"\n"
                           "xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">\n"
                           "<soapenv:Body>\n"
                           "%@"
                           "</soapenv:Body>\n"
                           "</soapenv:Envelope>",soapBody];
    //请求网络
    NSURL *url = [[self class] serverURL];
    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:url];
    [theRequest setTimeoutInterval:240];
    NSString *msgLength=[NSString stringWithFormat:@"%d",[soapMessage length]];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: [NSString stringWithFormat:@"http://webserv.ifreeway.com/%@",serviceName] forHTTPHeaderField:@"SOAPAction"];
    
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:enc]];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	NSError *error = nil;
	NSData *received = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:nil error:&error];;
    NSString *data = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	if (data.length > 0 && error == nil) {
		
		NSError * error = nil;
		//对返回请求返回的data转后成xml之后先过滤一部分错误，如error虽然为nil，但data中报告了错误，error只能提示服务器错误或网络错误
		TBXML *tbxml=[TBXML newTBXMLWithXMLString:data error:&error];
		TBXMLElement *root=tbxml.rootXMLElement;
		TBXMLElement *rf=[TBXML childElementNamed:@"soap:Body" parentElement:root];
		
		NSValue *dataXML = [NSValue value:&rf withObjCType:@encode(TBXMLElement *)];
		
		handler(dataXML, error);
		
		//对xml中表示数据的部分进行提取，转交给handler
	} else if (error != nil && error.code == NSURLErrorTimedOut) {
		
		NSError * err = [NSError errorWithDomain:@"oap server response NSURLErrorTimedOut ... " code:0 userInfo:nil];
		handler(@"NSURLErrorTimedOut",err);
		
		
	} else if (error != nil) {
		NSError * err = [NSError errorWithDomain:SOAP_SERVER_RESPONSE_ERROR code:0 userInfo:nil];
		handler(SOAP_SERVER_RESPONSE_ERROR,err);
	}else if (data.length==0)
	{
		NSError * err = [NSError errorWithDomain:DATA_IS_EMPTY code:0 userInfo:nil];
		
		handler(@[DATA_IS_EMPTY],err);
	}else
	{
		NSError * err = [NSError errorWithDomain:DATA_IS_EMPTY code:0 userInfo:nil];
		
		handler(@[DATA_IS_EMPTY],err);
	}

    
}

+ (BOOL)isServerReachable{
    NSURL *url1 = [self serverURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url1 cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5];
    NSHTTPURLResponse *response;
    [NSURLConnection sendSynchronousRequest:request returningResponse: &response error: nil];
    if (response == nil) {
        void(^ShowAlert)(void)=^(void){
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"连接错误" message:@"无法连接到服务器，请检查网络连接。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        };
        MAINDISPATCH(ShowAlert);
        return NO;
    }
    return YES;
}
/**
 * 获取路政统计汇总数据（当月）
 */
-(void)getSupervisionStatisticsNewData:(NSDictionary *)args withAsyncHanlder:(void (^)(NSMutableArray *, NSError *))asyncHanlder
{
    NSString *soapBody = [self.packer messageForService:@"getSupervisionStatisticsNewData" andParams:args];
    if (soapBody) {
        [self executeWebService:@"getSupervisionStatisticsNewData" soapBody:soapBody andResultHandler:^(id dataXML, NSError *error) {
            if (error == nil) {
                //解析data，并找出与UserInfoModel对象的XML部分
                TBXMLElement *xmlElement;
                [(NSValue *)dataXML getValue:&xmlElement];
                if (xmlElement) {
                    
                    TBXMLElement *r1=[TBXML childElementNamed:@"getSupervisionStatisticsNewDataResponse" parentElement:xmlElement];
                    
                    TBXMLElement *r2=[TBXML childElementNamed:@"out" parentElement:r1];
                    NSMutableArray * statisticsNewModelArray = [[NSMutableArray alloc]init];
                    if (r2!=nil) {
                        if ([[TBXML valueOfAttributeNamed:@"xsi:nil" forElement:r2] isEqualToString:@"true"] ||
                            [TBXML textForElement:r2] == nil) {
                            
                            NSError * err = [NSError errorWithDomain:@"out is nil" code:0 userInfo:nil];
                            asyncHanlder(0,err);
                        } else {
                            TBXMLElement *r3=[TBXML childElementNamed:@"ns1:StatisticsNewModel" parentElement:r2];
                            
                            while (r3) {
                                @autoreleasepool {
                                    NSValue *xmlData = [NSValue value:&r3 withObjCType:@encode(TBXMLElement *)];
                                    
                                    StatisticsNewModel * statisticsNewModel = [StatisticsNewModel newModelFromXML:xmlData];
                                    
                                    [statisticsNewModelArray addObject:statisticsNewModel];
                                    
                                }
                                
                                r3=r3->nextSibling;
                            }
                            
                            asyncHanlder(statisticsNewModelArray,error);
                        }
                    }
                    
                }
                
                
            } else {
                //分析错误
                asyncHanlder(0,error);
			
                NSLog(@"getSupervisionStatisticsNewData error  %@",error.description);
            }
        }];
    } else {
        NSLog(@"not found related packer for the service");
    }
}
/**
 * 获取路政统计汇总数据（当月）
 */
-(void)getSupervisionStatisticsNewLowerOrgData:(NSDictionary *)args withAsyncHanlder:(void (^)(NSMutableArray *, NSError *))asyncHanlder
{
    NSString *soapBody = [self.packer messageForService:@"getSupervisionStatisticsNewLowerOrgData" andParams:args];
    if (soapBody) {
        [self executeWebService:@"getSupervisionStatisticsNewLowerOrgData" soapBody:soapBody andResultHandler:^(id dataXML, NSError *error) {
            if (error == nil) {
                //解析data，并找出与UserInfoModel对象的XML部分
                TBXMLElement *xmlElement;
                [(NSValue *)dataXML getValue:&xmlElement];
                if (xmlElement) {
                    
                    TBXMLElement *r1=[TBXML childElementNamed:@"getSupervisionStatisticsNewLowerOrgDataResponse" parentElement:xmlElement];
                    
                    TBXMLElement *r2=[TBXML childElementNamed:@"out" parentElement:r1];
                    NSMutableArray * statisticsLowerOrgModelArray = [[NSMutableArray alloc]init];
                    if (r2!=nil) {
                        if ([[TBXML valueOfAttributeNamed:@"xsi:nil" forElement:r2] isEqualToString:@"true"] ||
                            [TBXML textForElement:r2] == nil) {
                            
                            NSError * err = [NSError errorWithDomain:@"out is nil" code:0 userInfo:nil];
                            asyncHanlder(0,err);
                        } else {
                            TBXMLElement *r3=[TBXML childElementNamed:@"ns1:StatisticsLowerOrgModel" parentElement:r2];
                            
                            while (r3) {
                                @autoreleasepool {
                                    NSValue *xmlData = [NSValue value:&r3 withObjCType:@encode(TBXMLElement *)];
                                    
                                    StatisticsLowerOrgModel * statisticsLowerOrgModel = [StatisticsLowerOrgModel newModelFromXML:xmlData];
                                    
                                    [statisticsLowerOrgModelArray addObject:statisticsLowerOrgModel];
                                    
                                }
                                
                                r3=r3->nextSibling;
                            }
                            
                            asyncHanlder(statisticsLowerOrgModelArray,error);
                        }
                    }
                    
                }
                
                
            } else {
                //分析错误
                asyncHanlder(0,error);
                NSLog(@"getSupervisionStatisticsNewLowerOrgData error  %@",error.description);
            }
        }];
    } else {
        NSLog(@"not found related packer for the service");
    }
}

-(void)getSupervisionPermitExpireList:(NSDictionary *)args withAsyncHanlder:(void (^)(NSMutableArray *, NSError *))asyncHanlder
{
    NSString *soapBody = [self.packer messageForService:@"getSupervisionPermitExpireList" andParams:args];
    if (soapBody) {
        [self executeWebService:@"getSupervisionPermitExpireList" soapBody:soapBody andResultHandler:^(id dataXML, NSError *error) {
            if (error == nil) {
                //解析data，并找出与UserInfoModel对象的XML部分
                TBXMLElement *xmlElement;
                [(NSValue *)dataXML getValue:&xmlElement];
                if (xmlElement) {
                    
                    TBXMLElement *r1=[TBXML childElementNamed:@"getSupervisionPermitExpireListResponse" parentElement:xmlElement];
                    
                    TBXMLElement *r2=[TBXML childElementNamed:@"out" parentElement:r1];
                    NSMutableArray * permitExpireModelArray = [[NSMutableArray alloc]init];
                    if (r2!=nil) {
                        if ([[TBXML valueOfAttributeNamed:@"xsi:nil" forElement:r2] isEqualToString:@"true"] ||
                            [TBXML textForElement:r2] == nil) {
                            
                            NSError * err = [NSError errorWithDomain:@"out is nil" code:0 userInfo:nil];
                            asyncHanlder(0,err);
                        } else {
                            TBXMLElement *r3=[TBXML childElementNamed:@"ns1:PermitExpireModel" parentElement:r2];
                            
                            while (r3) {
                                @autoreleasepool {
                                    NSValue *xmlData = [NSValue value:&r3 withObjCType:@encode(TBXMLElement *)];
                                    
                                    PermitExpireModel * permitExpireModel = [PermitExpireModel newModelFromXML:xmlData];
                                    
                                    [permitExpireModelArray addObject:permitExpireModel];
                                    
                                }
                                
                                r3=r3->nextSibling;
                            }
                            
                            asyncHanlder(permitExpireModelArray,error);
                        }
                    }
                    
                }
                
                
            } else {
                //分析错误
                asyncHanlder(0,error);
                NSLog(@"getSupervisionPermitExpireList error  %@",error.description);
            }
        }];
    } else {
        NSLog(@"not found related packer for the service");
    }
}
-(void)getSupervisionPermitExpireSize:(NSDictionary *)args withAsyncHanlder:(void (^)(NSInteger, NSError *))asyncHanlder
{
    NSString *soapBody = [self.packer messageForService:@"getSupervisionPermitExpireSize" andParams:args];
    if (soapBody) {
        [self executeWebService:@"getSupervisionPermitExpireSize" soapBody:soapBody andResultHandler:^(id dataXML, NSError *error) {
            if (error == nil) {
                //解析data，并找出与UserInfoModel对象的XML部分
                TBXMLElement *xmlElement;
                [(NSValue *)dataXML getValue:&xmlElement];
                if (xmlElement) {
                    
                    TBXMLElement *r1=[TBXML childElementNamed:@"getSupervisionPermitExpireSizeResponse" parentElement:xmlElement];
                    
                    TBXMLElement *r2=[TBXML childElementNamed:@"out" parentElement:r1];
                    if (r2!=nil) {
                        if ([[TBXML valueOfAttributeNamed:@"xsi:nil" forElement:r2] isEqualToString:@"true"] ||
                            [TBXML textForElement:r2] == nil) {
                            
                            NSError * err = [NSError errorWithDomain:@"out is nil" code:0 userInfo:nil];
                            asyncHanlder(0,err);
                        } else {
                            NSString * result = [TBXML textForElement:r2];
                            
                            asyncHanlder(result.intValue, error);
                        }
                    }
                    
                }
                
                
            } else {
                //分析错误
                asyncHanlder(0,error);
                NSLog(@"getSupervisionPermitExpireSize error  %@",error.description);
            }
        }];
    } else {
        NSLog(@"not found related packer for the service");
    }
}

-(void)getSupervisionAppWarningList:(NSDictionary *)args withAsyncHanlder:(void (^)(NSMutableArray *, NSError *))asyncHanlder{
    NSString *soapBody = [self.packer messageForService:@"getSupervisionAppWarningList" andParams:args];
    if (soapBody) {
        [self executeWebService:@"getSupervisionAppWarningList" soapBody:soapBody andResultHandler:^(id dataXML, NSError *error) {
            if (error == nil) {
                //解析data，并找出与UserInfoModel对象的XML部分
                TBXMLElement *xmlElement;
                [(NSValue *)dataXML getValue:&xmlElement];
                if (xmlElement) {
                    
                    TBXMLElement *r1=[TBXML childElementNamed:@"getSupervisionAppWarningListResponse" parentElement:xmlElement];
                    
                    TBXMLElement *r2=[TBXML childElementNamed:@"out" parentElement:r1];
                    NSMutableArray * permitExpireModelArray = [[NSMutableArray alloc]init];
                    if (r2!=nil) {
                        if ([[TBXML valueOfAttributeNamed:@"xsi:nil" forElement:r2] isEqualToString:@"true"] ||
                            [TBXML textForElement:r2] == nil) {
                            
                            NSError * err = [NSError errorWithDomain:@"out is nil" code:0 userInfo:nil];
                            asyncHanlder(0,err);
                        } else {
                            TBXMLElement *r3=[TBXML childElementNamed:@"ns1:PermitExpireModel" parentElement:r2];
                            
                            while (r3) {
                                @autoreleasepool {
                                    NSValue *xmlData = [NSValue value:&r3 withObjCType:@encode(TBXMLElement *)];
                                    
                                    PermitExpireModel * permitExpireModel = [PermitExpireModel newModelFromXML:xmlData];
                                    
                                    [permitExpireModelArray addObject:permitExpireModel];
                                    
                                }
                                
                                r3=r3->nextSibling;
                            }
                            
                            asyncHanlder(permitExpireModelArray,error);
                        }
                    }
                    
                }
                
                
            } else {
                //分析错误
                asyncHanlder(0,error);
                NSLog(@"getSupervisionAppWarningList error  %@",error.description);
            }
        }];
    } else {
        NSLog(@"not found related packer for the service");
    }

}
-(void)getSupervisionAppWarningSize:(NSDictionary *)args withAsyncHanlder:(void (^)(NSInteger, NSError *))asyncHanlder{
	NSString *soapBody = [self.packer messageForService:@"getSupervisionAppWarningSize" andParams:args];
    if (soapBody) {
        [self executeWebService:@"getSupervisionAppWarningSize" soapBody:soapBody andResultHandler:^(id dataXML, NSError *error) {
            if (error == nil) {
                //解析data，并找出与UserInfoModel对象的XML部分
                TBXMLElement *xmlElement;
                [(NSValue *)dataXML getValue:&xmlElement];
                if (xmlElement) {
                    
                    TBXMLElement *r1=[TBXML childElementNamed:@"getSupervisionAppWarningSizeResponse" parentElement:xmlElement];
                    
                    TBXMLElement *r2=[TBXML childElementNamed:@"out" parentElement:r1];
                    if (r2!=nil) {
                        if ([[TBXML valueOfAttributeNamed:@"xsi:nil" forElement:r2] isEqualToString:@"true"] ||
                            [TBXML textForElement:r2] == nil) {
                            
                            NSError * err = [NSError errorWithDomain:@"out is nil" code:0 userInfo:nil];
                            asyncHanlder(0,err);
                        } else {
                            NSString * result = [TBXML textForElement:r2];
                            
                            asyncHanlder(result.intValue, error);
                        }
                    }
                    
                }
                
                
            } else {
                //分析错误
                asyncHanlder(0,error);
                NSLog(@"getSupervisionAppWarningSize error  %@",error.description);
            }
        }];
    } else {
        NSLog(@"not found related packer for the service");
    }

}
@end
