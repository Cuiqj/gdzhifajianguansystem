//
//  OrgInfoSimpleModel.h
//  GDZhiFaJianGuanSystem
//
//  Created by luna on 14-3-3.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseDataModel.h"
#import "TBXML.h"


@interface OrgInfoSimpleModel : BaseDataModel

@property (nonatomic, retain) NSString * belongtoOrgCode;
@property (nonatomic, retain) NSString * orgName;
@property (nonatomic, retain) NSString * orgShortName;
@property (nonatomic, retain) NSString * org_tpye;
@property (nonatomic, retain) NSString * lowerOrgId;
@property (nonatomic, retain) NSString * identifier;

@end
