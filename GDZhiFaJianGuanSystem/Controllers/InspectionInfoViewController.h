//
//  InspectionInfoViewController.h
//  GDZhiFaJianGuanSystem
//
//  Created by luna on 14-3-5.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModelCenter.h"

@interface InspectionInfoViewController : UIViewController
@property (retain, nonatomic) InspectionModel *inspectionModel;
+ (instancetype)newInstance;
@end
