//
//  CaseMainCell.m
//  GDZhiFaJianGuanSystem
//
//  Created by quxiuyun on 14-2-19.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import "CaseMainCell.h"
#import "AllCaseModel.h"

#define LISTNAME_FONT [UIFont systemFontOfSize:17]
#define LISTTITLE_FONT [UIFont systemFontOfSize:15]
@implementation CaseMainCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _labelNumber =[[UILabel alloc] initWithFrame:CGRectMake(2, 3, 40, 37)];
        [_labelNumber setBackgroundColor:[UIColor clearColor]];
		_labelNumber.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_labelNumber];
        
        _labelcaseNum =[[UILabel alloc] initWithFrame:CGRectMake(42, 3, 130, 37)];
        [_labelcaseNum setBackgroundColor:[UIColor clearColor]];
        _labelcaseNum.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_labelcaseNum];
        
        _labelCaseTime =[[UILabel alloc] initWithFrame:CGRectMake(172, 3, 120, 37)];
        [_labelCaseTime setBackgroundColor:[UIColor clearColor]];
        _labelCaseTime.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_labelCaseTime];
        
        _labelCourseName = [[UILabel alloc] initWithFrame:CGRectMake(292, 3, 80, 37)];
        [_labelCourseName setBackgroundColor:[UIColor clearColor]];
		_labelCourseName.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_labelCourseName];
        
        _labelStartPointPileNo =[[UILabel alloc] initWithFrame:CGRectMake(372, 3, 100, 37)];
        [_labelStartPointPileNo setBackgroundColor:[UIColor clearColor]];
        _labelStartPointPileNo.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_labelStartPointPileNo];
        
        _labelEndPointPileNo =[[UILabel alloc] initWithFrame:CGRectMake(472, 3, 150, 37)];
        [_labelEndPointPileNo setBackgroundColor:[UIColor clearColor]];
        _labelEndPointPileNo.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_labelEndPointPileNo];
        
        _labelOrg =[[UILabel alloc] initWithFrame:CGRectMake(622, 3, 180, 37)];
        [_labelOrg setBackgroundColor:[UIColor clearColor]];
        _labelOrg.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_labelOrg];
        
        _labelPartiesConcerned = [[UILabel alloc] initWithFrame:CGRectMake(802, 3, 120, 37)];
        [_labelPartiesConcerned setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_labelPartiesConcerned];

        _labelcaseOriginally =[[UILabel alloc] initWithFrame:CGRectMake(922, 3, 150, 37)];
        [_labelcaseOriginally setBackgroundColor:[UIColor clearColor]];
        _labelcaseOriginally.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_labelcaseOriginally];
        
        _labelCurrentState =[[UILabel alloc] initWithFrame:CGRectMake(1072, 3, 150, 37)];
        [_labelCurrentState setBackgroundColor:[UIColor clearColor]];
		 _labelCurrentState.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_labelCurrentState];
    }
    return self;
}

- (void)titleLabel
{
    [_labelNumber setText:@"序号"];
    [_labelNumber setFont:LISTNAME_FONT];
    [_labelcaseNum setText:@"案件编号"];
    [_labelcaseNum setFont:LISTNAME_FONT];
    [_labelCaseTime setText:@"案发时间"];
    [_labelCaseTime setFont:LISTNAME_FONT];
    [_labelCourseName setText:@"线路名称"];
    [_labelCourseName setFont:LISTNAME_FONT];
    [_labelStartPointPileNo setText:@"起点桩号"];
    [_labelStartPointPileNo setFont:LISTNAME_FONT];
    [_labelEndPointPileNo setText:@"结束桩号"];
    [_labelEndPointPileNo setFont:LISTNAME_FONT];
    [_labelOrg setText:@"所属机构"];
    [_labelOrg setFont:LISTNAME_FONT];
    [_labelPartiesConcerned setText:@"当事人"];
    [_labelPartiesConcerned setFont:LISTNAME_FONT];
    [_labelcaseOriginally setText:@"案由"];
    [_labelcaseOriginally setFont:LISTNAME_FONT];
    [_labelCurrentState setText:@"当前状态"];
    [_labelCurrentState setFont:LISTNAME_FONT];
}

- (void)configureCellWithAllCaseArray:(AllCaseModel *)model
{
    [_labelNumber setText:model.anjuan_no];
    [_labelNumber setFont:LISTTITLE_FONT];
    [_labelcaseNum setText:model.case_code];
    [_labelcaseNum setFont:LISTTITLE_FONT];
    [_labelCaseTime setText:model.happen_date];
    [_labelCaseTime setFont:LISTTITLE_FONT];
    [_labelCourseName setText:model.road_name];
    [_labelCourseName setFont:LISTTITLE_FONT];
    [_labelStartPointPileNo setText:model.station_start_display];
    [_labelStartPointPileNo setFont:LISTTITLE_FONT];
    [_labelEndPointPileNo setText:model.station_end_display];
    [_labelEndPointPileNo setFont:LISTTITLE_FONT];

    [_labelOrg setFont:LISTTITLE_FONT];
    [_labelPartiesConcerned setText:model.citizen_name];
    [_labelPartiesConcerned setFont:LISTTITLE_FONT];
    [_labelcaseOriginally setText:model.casereasonAuto];
    [_labelcaseOriginally setFont:LISTTITLE_FONT];
    [_labelCurrentState setText:model.status];
    [_labelCurrentState setFont:LISTTITLE_FONT];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
