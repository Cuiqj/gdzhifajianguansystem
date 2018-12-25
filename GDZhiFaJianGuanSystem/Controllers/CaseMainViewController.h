//
//  CaseMainViewController.h
//  GDZhiFaJianGuanSystem
//
//  Created by XU SHIWEN on 14-2-7.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CasePermitHandler.h"
#import "OrgSelectController.h"
#import "DataModelCenter.h"
#import "WebServiceHandler.h"
#import "CollapseCell.h"

@class EmployeeInfoModel;

//案件查询ViewController
@interface CaseMainViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIAlertViewDelegate,CasePermitHandler,OrgPickerDelegate,CollapseCellDelegate>

@property (strong, nonatomic) UITableView *tableCaseList;

@property (retain, nonatomic) Rpt_statisticsModel *statisticModel;

@property (retain, nonatomic) EmployeeInfoModel *employeeModel;

@property (weak, nonatomic) IBOutlet UITextField *textNumber;
@property (weak, nonatomic) IBOutlet UITextField *textParties;
@property (weak, nonatomic) IBOutlet UITextField *textCaseType;
@property (weak, nonatomic) IBOutlet UITextField *textOrg;
@property (weak, nonatomic) IBOutlet UITextField *textStartingTime;
@property (weak, nonatomic) IBOutlet UITextField *textEndTime;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIView *queryView;

@property (weak, nonatomic) IBOutlet UIButton *yearQueryBth;
@property (weak, nonatomic) IBOutlet UIButton *monthQueryBth;
@property (weak, nonatomic) IBOutlet UIButton *dayQueryBth;

@property (weak, nonatomic) IBOutlet UILabel *lebelPageNumber;//页数
@property (weak, nonatomic) IBOutlet UILabel *labelTotalNumber; //总条数
@property (weak, nonatomic) IBOutlet UIButton *buttonQuery;//右查询按钮
@property (weak, nonatomic) IBOutlet UITableView *organizationTreeTableView;

- (IBAction)bthPreviousPage:(UIButton *)sender;
- (IBAction)bthNextPage:(UIButton *)sender;

- (IBAction)bthEndPage:(UIButton *)sender;

- (IBAction)queryTextClicked:(UIButton *)sender;
- (IBAction)startingTime:(UITextField *)sender;
- (IBAction)endTime:(UITextField *)sender;
- (IBAction)queryOptions:(id)sender;
- (IBAction)caseType:(UITextField *)sender;
- (IBAction)Org:(UITextField *)sender;
- (IBAction)buttonQuery:(id)sender;

+ (instancetype)newInstance;

@end
