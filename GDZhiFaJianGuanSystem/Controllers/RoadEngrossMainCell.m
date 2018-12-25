//
//  InspectionMainCell.m
//  GDZhiFaJianGuanSystem
//
//  Created by quxiuyun on 14-2-22.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import "RoadEngrossMainCell.h"
#import "RoadEngrossModel.h"
#define LISTNAME_FONT [UIFont systemFontOfSize:17]
#define LISTTITLE_FONT [UIFont systemFontOfSize:15]

@implementation RoadEngrossMainCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		_labelNumber =[[UILabel alloc] initWithFrame:CGRectMake(0, 3, 50, 37)];
		_labelNumber.textAlignment = NSTextAlignmentCenter;//居中显示
        [_labelNumber setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_labelNumber];
		
        
        _labelCode =[[UILabel alloc] initWithFrame:CGRectMake(50, 3, 60, 37)];
        _labelCode.textAlignment = NSTextAlignmentCenter;//居中显示
		 [_labelCode setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_labelCode];
        
		
        _labelApproveCode =[[UILabel alloc] initWithFrame:CGRectMake(110, 3, 190, 37)];
        _labelApproveCode.textAlignment = NSTextAlignmentCenter;
        [_labelApproveCode setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_labelApproveCode];
		
		
		
		
		_labelItemType =[[UILabel alloc] initWithFrame:CGRectMake(300, 3, 100, 37)];
        _labelItemType.textAlignment = NSTextAlignmentCenter;
        [_labelItemType setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_labelItemType];
		
		
		
		_labelOwnerName =[[UILabel alloc] initWithFrame:CGRectMake(400, 3, 150, 37)];
        _labelOwnerName.textAlignment = NSTextAlignmentCenter;
        [_labelOwnerName setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_labelOwnerName];
		
		
		
		_labelLinkmanName =[[UILabel alloc] initWithFrame:CGRectMake(550, 3, 80, 37)];
        _labelLinkmanName.textAlignment = NSTextAlignmentCenter;
        [_labelLinkmanName setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_labelLinkmanName];
		
		
		
		
		_labelLinkmanPhone =[[UILabel alloc] initWithFrame:CGRectMake(630, 3, 100, 37)];
        _labelLinkmanPhone.textAlignment = NSTextAlignmentCenter;
        [_labelLinkmanPhone setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_labelLinkmanPhone];
		
		
		
		_labelDateEnd =[[UILabel alloc] initWithFrame:CGRectMake(730, 3, 180, 37)];
        _labelDateEnd.textAlignment = NSTextAlignmentCenter;
        [_labelDateEnd setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_labelDateEnd];
		
		
		
		_labelEngrossStyle =[[UILabel alloc] initWithFrame:CGRectMake(910, 3, 120, 37)];
        _labelEngrossStyle.textAlignment = NSTextAlignmentCenter;
        [_labelEngrossStyle setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_labelEngrossStyle];
		
		
		
		_labelOperation =[[UILabel alloc] initWithFrame:CGRectMake(1030, 3, 40, 37)];
        _labelOperation.textAlignment = NSTextAlignmentCenter;
        [_labelOperation setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_labelOperation];

    }
    return self;
}

-(void)titleLabel
{
	
	
    [_labelNumber setText:@"序号"];
    [_labelNumber setFont:LISTNAME_FONT];
    [_labelCode setText:@"编号"];
    [_labelCode setFont:LISTNAME_FONT];
    [_labelApproveCode setText:@"审批编号"];
    [_labelApproveCode setFont:LISTNAME_FONT];
	[_labelItemType setText:@"项目类型"];
    [_labelItemType setFont:LISTNAME_FONT];
	[_labelOwnerName setText:@"业主单位"];
    [_labelOwnerName setFont:LISTNAME_FONT];
	[_labelLinkmanName setText:@"联系人"];
    [_labelLinkmanName setFont:LISTNAME_FONT];
	[_labelLinkmanPhone setText:@"联系电话"];
    [_labelLinkmanPhone setFont:LISTNAME_FONT];
	[_labelDateEnd setText:@"占用截至日期"];
    [_labelDateEnd setFont:LISTNAME_FONT];
	[_labelEngrossStyle setText:@"占用性质"];
    [_labelEngrossStyle setFont:LISTNAME_FONT];
	[_labelOperation setText:@"操作"];
    [_labelOperation setFont:LISTNAME_FONT];
	
}

- (void)configureCellWithCaseArray:(RoadEngrossModel *)model
{
    [_labelCode setText:model.code];
    [_labelCode setFont:LISTTITLE_FONT];
	
	
    [_labelApproveCode setText:model.approve_code];
    [_labelApproveCode setFont:LISTTITLE_FONT];

    [_labelItemType setText:model.item_type];
    [_labelItemType setFont:LISTTITLE_FONT];

	[_labelOwnerName setText:model.owner_name];
    [_labelOwnerName setFont:LISTTITLE_FONT];
	
	[_labelLinkmanName setText:model.linkman_name];
    [_labelLinkmanName setFont:LISTTITLE_FONT];
	
	
	[_labelLinkmanPhone setText:model.linkman_phone];
    [_labelLinkmanPhone setFont:LISTTITLE_FONT];
	
	
	[_labelDateEnd setText:model.date_end];
    [_labelDateEnd setFont:LISTTITLE_FONT];
	
	
	
	[_labelEngrossStyle setText:model.engross_style];
    [_labelEngrossStyle setFont:LISTTITLE_FONT];
	
	

	
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
