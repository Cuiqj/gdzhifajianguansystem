//
//  UserInfoModel.h
//  GDZhiFaJianGuanSystem
//
//  Created by XU SHIWEN on 14-2-8.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseDataModel.h"

@interface UserInfoModel : BaseDataModel

@property (nonatomic, retain) NSString * account;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSDate * birthday;
@property (nonatomic, retain) NSString * delFlag;
@property (nonatomic, retain) NSString * dept_id;
@property (nonatomic, retain) NSString * duty;
@property (nonatomic, retain) NSString * employee_id;
@property (nonatomic, retain) NSString * groupID;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSNumber * isadmin;
@property (nonatomic, retain) NSString * marriage;
@property (nonatomic, retain) NSString * memo;
@property (nonatomic, retain) NSString * orgID;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSString * sex;
@property (nonatomic, retain) NSString * telephone;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * username;

+ (UserInfoModel *)userInfoForUserID:(NSString *)userID;

+ (NSArray *)allUserInfo;

@end
