//
//  InspectionMainCell.h
//  GDZhiFaJianGuanSystem
//
//  Created by quxiuyun on 14-2-22.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import <UIKit/UIKit.h>
//占利用档案ViewController的自定义cell

@interface RoadEngrossMainCell : UITableViewCell

@property (nonatomic, strong) UILabel * labelNumber;
@property (nonatomic, strong) UILabel * labelCode;//编号
@property (nonatomic, strong) UILabel * labelApproveCode;//审批编号
@property (nonatomic, strong) UILabel * labelItemType;//项目类型
@property (nonatomic, strong) UILabel * labelOwnerName;//业主单位
@property (nonatomic, strong) UILabel * labelLinkmanName;//联系人
@property (nonatomic, strong) UILabel * labelLinkmanPhone;//联系电话
@property (nonatomic, strong) UILabel * labelDateEnd;//占用截至日期
@property (nonatomic, strong) UILabel * labelEngrossStyle;//占用性质
@property (nonatomic, strong) UILabel * labelOperation;

-(void)titleLabel;
- (void)configureCellWithCaseArray:(InspectionModel *)model;
@end
