//
//  DealSituationViewController.h
//  GDZhiFaJianGuanSystem
//
//  Created by quxiuyun on 14-2-25.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import <UIKit/UIKit.h>

//办理情况TableView
@interface DealSituationViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableViewList;
@property (retain, nonatomic)NSMutableArray * dataArray;

@end
