//
//  OrgInfoModel.h
//  GDZhiFaJianGuanSystem
//
//  Created by luna on 14-3-3.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface OrgInfoModel : NSManagedObject

@property (nonatomic, retain) NSString * belongtoOrgCode;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * org_tpye;
@property (nonatomic, retain) NSString * orgName;
@property (nonatomic, retain) NSString * orgShortName;
@property (nonatomic, retain) NSString * lowerOrgId;

@end
