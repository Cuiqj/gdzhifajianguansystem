//
//  PersonnelManagementCell.m
//  GDZhiFaJianGuanSystem
//
//  Created by quxiuyun on 14-3-5.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import "PersonnelManagementCell.h"
#import "CustomPersonButton.h"

#define LISTNAME_FONT [UIFont systemFontOfSize:17]
#define LISTTITLE_FONT [UIFont systemFontOfSize:15]
@implementation PersonnelManagementCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _labelNumber =[[UILabel alloc] initWithFrame:CGRectMake(2, 3, 45, 37)];
        _labelNumber.textAlignment = NSTextAlignmentCenter;
        _labelAccount.textAlignment = NSTextAlignmentCenter;
        [_labelNumber setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_labelNumber];
        
        _labelName =[[UILabel alloc] initWithFrame:CGRectMake(30, 3, 100, 37)];
        _labelName.textAlignment = NSTextAlignmentCenter;
        [_labelName setBackgroundColor:[UIColor clearColor]];
        _labelName.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_labelName];
        
        _labelAccount =[[UILabel alloc] initWithFrame:CGRectMake(100, 3, 100, 37)];
        _labelAccount.textAlignment = NSTextAlignmentCenter;
        [_labelAccount setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_labelAccount];
        

		_labelOperation =[[UILabel alloc] initWithFrame:CGRectMake(230, 3, 100, 37)];
        [_labelOperation setBackgroundColor:[UIColor clearColor]];
        _labelOperation.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_labelOperation];
		
        _labelPhone =[[UILabel alloc] initWithFrame:CGRectMake(370, 3, 150, 37)];
        _labelPhone.textAlignment = NSTextAlignmentCenter;
        [_labelPhone setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_labelPhone];
        
        _labelPosition =[[UILabel alloc] initWithFrame:CGRectMake(460, 3, 150, 37)];
        _labelPosition.textAlignment = NSTextAlignmentCenter;
        [_labelPosition setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_labelPosition];
        
		
		_caseSearchButton =[UIButton buttonWithType:UIButtonTypeRoundedRect];
        _caseSearchButton.frame = CGRectMake(200, 3, 60, 33);
        [self.contentView addSubview:_caseSearchButton];
        _inspectionSearchButton =[UIButton buttonWithType:UIButtonTypeRoundedRect];
        _inspectionSearchButton.frame = CGRectMake(265, 3, 60, 33);
        [self.contentView addSubview:_inspectionSearchButton];
        _permitSearchButton =[UIButton buttonWithType:UIButtonTypeRoundedRect];
        _permitSearchButton.frame = CGRectMake(330, 3, 60, 33);
        [self.contentView addSubview:_permitSearchButton];
		

		
		

		_labelOrg = [[UILabel alloc] initWithFrame:CGRectMake(560, 3, 250, 37)];
        _labelOrg.textAlignment = NSTextAlignmentCenter;
        [_labelOrg setBackgroundColor:[UIColor clearColor]];
        _labelOrg.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_labelOrg];


    }
    return self;
}

-(void)titleLabel{
    [_labelNumber setText:@"序号"];
    [_labelNumber setFont:LISTNAME_FONT];
    [_labelName setText:@"姓 名"];
    [_labelName setFont:LISTNAME_FONT];
    [_labelAccount setText:@"执法证号"];
    [_labelAccount setFont:LISTNAME_FONT];
    [_labelOperation setText:@"操作"];
    [_labelOperation setFont:LISTNAME_FONT];
    [_labelPhone setText:@"联系电话"];
    [_labelPhone setFont:LISTNAME_FONT];
    [_labelPosition setText:@"职务"];
    [_labelPosition setFont:LISTNAME_FONT];
	[_labelOrg setText:@"所属机构"];
    [_labelOrg setFont:LISTNAME_FONT];
}

-(void)configureCellWithAllPermitArray:(EmployeeInfoModel *)model
{
//    [_labelNumber setText:model.orderdesc];
    [_labelNumber setFont:LISTTITLE_FONT];
    [_labelName setText:model.name];
    [_labelName setFont:LISTTITLE_FONT];
    [_labelAccount setText:model.enforce_code];
    [_labelAccount setFont:LISTTITLE_FONT];
//    [_labelOrg setText:model.organization_id];
    [_labelOrg setFont:LISTTITLE_FONT];
    [_labelPhone setText:model.telephone];
    [_labelPhone setFont:LISTTITLE_FONT];
    [_labelPosition setText:model.duty];
    [_labelPosition setFont:LISTTITLE_FONT];
    [_caseSearchButton setTitle:@"案件" forState:UIControlStateNormal];
//    [_caseSearchButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_inspectionSearchButton setTitle:@"巡查" forState:UIControlStateNormal];
//    [_inspectionSearchButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_permitSearchButton setTitle:@"许可" forState:UIControlStateNormal];
//    [_permitSearchButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
