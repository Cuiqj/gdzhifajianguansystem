//
//  DealSituationCell.h
//  GDZhiFaJianGuanSystem
//
//  Created by quxiuyun on 14-2-25.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskSimpleModel.h"

//办理情况TableViewCell
@interface DealSituationCell : UITableViewCell

@property (nonatomic, strong) UILabel * labelTask;
@property (nonatomic, strong) UILabel * labelDealing;
@property (nonatomic, strong) UILabel * labelCompleteTime;
@property (nonatomic, strong) UILabel * labelState;
@property (nonatomic, strong) UILabel * labelOpinion;

- (void)titleLabel;
- (void)configureCellWithTaskSimpleArray:(TaskSimpleModel *)model;

@end
