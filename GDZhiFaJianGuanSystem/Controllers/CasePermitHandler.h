//
//  CasePermitHandler.h
//  GDZhiFaJianGuanSystem
//
//  Created by quxiuyun on 14-2-27.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CasePermitHandler <NSObject>

@optional
-(void)setCaseTypeDelegate:(NSString *)caseType withNumber:(NSString *)number;
-(void)setPermitTypeDelegate:(NSString *)permitType withNumber:(NSString *)number;
//-(void)setOrgID:(NSString *)identifier withOrgName:(NSString *)orgName;
-(void)setDealWithDelegate:(NSString *)dealWithType withNumber:(NSString *)number;
@end
