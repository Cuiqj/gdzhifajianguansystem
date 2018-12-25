//
//  PersonnelManagementCell.h
//  GDZhiFaJianGuanSystem
//
//  Created by quxiuyun on 14-3-5.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmployeeInfoModel.h"
#import "CustomPersonButton.h"
@interface PersonnelManagementCell : UITableViewCell

@property (nonatomic, strong) UILabel * labelNumber;
@property (nonatomic, strong) UILabel * labelName;
@property (nonatomic, strong) UILabel * labelAccount;
@property (nonatomic, strong) UILabel * labelOrg;
@property (nonatomic, strong) UILabel * labelPhone;
@property (nonatomic, strong) UILabel * labelPosition;
@property (nonatomic, strong) UIButton * caseSearchButton;
@property (nonatomic, strong) UIButton * inspectionSearchButton;
@property (nonatomic, strong) UIButton * permitSearchButton;
@property (nonatomic, strong) UILabel * labelOperation;

-(void)titleLabel;
- (void)configureCellWithAllPermitArray:(EmployeeInfoModel *)model;
@end
