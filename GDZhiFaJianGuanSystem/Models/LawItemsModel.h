//
//  LawItemsModel.h
//  GDZhiFaJianGuanSystem
//
//  Created by luna on 14-2-17.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseDataModel.h"

@interface LawItemsModel : BaseDataModel

@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * law_id;
@property (nonatomic, retain) NSString * lawitem_desc;
@property (nonatomic, retain) NSString * lawitem_no;
@property (nonatomic, retain) NSString * remark;

@end
