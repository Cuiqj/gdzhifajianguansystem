//
//  InspectionMainCell.h
//  GDZhiFaJianGuanSystem
//
//  Created by quxiuyun on 14-2-22.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import <UIKit/UIKit.h>
//巡查信息查询ViewController的自定义cell

@interface InspectionMainCell : UITableViewCell

@property (nonatomic, strong) UILabel * labelInspectionDate;
@property (nonatomic, strong) UILabel * labelInspectionSituation;
@property (nonatomic, strong) UILabel * labelCustodyUnit;

-(void)titleLabel;
- (void)configureCellWithCaseArray:(InspectionModel *)model;
@end
