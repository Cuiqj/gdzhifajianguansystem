//
//  ReportAndAttechmentModel.h
//  GDZhiFaJianGuanSystem
//
//  Created by luna on 14-2-10.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseDataModel.h"

@interface ReportAndAttechmentModel : BaseDataModel

@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * importent;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * project_id;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * url;

@end
