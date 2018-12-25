//
//  LawsModel.h
//  GDZhiFaJianGuanSystem
//
//  Created by luna on 14-2-17.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseDataModel.h"

@interface LawsModel : BaseDataModel

@property (nonatomic, retain) NSString * caption;
@property (nonatomic, retain) NSString * dept;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * law_type;
@property (nonatomic, retain) NSString * org_id;
@property (nonatomic, retain) NSString * put_flag;
@property (nonatomic, retain) NSString * remark;

@end
