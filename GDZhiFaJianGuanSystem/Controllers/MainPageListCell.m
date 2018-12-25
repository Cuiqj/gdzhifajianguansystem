//
//  MainPageListCell.m
//  GDZhiFaJianGuanSystem
//
//  Created by quxiuyun on 14-2-11.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import "MainPageListCell.h"

@implementation MainPageListCell
#define LISTNAME_FONT [UIFont systemFontOfSize:22]

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _labelTask =[[UILabel alloc] initWithFrame:CGRectMake(10, 2, 240, 56)];
        [_labelTask setBackgroundColor:[UIColor grayColor]];
        [_labelTask setText:@"任务"];
        [_labelTask setFont:LISTNAME_FONT];
        [self.contentView addSubview:_labelTask];
        _labelSpecificContent = [[UILabel alloc] initWithFrame:CGRectMake(240, 2, 240, 56)];
        [_labelSpecificContent setBackgroundColor:[UIColor grayColor]];
        [_labelSpecificContent setText:@"具体内容"];
        [_labelSpecificContent setFont:LISTNAME_FONT];
        [self.contentView addSubview:_labelSpecificContent];
        _labelFormerProcessingOrg =[[UILabel alloc] initWithFrame:CGRectMake(480, 2, 240, 56)];
        [_labelFormerProcessingOrg setBackgroundColor:[UIColor grayColor]];
        [_labelFormerProcessingOrg setText:@"前一处理机构／人"];
        [_labelFormerProcessingOrg setFont:LISTNAME_FONT];
        [self.contentView addSubview:_labelFormerProcessingOrg];
        _labelAsOfTheDate =[[UILabel alloc] initWithFrame:CGRectMake(720, 2, 240, 56)];
        [_labelAsOfTheDate setBackgroundColor:[UIColor grayColor]];
        [_labelAsOfTheDate setText:@"截止日期"];
        [_labelAsOfTheDate setFont:LISTNAME_FONT];
        [self.contentView addSubview:_labelAsOfTheDate];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
