//
//  LawViewController.h
//  GDZhiFaJianGuanSystem
//
//  Created by quxiuyun on 14-2-17.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@interface LawViewController : UIViewController<MBProgressHUDDelegate>

@property (weak, nonatomic) IBOutlet UIView *leftTopView;
@property (weak, nonatomic) IBOutlet UIView *leftBottomView;
@property (weak, nonatomic) IBOutlet UIView *rightView;

@end

@class RoadAssetPriceModel;

@interface PriceStandard: NSObject

@property (nonatomic, strong) NSString *big_type;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *spec;
@property (nonatomic, strong) NSString *unit_name;
@property (nonatomic, strong) NSString *remark;

+ (PriceStandard *)priceStandardFromCoreDataObject:(RoadAssetPriceModel *)cdObject;

@end

