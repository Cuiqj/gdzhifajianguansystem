//
//  MessageCenterCell.h
//  GDZhiFaJianGuanSystem
//
//  Created by quxiuyun on 14-2-24.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageCenterCell : UITableViewCell

@property (nonatomic, strong) UILabel * labelTitle;
@property (nonatomic, strong) UILabel * labelSender;
@property (nonatomic, strong) UILabel * labelSendTime;


- (void)titleLabel;
- (void)configureCellWithMessageArray:(MessageModel *)model;

@end
