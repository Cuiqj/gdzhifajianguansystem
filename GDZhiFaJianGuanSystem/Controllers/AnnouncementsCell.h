//
//  AnnouncementsCell.h
//  GDZhiFaJianGuanSystem
//
//  Created by quxiuyun on 14-2-24.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrgArticleModel.h"

@interface AnnouncementsCell : UITableViewCell


@property (nonatomic, strong) UILabel * labelTheme;
@property (nonatomic, strong) UILabel * labelReleasePeople;
@property (nonatomic, strong) UILabel * labelReleaseDate;


- (void)titleLabel;
- (void)configureCellWithOrgArticleArray:(OrgArticleModel *)model;

@end
