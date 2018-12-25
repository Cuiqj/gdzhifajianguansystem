//
//  LicensedContentViewController.h
//  GDZhiFaJianGuanSystem
//
//  Created by quxiuyun on 14-2-24.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CurrentTaskModel.h"

//许可申请内容View
@interface LicensedContentViewController : UIViewController

@property (strong, nonatomic) CurrentTaskModel * currentModel;
@property (weak, nonatomic) IBOutlet UITextField *textLicenseNum;
@property (weak, nonatomic) IBOutlet UITextField *textLicenseReason;
@property (weak, nonatomic) IBOutlet UITextField *textLicenseMatters;
@property (weak, nonatomic) IBOutlet UITextField *textSpecificAdd;
@property (weak, nonatomic) IBOutlet UITextField *textTimeLimitOne;
@property (weak, nonatomic) IBOutlet UITextField *textTimeLimitSecond;


@end
