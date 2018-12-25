//
//  PermitMainCell.h
//  GDZhiFaJianGuanSystem
//
//  Created by quxiuyun on 14-2-19.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import <UIKit/UIKit.h>

//许可查询ViewController的自定义cell
@interface PermitMainCell : UITableViewCell

@property (nonatomic, strong) UILabel * labelNumber;
@property (nonatomic, strong) UILabel * labelPermitCase;
@property (nonatomic, strong) UILabel * labelPermitApplyItems;
@property (nonatomic, strong) UILabel * labelApplyTime;
@property (nonatomic, strong) UILabel * labelPermitAdd;
@property (nonatomic, strong) UILabel * labelPermitEffectiveTime;
@property (nonatomic, strong) UILabel * labelapplicant;
@property (nonatomic, strong) UILabel * labelState;

-(void)titleLabel;
- (void)configureCellWithAllPermitArray:(AllPermitModel *)model;

@end
