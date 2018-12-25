//
//  MessageModel.h
//  GDZhiFaJianGuanSystem
//
//  Created by luna on 14-3-18.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseDataModel.h"
#import "TBXML.h"

@interface MessageModel : BaseDataModel

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * has_file;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * is_readed;
@property (nonatomic, retain) NSString * org_id;
@property (nonatomic, retain) NSString * reader;
@property (nonatomic, retain) NSString * send_date;
@property (nonatomic, retain) NSString * sender_email;
@property (nonatomic, retain) NSString * sender_id;
@property (nonatomic, retain) NSString * sender_name;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * type_code;

@end
