//
//  MessageCenterCell.m
//  GDZhiFaJianGuanSystem
//
//  Created by quxiuyun on 14-2-24.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import "MessageCenterCell.h"
#import "MessageModel.h"
#define LISTNAME_FONT [UIFont systemFontOfSize:22]
#define LISTTITLE_FONT [UIFont systemFontOfSize:20]
@implementation MessageCenterCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _labelTitle =[[UILabel alloc] initWithFrame:CGRectMake(60, 3, 380, 37)];
        
        [_labelTitle setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_labelTitle];
        
        _labelSender =[[UILabel alloc] initWithFrame:CGRectMake(420, 3, 320, 37)];
        
        [_labelSender setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_labelSender];
        
        _labelSendTime =[[UILabel alloc] initWithFrame:CGRectMake(740, 3, 320, 37)];
        
        [_labelSendTime setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_labelSendTime];

    }
    return self;
}

- (void)titleLabel{
    [_labelTitle setText:@"标题"];
    [_labelSender setText:@"发送人"];
    [_labelSendTime setText:@"发送时间"];
    [_labelTitle setFont:LISTNAME_FONT];
    [_labelSender setFont:LISTNAME_FONT];
    [_labelSendTime setFont:LISTNAME_FONT];
}

- (void)configureCellWithMessageArray:(MessageModel *)model
{
    [_labelTitle setText:model.title];
    [_labelTitle setFont:LISTTITLE_FONT];
    [_labelSender setText:model.sender_name];
    [_labelSender setFont:LISTTITLE_FONT];
    [_labelSendTime setText:model.send_date];
    [_labelSendTime setFont:LISTTITLE_FONT];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
