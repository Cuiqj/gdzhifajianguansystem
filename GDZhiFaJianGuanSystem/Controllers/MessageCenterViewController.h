//
//  MessageCenterViewController.h
//  GDZhiFaJianGuanSystem
//
//  Created by quxiuyun on 14-3-12.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import <UIKit/UIKit.h>

//消息中心界面
@interface MessageCenterViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>



@property (weak, nonatomic) IBOutlet UILabel *labelUserName;
@property (weak, nonatomic) IBOutlet UILabel *labelState;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UIView *backGroundView;
@property (weak, nonatomic) IBOutlet UITableView *tableMessageList;

- (IBAction)listOption:(id)sender;


@end
