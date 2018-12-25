//
//  MianPageListNameCell.m
//  GDZhiFaJianGuanSystem
//
//  Created by quxiuyun on 14-2-11.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import "MianPageListNameCell.h"
#import "CurrentTaskModel.h"

#define LISTNAME_FONT [UIFont systemFontOfSize:22]
#define LISTTITLE_FONT [UIFont systemFontOfSize:20]
@implementation MianPageListNameCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _labelTask =[[UILabel alloc] initWithFrame:CGRectMake(60, 3, 260, 37)];
        

        [_labelTask setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_labelTask];
        _labelContent =[[UILabel alloc] initWithFrame:CGRectMake(360, 3, 220, 37)];
        
        [_labelContent setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_labelContent];
        _labelPreTreatmentOrg =[[UILabel alloc] initWithFrame:CGRectMake(610, 3, 220, 37)];
        
        [_labelPreTreatmentOrg setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_labelPreTreatmentOrg];
        _labelAsOfTheDate = [[UILabel alloc] initWithFrame:CGRectMake(800, 3, 220, 37)];
        
        [_labelAsOfTheDate setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_labelAsOfTheDate];
    }
    return self;
}

- (void)titleLabel{
    [_labelTask setText:@"任务"];
    [_labelTask setFont:LISTNAME_FONT];
    [_labelContent setText:@"具体内容"];
    [_labelContent setFont:LISTNAME_FONT];
    [_labelPreTreatmentOrg setText:@"前一处理人"];
    [_labelPreTreatmentOrg setFont:LISTNAME_FONT];
    [_labelAsOfTheDate setText:@"截止日期"];
    [_labelAsOfTheDate setFont:LISTNAME_FONT];
}

- (void)configureCellWithCaseArray:(CurrentTaskModel *)model
{
    [_labelTask setText:model.app_no];
    [_labelTask setFont:LISTTITLE_FONT];
    [_labelContent setText:model.nodeName];
    [_labelContent setFont:LISTTITLE_FONT];
    [_labelPreTreatmentOrg setText:model.lastUserName];
    [_labelPreTreatmentOrg setFont:LISTTITLE_FONT];
    [_labelAsOfTheDate setText:model.date_cut];
    [_labelAsOfTheDate setFont:LISTTITLE_FONT];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
