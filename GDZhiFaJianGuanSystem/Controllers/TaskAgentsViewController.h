//
//  TaskAgentsViewController.h
//  GDZhiFaJianGuanSystem
//
//  Created by quxiuyun on 14-2-24.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CurrentTaskModel.h"

//待办任务 - 详细ViewController
@interface TaskAgentsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>


@property (strong, nonatomic) CurrentTaskModel * currentModel;
@property (weak, nonatomic) IBOutlet UITableView *tableDocumentsList;
@property (weak, nonatomic) IBOutlet UITableView *tableAttachmentList;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segListOption;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;

- (IBAction)sgeChange:(UISegmentedControl *)sender;


@end
