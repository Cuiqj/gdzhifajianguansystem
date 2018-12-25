//
//  MianPageListNameCell.h
//  GDZhiFaJianGuanSystem
//
//  Created by quxiuyun on 14-2-11.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MianPageListNameCell : UITableViewCell

@property (nonatomic, strong) UILabel * labelTask;
@property (nonatomic, strong) UILabel * labelContent;
@property (nonatomic, strong) UILabel * labelPreTreatmentOrg;
@property (nonatomic, strong) UILabel * labelAsOfTheDate;

- (void)titleLabel;
- (void)configureCellWithCaseArray:(CurrentTaskModel *)model;
@end
