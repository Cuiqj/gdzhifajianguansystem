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
#import "RoadPickerViewController.h"
#import "CasePermitPickerViewController.h"
@class EmployeeInfoModel;
//巡查信息查询ViewController
@interface RoadEngrossMainViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,RoadPickerDelegate,CasePermitHandler>

@property (retain, nonatomic) Rpt_statisticsModel *statisticModel;
@property (retain, nonatomic) EmployeeInfoModel *employeeModel;
@property (weak, nonatomic) IBOutlet UITextField *textRoadId;
@property (weak, nonatomic) IBOutlet UITextField *textStation_start;
@property (weak, nonatomic) IBOutlet UITextField *textStation_end;
@property (weak, nonatomic) IBOutlet UITextField *textDeal_with;
@property (weak, nonatomic) IBOutlet UITextField *textDateStart;
@property (weak, nonatomic) IBOutlet UITextField *textDateEnd;
@property (weak, nonatomic) IBOutlet UITextField *textAppCode;
@property (weak, nonatomic) IBOutlet UITableView *tabelList;
@property (weak, nonatomic) IBOutlet UIView *queryView;
@property (weak, nonatomic) IBOutlet UILabel *labelPageNumber;
@property (weak, nonatomic) IBOutlet UILabel *labelTotalNumber;
@property (weak, nonatomic) IBOutlet UIButton *buttonQuery;//右查询按钮
@property (weak, nonatomic) IBOutlet UITableView *organizationTreeTableView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


- (IBAction)queryOptions:(id)sender;
- (IBAction)Org:(UITextField *)sender;
- (IBAction)startingTime:(UITextField *)sender;
- (IBAction)endTime:(UITextField *)sender;
- (IBAction)buttonQuery:(id)sender;

- (IBAction)bthPreviousPage:(UIButton *)sender;
- (IBAction)bthNextPage:(UIButton *)sender;
- (IBAction)bthEndPage:(UIButton *)sender;
- (IBAction)roadId:(UITextField *)sender;
- (IBAction)dealWith:(UITextField *)sender;
+ (instancetype)newInstance;

@end
