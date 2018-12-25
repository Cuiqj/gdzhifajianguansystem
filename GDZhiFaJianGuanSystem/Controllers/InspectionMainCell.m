//
//  InspectionMainCell.m
//  GDZhiFaJianGuanSystem
//
//  Created by quxiuyun on 14-2-22.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import "InspectionMainCell.h"
#import "InspectionModel.h"
#define LISTNAME_FONT [UIFont systemFontOfSize:17]
#define LISTTITLE_FONT [UIFont systemFontOfSize:15]

@implementation InspectionMainCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _labelInspectionDate =[[UILabel alloc] initWithFrame:CGRectMake(10, 3, 130, 37)];
        
        [_labelInspectionDate setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_labelInspectionDate];
        
        _labelInspectionSituation =[[UILabel alloc] initWithFrame:CGRectMake(100, 3, 500, 37)];
        
        _labelInspectionSituation.textAlignment = NSTextAlignmentCenter;//居中显示
        [_labelInspectionSituation setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_labelInspectionSituation];
        
        _labelCustodyUnit =[[UILabel alloc] initWithFrame:CGRectMake(580, 3, 200, 37)];
        _labelCustodyUnit.textAlignment = NSTextAlignmentCenter;
        [_labelCustodyUnit setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_labelCustodyUnit];

    }
    return self;
}

-(void)titleLabel
{
    [_labelInspectionDate setText:@"巡查日期"];
    [_labelInspectionDate setFont:LISTNAME_FONT];
    [_labelInspectionSituation setText:@"巡查情况"];
    [_labelInspectionSituation setFont:LISTNAME_FONT];
    [_labelCustodyUnit setText:@"管养单位"];
    [_labelCustodyUnit setFont:LISTNAME_FONT];
}

- (void)configureCellWithCaseArray:(InspectionModel *)model
{
    [_labelInspectionDate setText:model.date_inspection];
    [_labelInspectionDate setFont:LISTTITLE_FONT];
    [_labelInspectionSituation setText:model.description_inspection];
    [_labelInspectionSituation setFont:LISTTITLE_FONT];
//    [_labelCustodyUnit setText:model];
    [_labelCustodyUnit setFont:LISTTITLE_FONT];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
