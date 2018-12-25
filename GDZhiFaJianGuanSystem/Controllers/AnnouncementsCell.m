//
//  AnnouncementsCell.m
//  GDZhiFaJianGuanSystem
//
//  Created by quxiuyun on 14-2-24.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import "AnnouncementsCell.h"

#define LISTNAME_FONT [UIFont systemFontOfSize:22]
#define LISTTITLE_FONT [UIFont systemFontOfSize:20]
@implementation AnnouncementsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _labelTheme =[[UILabel alloc] initWithFrame:CGRectMake(60, 3, 360, 37)];
        
        [_labelTheme setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_labelTheme];
        
        _labelReleasePeople =[[UILabel alloc] initWithFrame:CGRectMake(450, 3, 320, 37)];
        
        [_labelReleasePeople setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_labelReleasePeople];
        
        _labelReleaseDate =[[UILabel alloc] initWithFrame:CGRectMake(780, 3, 320, 37)];
        
        [_labelReleaseDate setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_labelReleaseDate];
    }
    return self;
}

- (void)titleLabel{
    [_labelTheme setText:@"主题"];
    [_labelTheme setFont:LISTNAME_FONT];
    [_labelReleasePeople setText:@"发布人"];
    [_labelReleasePeople setFont:LISTNAME_FONT];
    [_labelReleaseDate setText:@"发布日期"];
    [_labelReleaseDate setFont:LISTNAME_FONT];
}

- (void)configureCellWithOrgArticleArray:(OrgArticleModel *)model
{
    [_labelTheme setText:model.title];
    [_labelTheme setFont:LISTTITLE_FONT];
    [_labelReleasePeople setText:model.senderPerson];
    [_labelReleasePeople setFont:LISTTITLE_FONT];
    [_labelReleaseDate setText:model.publicize_date];
    [_labelReleaseDate setFont:LISTTITLE_FONT];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
