//
//  OrgArticleModel.h
//  GDZhiFaJianGuanSystem
//
//  Created by luna on 14-2-25.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseDataModel.h"
#import "TBXML.h"

@interface OrgArticleModel : BaseDataModel

@property (nonatomic, retain) NSString * belowOrg;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * delFlag;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * keywords;
@property (nonatomic, retain) NSString * org_id;
@property (nonatomic, retain) NSString * orgIds;
@property (nonatomic, retain) NSString * orgnames;
@property (nonatomic, retain) NSString * picture_url;
@property (nonatomic, retain) NSString * publicize_date;
@property (nonatomic, retain) NSString * read_count;
@property (nonatomic, retain) NSString * readedOrg;
@property (nonatomic, retain) NSString * remark;
@property (nonatomic, retain) NSString * senderPerson;
@property (nonatomic, retain) NSString * senderAccount;
@property (nonatomic, retain) NSString * side_title;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * type_code;

@end
