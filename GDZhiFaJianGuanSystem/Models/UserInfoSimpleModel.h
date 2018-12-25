//
//  UserInfoSimpleModel.h
//  GDZhiFaJianGuanSystem
//
//  Created by luna on 14-2-14.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseDataModel.h"


@interface UserInfoSimpleModel : BaseDataModel

@property (nonatomic, retain) NSString * account;
@property (nonatomic, retain) NSString * delFlag;
@property (nonatomic, retain) NSString * groupID;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * isadmin;
@property (nonatomic, retain) NSString * orgID;
@property (nonatomic, retain) NSString * username;

@end
