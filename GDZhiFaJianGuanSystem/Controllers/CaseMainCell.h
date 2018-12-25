//
//  CaseMainCell.h
//  GDZhiFaJianGuanSystem
//
//  Created by quxiuyun on 14-2-19.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import <UIKit/UIKit.h>
//案件查询自定义Cell
@interface CaseMainCell : UITableViewCell

@property (nonatomic, strong) UILabel * labelNumber;
@property (nonatomic, strong) UILabel * labelcaseNum;
@property (nonatomic, strong) UILabel * labelCaseTime;
@property (nonatomic, strong) UILabel * labelCourseName;
@property (nonatomic, strong) UILabel * labelStartPointPileNo;
@property (nonatomic, strong) UILabel * labelEndPointPileNo;
@property (nonatomic, strong) UILabel * labelOrg;
@property (nonatomic, strong) UILabel * labelPartiesConcerned;
@property (nonatomic, strong) UILabel * labelcaseOriginally;
@property (nonatomic, strong) UILabel * labelCurrentState;

- (void)titleLabel;
- (void)configureCellWithAllCaseArray:(AllCaseModel *)model;

@end
