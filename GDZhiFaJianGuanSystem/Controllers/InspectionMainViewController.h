//
//  InspectionMainViewController.h
//  GDZhiFaJianGuanSystem
//
//  Created by XU SHIWEN on 14-2-7.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrgSelectController.h"
#import "DataModelCenter.h"


@class EmployeeInfoModel;
//巡查信息查询ViewController
@interface InspectionMainViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (retain, nonatomic) Rpt_statisticsModel *statisticModel;
@property (retain, nonatomic) EmployeeInfoModel *employeeModel;

@property (weak, nonatomic) IBOutlet UITextField *textOrg;
@property (weak, nonatomic) IBOutlet UITextField *textStartTime;
@property (weak, nonatomic) IBOutlet UITextField *textEndTime;
@property (weak, nonatomic) IBOutlet UITableView *tabelList;
@property (weak, nonatomic) IBOutlet UIView *queryView;
@property (weak, nonatomic) IBOutlet UILabel *labelPageNumber;
@property (weak, nonatomic) IBOutlet UILabel *labelTotalNumber;
@property (weak, nonatomic) IBOutlet UIButton *buttonQuery;//右查询按钮
@property (weak, nonatomic) IBOutlet UITableView *organizationTreeTableView;


- (IBAction)queryOptions:(id)sender;
- (IBAction)Org:(UITextField *)sender;
- (IBAction)startingTime:(UITextField *)sender;
- (IBAction)endTime:(UITextField *)sender;
- (IBAction)buttonQuery:(id)sender;

- (IBAction)bthPreviousPage:(UIButton *)sender;
- (IBAction)bthNextPage:(UIButton *)sender;
- (IBAction)bthEndPage:(UIButton *)sender;

+ (instancetype)newInstance;

@end
