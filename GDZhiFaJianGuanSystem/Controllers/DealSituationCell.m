//
//  DealSituationCell.m
//  GDZhiFaJianGuanSystem
//
//  Created by quxiuyun on 14-2-25.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import "DealSituationCell.h"

#define LISTNAME_FONT [UIFont systemFontOfSize:19]

@implementation DealSituationCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code

        
        _labelTask =[[UILabel alloc] initWithFrame:CGRectMake(20, 3, 130, 37)];
        [_labelTask setFont:LISTNAME_FONT];
        [_labelTask setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_labelTask];
        
        _labelDealing =[[UILabel alloc] initWithFrame:CGRectMake(160, 3, 130, 37)];
        [_labelDealing setFont:LISTNAME_FONT];
        [_labelDealing setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_labelDealing];
        
        _labelCompleteTime =[[UILabel alloc] initWithFrame:CGRectMake(290, 3, 150, 37)];
        [_labelCompleteTime setFont:LISTNAME_FONT];
        [_labelCompleteTime setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_labelCompleteTime];
        
        _labelState =[[UILabel alloc] initWithFrame:CGRectMake(420, 3, 100, 37)];
        [_labelState setFont:LISTNAME_FONT];
        [_labelState setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_labelState];
        
        _labelOpinion =[[UILabel alloc] initWithFrame:CGRectMake(520, 3, 150, 37)];
        [_labelOpinion setFont:LISTNAME_FONT];
        [_labelOpinion setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_labelOpinion];
    }
    return self;
}

- (void)titleLabel{
    [_labelTask setText:@"任务"];
    [_labelDealing setText:@"处理人"];
    [_labelCompleteTime setText:@"完成时间"];
    [_labelState setText:@"状态"];
    [_labelOpinion setText:@"意见或回退原因"];
}

- (void)configureCellWithTaskSimpleArray:(TaskSimpleModel *)model
{
    [_labelTask setText:model.node_name];
    [_labelDealing setText:model.handle_username];
    [_labelCompleteTime setText:model.end_time];
    if ([model.current_status  isEqual: @"0"]) {
        [_labelState setText:@"未读"];
    }
    else if ([model.current_status  isEqual: @"1"]) {
        [_labelState setText:@"正在办理"];
    }
    else if  ([model.current_status  isEqual: @"2"]) {
        [_labelState setText:@"已经完成"];
    }
    else if  ([model.current_status  isEqual: @"3"]) {
        [_labelState setText:@"已经退回"];
    }
    
    [_labelOpinion setText:model.return_reson];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
