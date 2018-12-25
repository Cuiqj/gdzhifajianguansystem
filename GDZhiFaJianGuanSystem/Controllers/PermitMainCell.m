//
//  PermitMainCell.m
//  GDZhiFaJianGuanSystem
//
//  Created by quxiuyun on 14-2-19.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import "PermitMainCell.h"
#import "AllPermitModel.h"

#define LISTNAME_FONT [UIFont systemFontOfSize:17]
#define LISTTITLE_FONT [UIFont systemFontOfSize:15]
@implementation PermitMainCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _labelNumber =[[UILabel alloc] initWithFrame:CGRectMake(2, 3, 50, 37)];
        [_labelNumber setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_labelNumber];
        
        _labelPermitCase =[[UILabel alloc] initWithFrame:CGRectMake(20, 3, 150, 37)];
        [_labelPermitCase setBackgroundColor:[UIColor clearColor]];
        _labelPermitCase.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_labelPermitCase];
        
        _labelPermitApplyItems =[[UILabel alloc] initWithFrame:CGRectMake(180, 3, 140, 37)];
        [_labelPermitApplyItems setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_labelPermitApplyItems];
        
        _labelApplyTime = [[UILabel alloc] initWithFrame:CGRectMake(250, 3, 250, 37)];
        [_labelApplyTime setBackgroundColor:[UIColor clearColor]];
        _labelApplyTime.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_labelApplyTime];
        
        _labelPermitAdd =[[UILabel alloc] initWithFrame:CGRectMake(470, 3, 150, 37)];
        [_labelPermitAdd setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_labelPermitAdd];
        
        _labelPermitEffectiveTime =[[UILabel alloc] initWithFrame:CGRectMake(605, 3, 180, 37)];
        [_labelPermitEffectiveTime setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_labelPermitEffectiveTime];
        
        _labelapplicant =[[UILabel alloc] initWithFrame:CGRectMake(760, 3, 150, 37)];
        [_labelapplicant setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_labelapplicant];
        
        _labelState = [[UILabel alloc] initWithFrame:CGRectMake(900, 3, 170, 37)];
        [_labelState setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_labelState];
    }
    return self;
}

-(void)titleLabel{
    [_labelNumber setText:@"序号"];
    [_labelNumber setFont:LISTNAME_FONT];
    [_labelPermitCase setText:@"许可案号"];
    [_labelPermitCase setFont:LISTNAME_FONT];
    [_labelPermitApplyItems setText:@"许可申请时间"];
    [_labelPermitApplyItems setFont:LISTNAME_FONT];
    [_labelApplyTime setText:@"申请日期"];
    [_labelApplyTime setFont:LISTNAME_FONT];
    [_labelPermitAdd setText:@"许可地点"];
    [_labelPermitAdd setFont:LISTNAME_FONT];
    [_labelPermitEffectiveTime setText:@"许可有效时间"];
    [_labelPermitEffectiveTime setFont:LISTNAME_FONT];
    [_labelapplicant setText:@"申请人"];
    [_labelapplicant setFont:LISTNAME_FONT];
    [_labelState setText:@"状态"];
    [_labelState setFont:LISTNAME_FONT];
	
}

-(void)configureCellWithAllPermitArray:(AllPermitModel *)model
{
    
    [_labelNumber setFont:LISTTITLE_FONT];
    [_labelPermitCase setText:model.app_no];
    [_labelPermitCase setFont:LISTTITLE_FONT];
    [_labelPermitApplyItems setText:model.app_date];
    [_labelPermitApplyItems setFont:LISTTITLE_FONT];
    [_labelApplyTime setText:model.date_step];
    [_labelApplyTime setFont:LISTTITLE_FONT];
    [_labelPermitAdd setText:model.applicant_address];
    [_labelPermitAdd setFont:LISTTITLE_FONT];
    [_labelPermitEffectiveTime setText:model.admissible_date];
    [_labelPermitEffectiveTime setFont:LISTTITLE_FONT];
    [_labelapplicant setText:model.applicant_name];
    [_labelapplicant setFont:LISTTITLE_FONT];
    [_labelState setText:model.status];
    [_labelState setFont:LISTTITLE_FONT];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
