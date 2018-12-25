//
//  PermitMainViewController.h
//  GDZhiFaJianGuanSystem
//
//  Created by XU SHIWEN on 14-2-7.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrgSelectController.h"
#import "CasePermitHandler.h"
#import "DataModelCenter.h"
#import "CollapseCell.h"
@class EmployeeInfoModel;

//许可查询ViewController
@interface PermitMainViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,OrgPickerDelegate,CasePermitHandler,CollapseCellDelegate>

+ (instancetype)newInstance;

@property (strong, nonatomic)  UITableView *tableCaseList;
@property (retain, nonatomic) Rpt_statisticsModel *statisticModel;
@property (retain, nonatomic) EmployeeInfoModel *employeeModel;
@property (nonatomic, retain) NSMutableArray * allOrgID;//全部机构ID


@property (weak, nonatomic) IBOutlet UITextField *textNumber;
@property (weak, nonatomic) IBOutlet UITextField *textItemsApplication;
@property (weak, nonatomic) IBOutlet UITextField *textPermitType;
@property (weak, nonatomic) IBOutlet UITextField *textOrg;
@property (weak, nonatomic) IBOutlet UITextField *textStartTime;
@property (weak, nonatomic) IBOutlet UITextField *textEndTime;
@property (weak, nonatomic) IBOutlet UIView *queryView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *yearQueryButton;
@property (weak, nonatomic) IBOutlet UIButton *monthQueryButton;
@property (weak, nonatomic) IBOutlet UIButton *dayQueryButton;
@property (weak, nonatomic) IBOutlet UILabel *lebelPageNumber;
@property (weak, nonatomic) IBOutlet UILabel *labelTotalNumber;
@property (weak, nonatomic) IBOutlet UIButton *buttonQuery;//右查询按钮
@property (weak, nonatomic) IBOutlet UITableView *organizationTreeTableView;


- (IBAction)Org:(UITextField *)sender;
- (IBAction)queryOptions:(id)sender;
- (IBAction)permitType:(UITextField *)sender;
- (IBAction)queryButtonClicked:(UIButton *)sender;//点击年，月，日 Button

- (IBAction)startingTime:(UITextField *)sender;
- (IBAction)endTime:(UITextField *)sender;

- (IBAction)buttonQuery:(id)sender;

- (IBAction)bthPreviousPage:(UIButton *)sender;
- (IBAction)bthNextPage:(UIButton *)sender;

- (IBAction)bthEndPage:(UIButton *)sender;

@end
