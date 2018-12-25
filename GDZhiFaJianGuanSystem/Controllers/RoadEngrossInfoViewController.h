//
//  InspectionInfoViewController.h
//  GDZhiFaJianGuanSystem
//
//  Created by luna on 14-3-5.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModelCenter.h"

@interface RoadEngrossInfoViewController : UIViewController
@property (retain, nonatomic) RoadModel *roadModel;
+ (instancetype)newInstance;
@end
