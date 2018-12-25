//
//  StatisticsMainViewController.h
//  GDZhiFaJianGuanSystem
//
//  Created by XU SHIWEN on 14-2-7.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OrgSelectController.h"
#import "EColumnChart.h"
#import "CaseNumTypeViewController.h"
#import "CollapseCell.h"
#import "MonthYearSelectController.h"
#import "YearQuarterSelectController.h"
#import "YearSelectController.h"
@interface StatisticsMainViewController : UIViewController <UITextFieldDelegate,OrgPickerDelegate,UITableViewDataSource,UITableViewDelegate, UIGestureRecognizerDelegate,CaseNumTypePickerDelegate,CollapseCellDelegate,MonthYearSelectDelegate,YearSelectDelegate,YearQuarterSelectDelegate>


@property (weak, nonatomic) IBOutlet UISegmentedControl *segList;




//不要共用一个NSMutableArray
@property (retain, nonatomic) NSMutableArray * caseStatisticsDataSource;
@property (retain, nonatomic) NSMutableArray * caseComparisonDataSource;
@property (retain, nonatomic) NSMutableArray * permissionStatisticsDataSource;
@property (retain, nonatomic) NSMutableArray * permissionComparisonDataSource;
@property (retain, nonatomic) NSMutableArray * patrolStatisticsDataSource;
@property (retain, nonatomic) NSMutableArray * patrolComparisonDataSource;
@property (retain, nonatomic) NSMutableArray * permitExpireDataSource;
@property (retain, nonatomic) NSMutableArray * permitWarningDataSource;
@property (retain, nonatomic) NSMutableArray * dataSource;
@property (retain, nonatomic) NSDictionary * dicData;
@property (weak, nonatomic) IBOutlet UIView *subView;
@property (strong, nonatomic) UIPopoverController *myPopoverController;
- (IBAction)changeInfoPage:(UISegmentedControl *)sender;
- (IBAction)Org:(UITextField *)sender;
- (IBAction)startingTime:(UITextField *)sender;
- (IBAction)buttonQuery:(id)sender;
- (IBAction)queryOptions:(id)sender;
+ (instancetype)newInstance;
@property (weak, nonatomic) IBOutlet UILabel *startingTimeLabel;

@end
