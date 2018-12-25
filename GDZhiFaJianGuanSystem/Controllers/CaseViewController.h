//
//  CaseViewController.h
//  GDZhiFaJianGuanSystem
//
//  Created by quxiuyun on 14-2-18.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AllCaseModel.h"

//案件查询ViewController下 的案件信息
@interface CaseViewController : UIViewController<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate>

//文书区
@property (nonatomic,retain) NSMutableArray *docListArray;
//附件区
@property (nonatomic,retain) NSMutableArray *attachmentArray;
//详情数组
@property (nonatomic,retain) AllCaseModel * caseInfoModel;


@property (weak, nonatomic) IBOutlet UITextField *caseNumber;
@property (weak, nonatomic) IBOutlet UITextField *caseTime;
@property (weak, nonatomic) IBOutlet UITextView *textBasicSituation;
@property (weak, nonatomic) IBOutlet UITextField *citizenName;
@property (weak, nonatomic) IBOutlet UITextField *route;
@property (weak, nonatomic) IBOutlet UITextField *startPointPileNo;
@property (weak, nonatomic) IBOutlet UITextField *endPointPileNo;
@property (weak, nonatomic) IBOutlet UITextField *direction;
@property (weak, nonatomic) IBOutlet UITextField *caseWeather;
@property (weak, nonatomic) IBOutlet UITextField *claimAmount;

@property (weak, nonatomic) IBOutlet UITextField *casereasonAuto;
@property (weak, nonatomic) IBOutlet UITextField *claimAmountReality;

@property (weak, nonatomic) IBOutlet UITextField *damageRoad;
@property (weak, nonatomic) IBOutlet UITextField *IllegalBehavior;
@property (weak, nonatomic) IBOutlet UITextField *stationEnd;
@property (weak, nonatomic) IBOutlet UITextField *quanzongNo;
@property (weak, nonatomic) IBOutlet UITextField *anjuanNo;
@property (weak, nonatomic) IBOutlet UITextField *secret;
@property (weak, nonatomic) IBOutlet UITextField *fileNo;
@property (weak, nonatomic) IBOutlet UITextField *eecordsRetentionTime;


@property (weak, nonatomic) IBOutlet UITextView *textPerformSituation;
@property (weak, nonatomic) IBOutlet UIView *background;

@property (weak, nonatomic) IBOutlet UIView *viewInfoPage;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UITableView *docListView;//文书View
@property (weak, nonatomic) IBOutlet UITableView *attachmentView;//附件区


- (IBAction)changeInfoPage:(UISegmentedControl *)sender;
@end