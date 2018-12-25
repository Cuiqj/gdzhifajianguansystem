//  StatisticsMainViewController.m
//  GDZhiFaJianGuanSystem
//
//  Created by XU SHIWEN on 14-2-7.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import "StatisticsMainViewController.h"
#import "DateSelectController.h"
#import "DataModelCenter.h"
#import "CaseMainViewController.h"
#import "PermitMainViewController.h"
#import "InspectionMainViewController.h"
#import "TreeViewNode.h"
#import "CollapseCell.h"
#import "AppUtil.h"
#import "RadioButton.h"
#import "MBProgressHUD.h"

#define SCROLLVIEW_WIDTH 1320.0
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define LISTNAME_FONT [UIFont systemFontOfSize:17]
// 获取数据后的回调
typedef void (^GetSupervisionRptStatisticsListHandle)(NSMutableArray *statisticsList, NSError *err);
typedef void (^GetSupervisionPermitExpireSizeHandle)(NSInteger size, NSError *err);
@interface StatisticsMainViewController ()<UIPopoverControllerDelegate,DatetimePickerHandler>{
    int maxValueIndex;
    NSString *dateForWeb;
    NSString *todayDateString;
	
	NSInteger segmentIndex;
	//记录当前caseView是选中了那个segment
	NSInteger caseSegmentIndex;
	//记录当前permissionView是选中了那个segment
	NSInteger permissionSegmentIndex;
	//记录当前patrolView是选中了那个segment
	NSInteger patrolSegmentIndex;
	UITableView *localTableView;
	//被选中的机构
	CollapseCell *orgCell;
	UITableView *organizationTreeTableView;
	
	//不要公用一个UITableView
	UITableView *caseComparisonTableView;
	UITableView *permissionMaturityQueryTableView;
	UITableView *permissionWarningsTableView;
	UITableView *permissionStatisticsTableView;
	UITableView *permissionComparisonTableView;
	UITableView *patrolStatisticsTableView;
	UITableView *patrolComparisonTableView;
	
	
	//单选按钮
	RadioButton* yearRadioButton;
	RadioButton* monthRadioButton;
	RadioButton* quarterRadioButton;
	RadioButton* sectionRadioButton;
	
	
	
	UILabel* quarterSectionBeginLabel;
	UILabel* quarterSectionEndLabel;
	UILabel* yearMonthLabel;
	
	UITextField* quarterSectionBeginTextField;
	UITextField* quarterSectionEndTextField;
	UITextField* yearMonthTextField;
	
	//查询按钮
	UIButton *queryButton;
	
	
	//radio类型
	//0是年
	// 1是月
	//2是季节
	//3是区间
	NSInteger radioSelectedType;
	
	NSString *html;
	NSURL *baseURL;
	UILabel *timeLabel;
	
	NSInteger permitExpireType;
	
}

@property (nonatomic, retain) NSMutableArray *displayArray;
//通用的，这个界面的所有弹出框都是用这个变量来保存
@property (nonatomic, retain) UIPopoverController * popover;
@property (nonatomic, assign) NSInteger buttonIndex; // 查询button
@property (nonatomic, assign) UITextField * currentTextField;
@property (nonatomic, strong) EColumn *eColumnSelected;
@property (nonatomic, strong)UIViewController* popoverContent;
@property (nonatomic, strong)MBProgressHUD *hud;
//保持弹出框的tag
@property (nonatomic,assign) NSInteger touchTextTag;
@property (nonatomic, strong) NSMutableArray * childOrgArray;//机构第一层数组
@property (nonatomic, strong) NSString * orgID;
@property (nonatomic, strong) NSNumber *startYear;
@property (nonatomic, strong) NSNumber *endYear;
@property (nonatomic, strong) NSNumber *startMonth;
@property (nonatomic, strong) NSNumber *endMonth;
@property (nonatomic, strong) NSNumber *page;
@property  (nonatomic,assign) NSInteger pagenum;
@property  (nonatomic,assign) NSInteger totalPageNum;
@end

@implementation StatisticsMainViewController
@synthesize eColumnSelected=_eColumnSelected;

+ (instancetype)newInstance
{
    return [[[self alloc] initWithNibName:@"StatisticsMainView" bundle:nil] prepareForUse];
}

- (id)prepareForUse
{
    //在这里完成一些内部参数的初始化
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	[[[DataModelCenter defaultCenter] webService].queue cancelAllOperations];
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
        if ( IOS7_OR_LATER )
        {
            self.edgesForExtendedLayout = UIRectEdgeNone;
            self.extendedLayoutIncludesOpaqueBars = NO;
            self.modalPresentationCapturesStatusBarAppearance = NO;
        }
#endif // #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
	
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	//如果弹出框弹出来则关闭
    if ([self.popover isPopoverVisible]) {
        [self.popover dismissPopoverAnimated:animated];
    }

}

- (void)viewDidLoad
{
	_hud = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:_hud];
	

	
	//设置对话框文字
	_hud.labelText = SOAP_SERVER_RESPONSE_ERROR;

	 _hud.mode = MBProgressHUDModeText;
	
	//创建一个新的控制器
    _popoverContent = [[UIViewController alloc] init];
	_myPopoverController=[[UIPopoverController alloc]initWithContentViewController:_popoverContent];
	//初始化一些常量
	segmentIndex = 0;
	caseSegmentIndex = 0;
	permissionSegmentIndex = 0;
	patrolSegmentIndex = 0;
	self.popover=[[UIPopoverController alloc] initWithContentViewController:[[UIViewController alloc] init]];
	self.page = [[NSNumber alloc]initWithInt:1];
	self.pagenum = 1;
	
	
	//初始化查询条件
	self.orgID=[[NSUserDefaults standardUserDefaults] objectForKey:ORGKEY];
	NSDate *currentDate = [NSDate date];
	NSCalendar* calendar = [NSCalendar currentCalendar];
	NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:currentDate]; // Get necessary date components
	self.startYear = [[NSNumber alloc ]initWithInt:[components year]];
	self.startMonth = [[NSNumber alloc ]initWithInt:[components month]];
	self.endYear = nil;
	self.endMonth = nil;
	radioSelectedType = 1;
	
	
	
		
    [super viewDidLoad];
	
	
    [self setTitle:@"统计信息"];
    UIBarButtonItem * backbutton =[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(backButton)];
    [self.navigationItem setLeftBarButtonItem:backbutton animated:YES];
    
	
	//切换到第一个segement
	self.segList.selectedSegmentIndex = 0;
	[self changeInfoPage:self.segList];
	
	if (ORG_TREE == nil ||[ORG_TREE count]==0) {
			
		[[[DataModelCenter defaultCenter] webService] getSupervisionLowerOrgList:@"" withAsyncHanlder:^(NSArray *orgList, NSError *err) {
			if (err == nil) {
				dispatch_sync(dispatch_get_main_queue(), ^{
					if (ORG_TREE == nil ||[ORG_TREE count]==0) {
						[AppUtil getTreeViewNode:orgList];
					}
					[self fillDisplayArray];
					[organizationTreeTableView reloadData];
				});
			}
		}];
	}

	
    


}


//This function is used to fill the array that is actually displayed on the table view
- (void)fillDisplayArray
{
    self.displayArray = [[NSMutableArray alloc]init];
    for (TreeViewNode *node in ORG_TREE) {
        [self.displayArray addObject:node];
        if ([node.nodeChildren count] > 0 && node.isExpanded == YES) {
            [self fillNodeWithChildrenArray:node.nodeChildren];
        }
    }
}

//This function is used to add the children of the expanded node to the display array
- (void)fillNodeWithChildrenArray:(NSArray *)childrenArray
{
    for (TreeViewNode *node in childrenArray) {
        [self.displayArray addObject:node];
        if ([node.nodeChildren count] > 0 && node.isExpanded == YES) {
            [self fillNodeWithChildrenArray:node.nodeChildren];
        }
    }
}





- (void)setDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy年MM月";
    NSString *dateString = [formatter stringFromDate:date];

    _currentTextField.text = dateString;
}
-(void)addItemsToStatisticsNewModelArray:(NSMutableArray*)statisticsNewModelArray{
	if([statisticsNewModelArray count] <= 0){
		return;
	}
	StatisticsNewModel *statisticsNewModel = [StatisticsNewModel newModel];
	statisticsNewModel.names = @"合计：";
	statisticsNewModel.num_begin = 0;
	statisticsNewModel.num_end = 0;
	statisticsNewModel.num_notend = 0;
	statisticsNewModel.money_count = 0;
	statisticsNewModel.money_fact = 0;
	for(StatisticsNewModel *model in statisticsNewModelArray){
		
		statisticsNewModel.num_begin =  [[NSNumber alloc ]initWithInt:[model.num_begin intValue] + [statisticsNewModel.num_begin intValue] ];
		statisticsNewModel.num_end = [[NSNumber alloc ]initWithInt:[model.num_end intValue] + [statisticsNewModel.num_end intValue] ];
		statisticsNewModel.num_notend = [[NSNumber alloc ]initWithInt:[model.num_notend intValue] + [statisticsNewModel.num_notend intValue] ];
		statisticsNewModel.money_count = [[NSNumber alloc ]initWithInt:[model.money_count doubleValue] + [statisticsNewModel.money_count doubleValue] ];
		statisticsNewModel.money_fact = [[NSNumber alloc ]initWithInt:[model.money_fact doubleValue] + [statisticsNewModel.money_fact doubleValue] ];
	}
	[statisticsNewModelArray addObject:statisticsNewModel];

}
- (GetSupervisionRptStatisticsListHandle)caseStatisticsRequestHandle{
	return ^(NSMutableArray *statisticsNewModelArray,NSError *err){
		dispatch_sync(dispatch_get_main_queue(), ^{
			if (err != nil && [err.domain isEqual:SOAP_SERVER_RESPONSE_ERROR]) {
				//显示对话框
				[_hud showAnimated:YES whileExecutingBlock:^{
					//对话框显示时需要执行的操作
					sleep(1);
				} completionBlock:^{
					//操作执行完后取消对话框
					
				}];
				return;
			}
			self.caseStatisticsDataSource = statisticsNewModelArray;
			
			//加载柱形图
			NSString *series = @"";
			for(StatisticsNewModel *statisticsNewModel in statisticsNewModelArray){
				series = [series stringByAppendingFormat:@"{ name: '%@', data: [%@,%@,%@]},",statisticsNewModel.names,statisticsNewModel.num_begin,statisticsNewModel.num_end,statisticsNewModel.num_notend];
			}
			UIWebView *webView = (UIWebView*)[self.view viewWithTag:601];
			
			
			NSString *path = [[NSBundle mainBundle] pathForResource:@"3dcloumn" ofType:@"html"  inDirectory:@"html"];
			NSURL *localBaseURL = [NSURL fileURLWithPath:path];
			NSString *localHtml = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
			localHtml = [NSString stringWithFormat:localHtml,@"['案发数量','结案数量','当前未结案数量']  ",series];
			
			path = [[NSBundle mainBundle] pathForResource:@"3dBigcloumn" ofType:@"html"  inDirectory:@"html"];
			baseURL = [NSURL fileURLWithPath:path];
			html = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
			html = [NSString stringWithFormat:html,@"['案发数量','结案数量','当前未结案数量']  ",series];
			
			[self webViewADDGesture:webView];

			
			
			
			[self addItemsToStatisticsNewModelArray:statisticsNewModelArray];
			[localTableView reloadData];
			
			
			
			[webView loadHTMLString:localHtml baseURL:localBaseURL];
		});
	};
}
- (GetSupervisionRptStatisticsListHandle)permissionStatisticsRequestHandle{
	return ^(NSMutableArray *statisticsNewModelArray,NSError *err){
		dispatch_sync(dispatch_get_main_queue(), ^{
			if (err != nil && [err.domain isEqual:SOAP_SERVER_RESPONSE_ERROR]) {
				//显示对话框
				[_hud showAnimated:YES whileExecutingBlock:^{
					//对话框显示时需要执行的操作
					sleep(1);
				} completionBlock:^{
					//操作执行完后取消对话框
					
				}];
				return;
			}
			self.permissionStatisticsDataSource = statisticsNewModelArray;
			//加载柱形图
			NSString *series = @"";
			for(StatisticsNewModel *statisticsNewModel in statisticsNewModelArray){
				series = [series stringByAppendingFormat:@"{ name: '%@', data: [%@,%@,%@]},",statisticsNewModel.names,statisticsNewModel.num_begin,statisticsNewModel.num_end,statisticsNewModel.num_notend];
			}
			UIWebView *webView = (UIWebView*)[self.view viewWithTag:601];
			NSString *path = [[NSBundle mainBundle] pathForResource:@"permissionStatistics3dcloumn" ofType:@"html"  inDirectory:@"html"];
			NSURL *localBaseURL = [NSURL fileURLWithPath:path];
			NSString *localHtml = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
			localHtml = [NSString stringWithFormat:localHtml,@"['案发数量','结案数量','当前未结案数量']  ",series];
			
			
			
			path = [[NSBundle mainBundle] pathForResource:@"bigPermissionStatistics3dcloumn" ofType:@"html"  inDirectory:@"html"];
			baseURL = [NSURL fileURLWithPath:path];
			html = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
			html = [NSString stringWithFormat:html,@"['案发数量','结案数量','当前未结案数量']  ",series];
			
			
			[self webViewADDGesture:webView];
			[webView loadHTMLString:localHtml baseURL:localBaseURL];
			[self addItemsToStatisticsNewModelArray:statisticsNewModelArray];
			[permissionStatisticsTableView reloadData];
		});
		
	};
}
- (GetSupervisionRptStatisticsListHandle)patrolStatisticsRequestHandle{
	return ^(NSMutableArray *statisticsNewModelArray,NSError *err){
		dispatch_sync(dispatch_get_main_queue(), ^{
			if (err != nil && [err.domain isEqual:SOAP_SERVER_RESPONSE_ERROR]) {
				//显示对话框
				[_hud showAnimated:YES whileExecutingBlock:^{
					//对话框显示时需要执行的操作
					sleep(1);
				} completionBlock:^{
					//操作执行完后取消对话框
					
				}];
				return;
			}
			self.patrolStatisticsDataSource = statisticsNewModelArray;
			//加载柱形图
			NSString *series = @"";
			for(StatisticsNewModel *statisticsNewModel in statisticsNewModelArray){
				series = [series stringByAppendingFormat:@"{ name: '%@', data: [%@]},",statisticsNewModel.names,statisticsNewModel.num_begin];
			}
			UIWebView *webView = (UIWebView*)[self.view viewWithTag:601];
			NSString *path = [[NSBundle mainBundle] pathForResource:@"oneSeries3dcloumn" ofType:@"html"  inDirectory:@"html"];
			NSURL *localBaseURL = [NSURL fileURLWithPath:path];
			NSString *localHtml = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
			localHtml = [NSString stringWithFormat:localHtml,@"['']  ",series];
			
			
			path = [[NSBundle mainBundle] pathForResource:@"bigOneSeries3dcloumn" ofType:@"html"  inDirectory:@"html"];
			baseURL = [NSURL fileURLWithPath:path];
			html = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
			html = [NSString stringWithFormat:html,@"['']  ",series];
			
			
			[self webViewADDGesture:webView];
			[webView loadHTMLString:localHtml baseURL:localBaseURL];
			[self addItemsToStatisticsNewModelArray:statisticsNewModelArray];
			[patrolStatisticsTableView reloadData];
		});
		
	};
}
-(void)addItemsToStatisticsLowerOrgModelArray:(NSMutableArray*)statisticsLowerOrgModelArray{
	if([statisticsLowerOrgModelArray count] <= 0){
		return;
	}
	StatisticsLowerOrgModel *statisticsLowerOrgModel = [StatisticsLowerOrgModel newModel];
	statisticsLowerOrgModel.orgShortName = @"合计：";
	statisticsLowerOrgModel.num = 0;
	NSInteger serialnumber = 1;
	for(StatisticsLowerOrgModel *model in statisticsLowerOrgModelArray){
		model.serialnumber = [[NSNumber alloc ]initWithInt:serialnumber++];
		statisticsLowerOrgModel.num =  [[NSNumber alloc ]initWithLong:[model.num longValue] + [statisticsLowerOrgModel.num longValue] ];
	}
	[statisticsLowerOrgModelArray addObject:statisticsLowerOrgModel];
}
- (GetSupervisionRptStatisticsListHandle)caseComparisonRequestHandle{
	return ^(NSMutableArray *statisticsLowerOrgModelArray,NSError *err){
		dispatch_sync(dispatch_get_main_queue(), ^{
			if (err != nil && [err.domain isEqual:SOAP_SERVER_RESPONSE_ERROR]) {
				//显示对话框
				[_hud showAnimated:YES whileExecutingBlock:^{
					//对话框显示时需要执行的操作
					sleep(1);
				} completionBlock:^{
					//操作执行完后取消对话框
					
				}];
				return;
			}
			self.caseComparisonDataSource = statisticsLowerOrgModelArray;
			
			
			//加载柱形图
			NSString *series = @"";
			NSString *categories = @"";
			for(StatisticsLowerOrgModel *statisticsLowerOrgModel in statisticsLowerOrgModelArray){
				series = [series stringByAppendingFormat:@"%@,",statisticsLowerOrgModel.num];
				categories = [categories stringByAppendingFormat:@"'%@',",statisticsLowerOrgModel.orgShortName];
			}
			UIWebView *webView = (UIWebView*)[self.view viewWithTag:601];
			NSString *path = [[NSBundle mainBundle] pathForResource:@"column-basic" ofType:@"html"  inDirectory:@"html"];
			NSURL *localBaseURL = [NSURL fileURLWithPath:path];
			NSString *localHtml = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
			NSString * temp = @"";
			if((self.startYear.integerValue != self.endYear.integerValue || self.startMonth.integerValue != self.endMonth.integerValue)
			   && self.endYear.integerValue != 0 && self.endMonth.integerValue != 0)
				temp = [NSString stringWithFormat:@"从%d年%d月到%d年%d月",[self.startYear intValue],[self.startMonth intValue],[self.endYear intValue],[self.endMonth intValue]];
			else{
				temp = [NSString stringWithFormat:@"%d年%d月",[self.startYear intValue],[self.startMonth intValue]];
			}
			if([self.page intValue]== 2){
				temp = [temp stringByAppendingString:@"结案数量"];
			}else if([self.page intValue] == 3){
				temp = [temp stringByAppendingString:@"当前未结案数量"];
			}else{
				temp = [temp stringByAppendingString:@"发案数量"];
			}
			localHtml = [NSString stringWithFormat:localHtml,temp,categories,series];
			
			
			
			
			path = [[NSBundle mainBundle] pathForResource:@"bigcolumn-basic" ofType:@"html"  inDirectory:@"html"];
			baseURL = [NSURL fileURLWithPath:path];
			html = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
			html = [NSString stringWithFormat:html,temp,categories,series];
			
			
			[self webViewADDGesture:webView];
			[webView loadHTMLString:localHtml baseURL:localBaseURL];
			
			
			[self addItemsToStatisticsLowerOrgModelArray:statisticsLowerOrgModelArray];
			[caseComparisonTableView reloadData];
		});
		
	};
}

- (GetSupervisionRptStatisticsListHandle)permissionComparisonRequestHandle{
	return ^(NSMutableArray *statisticsLowerOrgModelArray,NSError *err){
		dispatch_sync(dispatch_get_main_queue(), ^{
			if (err != nil && [err.domain isEqual:SOAP_SERVER_RESPONSE_ERROR]) {
				//显示对话框
				[_hud showAnimated:YES whileExecutingBlock:^{
					//对话框显示时需要执行的操作
					sleep(1);
				} completionBlock:^{
					//操作执行完后取消对话框
					
				}];
				return;
			}
			self.permissionComparisonDataSource = statisticsLowerOrgModelArray;
			
			//加载柱形图
			NSString *series = @"";
			NSString *categories = @"";
			for(StatisticsLowerOrgModel *statisticsLowerOrgModel in statisticsLowerOrgModelArray){
				series = [series stringByAppendingFormat:@"%@,",statisticsLowerOrgModel.num];
				categories = [categories stringByAppendingFormat:@"'%@',",statisticsLowerOrgModel.orgShortName];
			}
			UIWebView *webView = (UIWebView*)[self.view viewWithTag:601];
			NSString *path = [[NSBundle mainBundle] pathForResource:@"column-basic" ofType:@"html"  inDirectory:@"html"];
			NSURL *localBaseURL = [NSURL fileURLWithPath:path];
			NSString *localHtml = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
			NSString * temp = @"";
			if((self.startYear.integerValue != self.endYear.integerValue || self.startMonth.integerValue != self.endMonth.integerValue)
			   && self.endYear.integerValue != 0 && self.endMonth.integerValue != 0)
				temp = [NSString stringWithFormat:@"从%d年%d月到%d年%d月",[self.startYear intValue],[self.startMonth intValue],[self.endYear intValue],[self.endMonth intValue]];
			else{
				temp = [NSString stringWithFormat:@"%d年%d月",[self.startYear intValue],[self.startMonth intValue]];
			}
			if([self.page intValue]== 2){
				temp = [temp stringByAppendingString:@"结案数量"];
			}else if([self.page intValue] == 3){
				temp = [temp stringByAppendingString:@"当前未结案数量"];
			}else{
				temp = [temp stringByAppendingString:@"申请数量"];
			}
			localHtml = [NSString stringWithFormat:localHtml,temp,categories,series];
			
			
			
			path = [[NSBundle mainBundle] pathForResource:@"bigcolumn-basic" ofType:@"html"  inDirectory:@"html"];
			baseURL = [NSURL fileURLWithPath:path];
			html = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
			html = [NSString stringWithFormat:html,temp,categories,series];
			
			
			[self webViewADDGesture:webView];
			[webView loadHTMLString:localHtml baseURL:localBaseURL];
			
			
			[self addItemsToStatisticsLowerOrgModelArray:statisticsLowerOrgModelArray];
			[permissionComparisonTableView reloadData];
		});
		
	};
}
- (GetSupervisionRptStatisticsListHandle)patrolComparisonRequestHandle{
	return ^(NSMutableArray *statisticsLowerOrgModelArray,NSError *err){
		dispatch_sync(dispatch_get_main_queue(), ^{
			if (err != nil && [err.domain isEqual:SOAP_SERVER_RESPONSE_ERROR]) {
				//显示对话框
				[_hud showAnimated:YES whileExecutingBlock:^{
					//对话框显示时需要执行的操作
					sleep(1);
				} completionBlock:^{
					//操作执行完后取消对话框
					
				}];
				return;
			}
			self.patrolComparisonDataSource = statisticsLowerOrgModelArray;
			
			
			//加载柱形图
			NSString *series = @"";
			NSString *categories = @"";
			for(StatisticsLowerOrgModel *statisticsLowerOrgModel in statisticsLowerOrgModelArray){
				series = [series stringByAppendingFormat:@"%@,",statisticsLowerOrgModel.num];
				categories = [categories stringByAppendingFormat:@"'%@',",statisticsLowerOrgModel.orgShortName];
			}
			UIWebView *webView = (UIWebView*)[self.view viewWithTag:601];
			NSString *path = [[NSBundle mainBundle] pathForResource:@"column-basic" ofType:@"html"  inDirectory:@"html"];
			NSURL *localBaseURL = [NSURL fileURLWithPath:path];
			NSString *localHtml = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
			NSString * temp = @"";
			if((self.startYear.integerValue != self.endYear.integerValue || self.startMonth.integerValue != self.endMonth.integerValue)
			   && self.endYear.integerValue != 0 && self.endMonth.integerValue != 0)
				temp = [NSString stringWithFormat:@"从%d年%d月到%d年%d月",[self.startYear intValue],[self.startMonth intValue],[self.endYear intValue],[self.endMonth intValue]];
			else{
				temp = [NSString stringWithFormat:@"%d年%d月",[self.startYear intValue],[self.startMonth intValue]];
			}
			localHtml = [NSString stringWithFormat:localHtml,temp,categories,series];
			
			
			
			path = [[NSBundle mainBundle] pathForResource:@"bigcolumn-basic" ofType:@"html"  inDirectory:@"html"];
			baseURL = [NSURL fileURLWithPath:path];
			html = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
			html = [NSString stringWithFormat:html,temp,categories,series];
			
			
			[self webViewADDGesture:webView];
			[webView loadHTMLString:localHtml baseURL:localBaseURL];
			
			
			[self addItemsToStatisticsLowerOrgModelArray:statisticsLowerOrgModelArray];
			[patrolComparisonTableView reloadData];
		});
		
	};
}
- (GetSupervisionRptStatisticsListHandle)permitExpireRequestHandle{
	return ^(NSMutableArray *permitExpireModelArray,NSError *err){
		dispatch_sync(dispatch_get_main_queue(), ^{
			if (err != nil && [err.domain isEqual:SOAP_SERVER_RESPONSE_ERROR]) {
				//显示对话框
				[_hud showAnimated:YES whileExecutingBlock:^{
					//对话框显示时需要执行的操作
					sleep(1);
				} completionBlock:^{
					//操作执行完后取消对话框
					
				}];
				return;
			}
			self.permitExpireDataSource = permitExpireModelArray;
			int num = 1;
			for(PermitExpireModel *permit in self.permitExpireDataSource){
				permit.serialnumber = [[NSNumber alloc ]initWithInt:num++];
			}
			[permissionMaturityQueryTableView reloadData];
			((UITextField*)[self.view viewWithTag:793]).text = [NSString stringWithFormat:@"%d",self.pagenum ];
		});
	};
}
- (GetSupervisionRptStatisticsListHandle)permitWarningsRequestHandle{
	return ^(NSMutableArray *permitWarningModelArray,NSError *err){
		dispatch_sync(dispatch_get_main_queue(), ^{
			if (err != nil && [err.domain isEqual:SOAP_SERVER_RESPONSE_ERROR]) {
				//显示对话框
				[_hud showAnimated:YES whileExecutingBlock:^{
					//对话框显示时需要执行的操作
					sleep(1);
				} completionBlock:^{
					//操作执行完后取消对话框
					
				}];
				return;
			}
			self.permitWarningDataSource = permitWarningModelArray;
			int num = 1;
			for(PermitExpireModel *permit in self.permitWarningDataSource){
				permit.serialnumber = [[NSNumber alloc ]initWithInt:num++];
			}
			[permissionWarningsTableView reloadData];
			((UITextField*)[self.view viewWithTag:793]).text = [NSString stringWithFormat:@"%d",self.pagenum ];
		});
	};
}
- (GetSupervisionPermitExpireSizeHandle)permitExpireSizeRequestHandle{
	return ^(NSInteger size,NSError *err){
		dispatch_sync(dispatch_get_main_queue(), ^{
			if (err != nil && [err.domain isEqual:SOAP_SERVER_RESPONSE_ERROR]) {
				//显示对话框
				[_hud showAnimated:YES whileExecutingBlock:^{
					//对话框显示时需要执行的操作
					sleep(1);
				} completionBlock:^{
					//操作执行完后取消对话框
					
				}];
				return;
			}
			UILabel *label = (UILabel*)[self.view viewWithTag:786];
			label.text = [NSString stringWithFormat:@"%d",size ];
			_totalPageNum = size / 5;
			
			if(size % 5 > 0){
				_totalPageNum++;
			}
			UIButton *theFirstBtn = (UIButton*)[self.view viewWithTag:789];
			UIButton *beforeBtn = (UIButton*)[self.view viewWithTag:790];
			UIButton *nextBtn = (UIButton*)[self.view viewWithTag:791];
			UIButton *theLastBtn = (UIButton*)[self.view viewWithTag:792];
			
			if(self.pagenum == 1){
				[theFirstBtn setEnabled:false];
				[beforeBtn setEnabled:false];
			}else{
				[theFirstBtn setEnabled:true];
				[beforeBtn setEnabled:true];
			}
			
			if(self.pagenum == self.totalPageNum ){
				[nextBtn setEnabled:false];
				[theLastBtn setEnabled:false];
			}else{
				[nextBtn setEnabled:true];
				[theLastBtn setEnabled:true];
			}
			if(size == 0){
				[theFirstBtn setEnabled:false];
				[beforeBtn setEnabled:false];
				[nextBtn setEnabled:false];
				[theLastBtn setEnabled:false];
			}
		});
	};
}
- (GetSupervisionPermitExpireSizeHandle)permitWarningSizeRequestHandle{
	return ^(NSInteger size,NSError *err){
		dispatch_sync(dispatch_get_main_queue(), ^{
			if (err != nil && [err.domain isEqual:SOAP_SERVER_RESPONSE_ERROR]) {
				//显示对话框
				[_hud showAnimated:YES whileExecutingBlock:^{
					//对话框显示时需要执行的操作
					sleep(1);
				} completionBlock:^{
					//操作执行完后取消对话框
					
				}];
				return;
			}
			UILabel *label = (UILabel*)[self.view viewWithTag:786];
			label.text = [NSString stringWithFormat:@"%d",size ];
			_totalPageNum = size / 5;
			
			if(size % 5 > 0){
				_totalPageNum++;
			}
			UIButton *theFirstBtn = (UIButton*)[self.view viewWithTag:789];
			UIButton *beforeBtn = (UIButton*)[self.view viewWithTag:790];
			UIButton *nextBtn = (UIButton*)[self.view viewWithTag:791];
			UIButton *theLastBtn = (UIButton*)[self.view viewWithTag:792];
			
			if(self.pagenum == 1){
				[theFirstBtn setEnabled:false];
				[beforeBtn setEnabled:false];
			}else{
				[theFirstBtn setEnabled:true];
				[beforeBtn setEnabled:true];
			}
			
			if(self.pagenum == self.totalPageNum ){
				[nextBtn setEnabled:false];
				[theLastBtn setEnabled:false];
			}else{
				[nextBtn setEnabled:true];
				[theLastBtn setEnabled:true];
			}
			if(size == 0){
				[theFirstBtn setEnabled:false];
				[beforeBtn setEnabled:false];
				[nextBtn setEnabled:false];
				[theLastBtn setEnabled:false];
			}
		});
	};
}
#pragma mark - IBActions
- (void)backButton
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)changeInfoPage:(UISegmentedControl *)sender
{
	[self removeAllDataSource] ;
    UIView *view = nil;
	UISegmentedControl*  segmentedControl = nil;
	NSArray *views = self.subView.subviews;;
	for(UIView *view in views){
		[view removeFromSuperview];
	}
    switch (sender.selectedSegmentIndex) {
        case 0:{
			view = [[UIViewController alloc] initWithNibName:@"CaseStatisticsContainerViewController" bundle:nil].view;
			[self.subView addSubview:view];
			segmentedControl= (UISegmentedControl*)[self.view viewWithTag:501];
			segmentedControl.selectedSegmentIndex = caseSegmentIndex;
			[segmentedControl addTarget:self action:@selector(caseSegmentAction:) forControlEvents:UIControlEventValueChanged];
			[self caseSegmentAction:segmentedControl];
        }
            break;
        case 1:{
			view = [[UIViewController alloc] initWithNibName:@"PermissionStatisticsContainerViewController" bundle:nil].view;
			[self.subView addSubview:view];
			segmentedControl= (UISegmentedControl*)[self.view viewWithTag:501];
			segmentedControl.selectedSegmentIndex = permissionSegmentIndex;
			[segmentedControl addTarget:self action:@selector(permissionSegmentAction:) forControlEvents:UIControlEventValueChanged];
			[self permissionSegmentAction:segmentedControl];
        }
            break;
        case 2:{
			view = [[UIViewController alloc] initWithNibName:@"PatrolContainerViewController" bundle:nil].view;
			[self.subView addSubview:view];
			segmentedControl= (UISegmentedControl*)[self.view viewWithTag:501];
			segmentedControl.selectedSegmentIndex = patrolSegmentIndex;
			[segmentedControl addTarget:self action:@selector(patrolSegmentAction:) forControlEvents:UIControlEventValueChanged];
			[self patrolSegmentAction:segmentedControl];
        }
            break;
        default:
            break;
    }


}


//年和月
- (IBAction)yearMonthTime:(UITextField *)sender
{
	_currentTextField = sender;
    [sender resignFirstResponder];
    if ((self.touchTextTag == sender.tag) && ([self.popover isPopoverVisible])) {
        [self.popover dismissPopoverAnimated:YES];
    } else {
        self.touchTextTag=sender.tag;
        MonthYearSelectController *monthYearPicker=[[MonthYearSelectController alloc] init];
        monthYearPicker.delegate=self;
        [self.popover setContentViewController:monthYearPicker];
		[self.popover setPopoverContentSize:CGSizeMake(230, 260)];
        [self.popover presentPopoverFromRect:CGRectMake(sender.frame.origin.x-100, sender.frame.origin.y+120, sender.frame.size.width, sender.frame.size.height) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
        monthYearPicker.monthYearselectPopover = self.popover;
    }
}



//年和季度
- (IBAction)yearQuarterTime:(UITextField *)sender
{
	_currentTextField = sender;
    [sender resignFirstResponder];
    if ((self.touchTextTag == sender.tag) && ([self.popover isPopoverVisible])) {
        [self.popover dismissPopoverAnimated:YES];
    } else {
        self.touchTextTag=sender.tag;
        YearQuarterSelectController *yearQuarterPicker=[[YearQuarterSelectController alloc] init];
        yearQuarterPicker.delegate=self;
        [self.popover setContentViewController:yearQuarterPicker];
		[self.popover setPopoverContentSize:CGSizeMake(230, 260)];
        [self.popover presentPopoverFromRect:CGRectMake(sender.frame.origin.x-100, sender.frame.origin.y+120, sender.frame.size.width, sender.frame.size.height) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
        yearQuarterPicker.yearQuarterselectPopover = self.popover;
    }
}

//年
- (IBAction)yearTime:(UITextField *)sender
{
	_currentTextField = sender;
    [sender resignFirstResponder];
    if ((self.touchTextTag == sender.tag) && ([self.popover isPopoverVisible])) {
        [self.popover dismissPopoverAnimated:YES];
    } else {
        self.touchTextTag=sender.tag;
        YearSelectController *yearPicker=[[YearSelectController alloc] init];
        yearPicker.delegate=self;
        [self.popover setContentViewController:yearPicker];
		[self.popover setPopoverContentSize:CGSizeMake(230, 260)];
        [self.popover presentPopoverFromRect:CGRectMake(sender.frame.origin.x-100, sender.frame.origin.y+120, sender.frame.size.width, sender.frame.size.height) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
        yearPicker.yearSelectPopover = self.popover;
    }
}

- (IBAction)caseNumType:(UITextField *)sender
{
    [sender resignFirstResponder];
    if ((self.touchTextTag == sender.tag) && ([self.popover isPopoverVisible])) {
        [self.popover dismissPopoverAnimated:YES];
    } else {
        self.touchTextTag=sender.tag;
        CaseNumTypeViewController *caseNumTypePicker=[[CaseNumTypeViewController alloc] init];
        caseNumTypePicker.delegate=self;
		if(segmentIndex == 1 && permissionSegmentIndex == 1){
			[caseNumTypePicker setDataArray];
		}else{
			[caseNumTypePicker setOrgDataArray];
		}
        [self.popover setContentViewController:caseNumTypePicker];
        [self.popover setPopoverContentSize:CGSizeMake(280, 260)];
        [self.popover presentPopoverFromRect:sender.frame inView:[self.view viewWithTag:606] permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
		caseNumTypePicker.pickerPopover=self.popover;
    }
}






#pragma mark - UITableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == organizationTreeTableView){
		return self.displayArray.count;
	}else if(segmentIndex == 0 && caseSegmentIndex == 0){
		return [self.caseStatisticsDataSource count];
	}else if(segmentIndex == 0 && caseSegmentIndex == 1){
		return [self.caseComparisonDataSource count];
	}else if(segmentIndex == 1 && permissionSegmentIndex == 0){
		return [self.permissionStatisticsDataSource count];
	}else if(segmentIndex == 1 && permissionSegmentIndex == 1){
		return [self.permissionComparisonDataSource count];
	}else if(segmentIndex == 2 && patrolSegmentIndex == 0){
		return [self.patrolStatisticsDataSource count];
	}else if(segmentIndex == 2 && patrolSegmentIndex == 1){
		return [self.patrolComparisonDataSource count];
	}else if(segmentIndex == 1 && permissionSegmentIndex == 2){
		return [self.permitExpireDataSource count];
	}else if(segmentIndex == 1 && permissionSegmentIndex == 3){
		return [self.permitWarningDataSource count];
	}
    return [self.dataSource count];
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(tableView == organizationTreeTableView){
		CollapseCell *collapseCell = (CollapseCell*)cell;
		if([((OrgInfoSimpleModel*)(collapseCell.treeNode.nodeObject)).identifier isEqualToString:self.orgID]){
			collapseCell.backgroundColor = UIColorFromRGB(0xE0F8D8);
		}else if (collapseCell.treeNode.nodeLevel == 0) {
			collapseCell.backgroundColor = UIColorFromRGB(0xF7F7F7);
		} else if (collapseCell.treeNode.nodeLevel == 1) {
			collapseCell.backgroundColor = UIColorFromRGB(0xD1EEFC);
		} else if (collapseCell.treeNode.nodeLevel == 3) {
			collapseCell.backgroundColor = UIColorFromRGB(0xFFEC8B);
		}else if (collapseCell.treeNode.nodeLevel == 2) {
			collapseCell.backgroundColor = UIColorFromRGB(0x97FFFF);
		}else if (collapseCell.treeNode.nodeLevel == 4) {
			collapseCell.backgroundColor = UIColorFromRGB(0xFFE1FF);
		}else if (collapseCell.treeNode.nodeLevel == 5) {
			collapseCell.backgroundColor = UIColorFromRGB(0xFFF5EE);
		}
	}
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	if(tableView == organizationTreeTableView){
		CollapseCell *collapseCell = (CollapseCell*)cell;
		if([((OrgInfoSimpleModel*)(collapseCell.treeNode.nodeObject)).identifier isEqualToString:self.orgID]){
			collapseCell.backgroundColor = UIColorFromRGB(0xE0F8D8);
		}else if (collapseCell.treeNode.nodeLevel == 0) {
			collapseCell.backgroundColor = UIColorFromRGB(0xF7F7F7);
		} else if (collapseCell.treeNode.nodeLevel == 1) {
			collapseCell.backgroundColor = UIColorFromRGB(0xD1EEFC);
		} else if (collapseCell.treeNode.nodeLevel == 3) {
			collapseCell.backgroundColor = UIColorFromRGB(0xFFEC8B);
		}else if (collapseCell.treeNode.nodeLevel == 2) {
			collapseCell.backgroundColor = UIColorFromRGB(0x97FFFF);
		}else if (collapseCell.treeNode.nodeLevel == 4) {
			collapseCell.backgroundColor = UIColorFromRGB(0xFFE1FF);
		}else if (collapseCell.treeNode.nodeLevel == 5) {
			collapseCell.backgroundColor = UIColorFromRGB(0xFFF5EE);
		}
	}
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
    if(tableView == organizationTreeTableView){
		static NSString *CellIdentifier = @"treeNodeCell";
		UINib *nib = [UINib nibWithNibName:@"CollapseCell" bundle:nil];
		[tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
		
		CollapseCell *cell = (CollapseCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		
		TreeViewNode *node = [self.displayArray objectAtIndex:indexPath.row];
		cell.treeNode = node;
		cell.delegate = self;
		OrgInfoSimpleModel *org = (OrgInfoSimpleModel*)(node.nodeObject);
		cell.cellLabel.text = org.orgShortName;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		

		
		if ([node.nodeChildren count] > 0 && node.isExpanded == YES) {
			[cell setTheButtonBackgroundImage:[UIImage imageNamed:@"open.png"]];
			
		}
		else {
			[cell setTheButtonBackgroundImage:[UIImage imageNamed:@"close.png"]];
		}

		
		[cell setNeedsDisplay];
		
		if([self.orgID isEqual:org.identifier]){
			orgCell = cell;
		}
		// Configure the cell...

		return cell;
	}
	
    static NSString * CellString = @"CellString";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellString];
    cell.userInteractionEnabled = NO; //不用被点击
	cell.contentView.backgroundColor = [UIColor clearColor];
	if(segmentIndex == 0 && caseSegmentIndex == 0){
		if (!cell) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellString];
			UILabel * lable1 =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 130, cell.bounds.size.height)];
			lable1.tag = 505;
			UILabel * lable2 =[[UILabel alloc]initWithFrame:CGRectMake(130, 0, 35, cell.bounds.size.height)];
			lable2.tag = 506;
			UILabel * lable3 =[[UILabel alloc]initWithFrame:CGRectMake(165, 0, 40, cell.bounds.size.height)];
			lable3.tag = 507;
			UILabel * lable4 =[[UILabel alloc]initWithFrame:CGRectMake(205, 0, 45, cell.bounds.size.height)];
			lable4.tag = 508;
			UILabel * lable5 =[[UILabel alloc]initWithFrame:CGRectMake(250, 0, 40, cell.bounds.size.height)];
			lable5.tag = 509;
			UILabel * lable6 =[[UILabel alloc]initWithFrame:CGRectMake(290, 0, 60, cell.bounds.size.height)];
			lable6.tag = 510;
			[cell addSubview:lable1];
			[cell addSubview:lable2];
			[cell addSubview:lable3];
			[cell addSubview:lable4];
			[cell addSubview:lable5];
			[cell addSubview:lable6];
		}
		
		
		UILabel *lable1= (UILabel *)[cell viewWithTag:505];
		UILabel *lable2 = (UILabel *)[cell viewWithTag:506];
		UILabel *lable3 = (UILabel *)[cell viewWithTag:507];
		UILabel *lable4 = (UILabel *)[cell viewWithTag:508];
		UILabel *lable5 = (UILabel *)[cell viewWithTag:509];
		UILabel *lable6 = (UILabel *)[cell viewWithTag:510];
		NSString *names = [[self.caseStatisticsDataSource objectAtIndex:indexPath.row] names];

		NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
		lable2.text =  [numberFormatter stringFromNumber:[[self.caseStatisticsDataSource objectAtIndex:indexPath.row] num_begin]];
		lable3.text = [numberFormatter stringFromNumber:[[self.caseStatisticsDataSource objectAtIndex:indexPath.row] num_end]];
		lable4.text = [numberFormatter stringFromNumber:[[self.caseStatisticsDataSource objectAtIndex:indexPath.row] num_notend]];
		lable5.text = [numberFormatter stringFromNumber:[[self.caseStatisticsDataSource objectAtIndex:indexPath.row] money_count]];
		lable6.text = [numberFormatter stringFromNumber:[[self.caseStatisticsDataSource objectAtIndex:indexPath.row] money_fact]];
		if([names isEqual:@"合计："]){
			lable1.text= names;
			lable1.textAlignment = NSTextAlignmentCenter;
			cell.contentView.backgroundColor = [UIColor colorWithRed:1.00f green:0.91f blue:0.82f alpha:1.00f];
			lable1.backgroundColor = [UIColor clearColor];
			lable2.backgroundColor = [UIColor clearColor];
			lable3.backgroundColor = [UIColor clearColor];
			lable4.backgroundColor = [UIColor clearColor];
			lable5.backgroundColor = [UIColor clearColor];
			lable6.backgroundColor = [UIColor clearColor];

		}else{
			lable1.text= names;
		}
    }else if(segmentIndex == 0 && caseSegmentIndex == 1){
		
		if (!cell) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellString];
			
			UILabel * lable1 =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, cell.bounds.size.width/5, cell.bounds.size.height)];
			lable1.tag = 505;
			UILabel * lable2 =[[UILabel alloc]initWithFrame:CGRectMake(cell.bounds.size.width/4+10, 0, cell.bounds.size.width/2-50, cell.bounds.size.height)];
			lable2.tag = 506;
			UILabel * lable3 =[[UILabel alloc]initWithFrame:CGRectMake(cell.bounds.size.width/2+70, 0, cell.bounds.size.width/2-50, cell.bounds.size.height)];
			lable3.tag = 507;
			[cell addSubview:lable1];
			[cell addSubview:lable2];
			[cell addSubview:lable3];
		}
		
		
		UILabel *lable1= (UILabel *)[cell viewWithTag:505];
		UILabel *lable2 = (UILabel *)[cell viewWithTag:506];
		UILabel *lable3 = (UILabel *)[cell viewWithTag:507];
		NSString *orgShortName = [[self.caseComparisonDataSource objectAtIndex:indexPath.row] orgShortName];
		lable1.textAlignment = NSTextAlignmentCenter;
		lable2.textAlignment = NSTextAlignmentCenter;
		lable3.textAlignment = NSTextAlignmentCenter;
		NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
		lable3.text = [numberFormatter stringFromNumber:[[self.caseComparisonDataSource objectAtIndex:indexPath.row] num]];
		if([orgShortName isEqual:@"合计："]){
			lable2.text= orgShortName;
			lable2.textAlignment = NSTextAlignmentCenter;
			cell.contentView.backgroundColor = [UIColor colorWithRed:1.00f green:0.91f blue:0.82f alpha:1.00f];
			lable1.backgroundColor = [UIColor clearColor];
			lable2.backgroundColor = [UIColor clearColor];
			lable3.backgroundColor = [UIColor clearColor];
		}else{
			lable2.text= orgShortName;
			lable1.text =  [[[NSNumberFormatter alloc] init] stringFromNumber:[[self.caseComparisonDataSource objectAtIndex:indexPath.row] serialnumber]];
			
		}

	}else if(segmentIndex == 1 && permissionSegmentIndex == 0){
		if (!cell) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellString];
			
			UILabel * lable1 =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 220, cell.bounds.size.height)];
			lable1.tag = 505;
			UILabel * lable2 =[[UILabel alloc]initWithFrame:CGRectMake(220, 0, 30, cell.bounds.size.height)];
			lable2.tag = 506;
			UILabel * lable3 =[[UILabel alloc]initWithFrame:CGRectMake(250, 0, 35, cell.bounds.size.height)];
			lable3.tag = 507;
			UILabel * lable4 =[[UILabel alloc]initWithFrame:CGRectMake(285, 0, 35, cell.bounds.size.height)];
			lable4.tag = 508;
			UILabel * lable5 =[[UILabel alloc]initWithFrame:CGRectMake(320, 0, 50, cell.bounds.size.height)];
			lable5.tag = 509;
			[cell addSubview:lable1];
			[cell addSubview:lable2];
			[cell addSubview:lable3];
			[cell addSubview:lable4];
			[cell addSubview:lable5];
		}
		
		
		UILabel *lable1= (UILabel *)[cell viewWithTag:505];
		UILabel *lable2 = (UILabel *)[cell viewWithTag:506];
		UILabel *lable3 = (UILabel *)[cell viewWithTag:507];
		UILabel *lable4 = (UILabel *)[cell viewWithTag:508];
		UILabel *lable5 = (UILabel *)[cell viewWithTag:509];
		NSString *names = [[self.permissionStatisticsDataSource objectAtIndex:indexPath.row] names];
		
		NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
		lable2.text =  [numberFormatter stringFromNumber:[[self.permissionStatisticsDataSource objectAtIndex:indexPath.row] num_begin]];
		lable3.text = [numberFormatter stringFromNumber:[[self.permissionStatisticsDataSource objectAtIndex:indexPath.row] num_end]];
		lable4.text = [numberFormatter stringFromNumber:[[self.permissionStatisticsDataSource objectAtIndex:indexPath.row] num_notend]];
		lable5.text = [numberFormatter stringFromNumber:[[self.permissionStatisticsDataSource objectAtIndex:indexPath.row] money_count]];
		if([names isEqual:@"合计："]){
			lable1.text= names;
			lable1.textAlignment = NSTextAlignmentCenter;
			cell.contentView.backgroundColor = [UIColor colorWithRed:1.00f green:0.91f blue:0.82f alpha:1.00f];
			lable1.backgroundColor = [UIColor clearColor];
			lable2.backgroundColor = [UIColor clearColor];
			lable3.backgroundColor = [UIColor clearColor];
			lable4.backgroundColor = [UIColor clearColor];
			lable5.backgroundColor = [UIColor clearColor];
		}else{
			lable1.text= names;
		}
		
	}else if(segmentIndex == 1 && permissionSegmentIndex == 1){
		if (!cell) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellString];
			
			UILabel * lable1 =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, cell.bounds.size.width/5, cell.bounds.size.height)];
			lable1.tag = 505;
			UILabel * lable2 =[[UILabel alloc]initWithFrame:CGRectMake(cell.bounds.size.width/4+10, 0, cell.bounds.size.width/2-50, cell.bounds.size.height)];
			lable2.tag = 506;
			UILabel * lable3 =[[UILabel alloc]initWithFrame:CGRectMake(cell.bounds.size.width/2+70, 0, cell.bounds.size.width/2-50, cell.bounds.size.height)];
			lable3.tag = 507;
			[cell addSubview:lable1];
			[cell addSubview:lable2];
			[cell addSubview:lable3];
		}
		
		
		UILabel *lable1= (UILabel *)[cell viewWithTag:505];
		UILabel *lable2 = (UILabel *)[cell viewWithTag:506];
		UILabel *lable3 = (UILabel *)[cell viewWithTag:507];
		NSString *orgShortName = [[self.permissionComparisonDataSource objectAtIndex:indexPath.row] orgShortName];
		lable1.textAlignment = NSTextAlignmentCenter;
		lable2.textAlignment = NSTextAlignmentCenter;
		lable3.textAlignment = NSTextAlignmentCenter;
		NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
		lable3.text = [numberFormatter stringFromNumber:[[self.permissionComparisonDataSource objectAtIndex:indexPath.row] num]];
		if([orgShortName isEqual:@"合计："]){
			lable2.text= orgShortName;
			lable2.textAlignment = NSTextAlignmentCenter;
			cell.contentView.backgroundColor = [UIColor colorWithRed:1.00f green:0.91f blue:0.82f alpha:1.00f];
			lable1.backgroundColor = [UIColor clearColor];
			lable2.backgroundColor = [UIColor clearColor];
			lable3.backgroundColor = [UIColor clearColor];
		}else{
			lable2.text= orgShortName;
			lable1.text =  [[[NSNumberFormatter alloc] init] stringFromNumber:[[self.permissionComparisonDataSource objectAtIndex:indexPath.row] serialnumber]];
			
		}
		
	}else if(segmentIndex == 1 && permissionSegmentIndex == 2){
		if (!cell) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellString];
			
			UILabel * lable1 =[[UILabel alloc]initWithFrame:CGRectMake(5, 0, cell.bounds.size.width/6, cell.bounds.size.height)];
			lable1.tag = 505;
			UILabel * lable2 =[[UILabel alloc]initWithFrame:CGRectMake(cell.bounds.size.width/6, 0, cell.bounds.size.width/2+50, cell.bounds.size.height)];
			lable2.tag = 506;
			UILabel * lable3 =[[UILabel alloc]initWithFrame:CGRectMake(cell.bounds.size.width/2+100, 0, cell.bounds.size.width/2+50, cell.bounds.size.height)];
			lable3.tag = 507;
			UILabel * lable4 =[[UILabel alloc]initWithFrame:CGRectMake(cell.bounds.size.width/2+300, 0, cell.bounds.size.width/5+50, cell.bounds.size.height)];
			lable4.tag = 508;
			UILabel * lable5 =[[UILabel alloc]initWithFrame:CGRectMake(cell.bounds.size.width/2+400, 0, cell.bounds.size.width/5+150, cell.bounds.size.height)];
			lable5.tag = 509;
			UILabel * lable6 =[[UILabel alloc]initWithFrame:CGRectMake(cell.bounds.size.width/2+610, 0, cell.bounds.size.width/3+10, cell.bounds.size.height)];
			lable6.tag = 510;
			UILabel * lable7 =[[UILabel alloc]initWithFrame:CGRectMake(cell.bounds.size.width/2+720, 0, cell.bounds.size.width/4, cell.bounds.size.height)];
			lable7.tag = 511;
			[cell addSubview:lable1];
			[cell addSubview:lable2];
			[cell addSubview:lable3];
			[cell addSubview:lable4];
			[cell addSubview:lable5];
			[cell addSubview:lable6];
			[cell addSubview:lable7];
		}
		
		
		UILabel *lable1= (UILabel *)[cell viewWithTag:505];
		UILabel *lable2 = (UILabel *)[cell viewWithTag:506];
		UILabel *lable3 = (UILabel *)[cell viewWithTag:507];
		UILabel *lable4 = (UILabel *)[cell viewWithTag:508];
		UILabel *lable5 = (UILabel *)[cell viewWithTag:509];
		UILabel *lable6 = (UILabel *)[cell viewWithTag:510];
		UILabel *lable7 = (UILabel *)[cell viewWithTag:511];


		lable1.textAlignment = NSTextAlignmentCenter;
		lable2.textAlignment = NSTextAlignmentCenter;
		lable3.textAlignment = NSTextAlignmentCenter;
		lable4.textAlignment = NSTextAlignmentCenter;
		lable5.textAlignment = NSTextAlignmentCenter;
		lable6.textAlignment = NSTextAlignmentCenter;
		lable7.textAlignment = NSTextAlignmentCenter;
		lable1.text = [NSString stringWithFormat:@"%d",[[[self.permitExpireDataSource objectAtIndex:indexPath.row] serialnumber]intValue]];
		lable2.text = [[self.permitExpireDataSource objectAtIndex:indexPath.row] case_no];
		lable3.text = [[self.permitExpireDataSource objectAtIndex:indexPath.row] process_name];
		NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
		[dateFormat setDateFormat:@"yyyy.MM.dd"];//设定时间格式,这里可以设置成自己需要的格式
		lable4.text = [dateFormat stringFromDate:[[self.permitExpireDataSource objectAtIndex:indexPath.row] app_date]];
		lable5.text = [[self.permitExpireDataSource objectAtIndex:indexPath.row] permission_address];
		lable6.text = [[self.permitExpireDataSource objectAtIndex:indexPath.row] applicant_name];
		lable7.text =  [NSString stringWithFormat: @"%@",[[self.permitExpireDataSource objectAtIndex:indexPath.row] date_diff]];

		
	}else if(segmentIndex == 1 && permissionSegmentIndex == 3){
		if (!cell) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellString];
	
			UILabel * lable1 =[[UILabel alloc]initWithFrame:CGRectMake(5, 0, cell.bounds.size.width/6, cell.bounds.size.height)];
			lable1.tag = 505;
			UILabel * lable2 =[[UILabel alloc]initWithFrame:CGRectMake(cell.bounds.size.width/6, 0, cell.bounds.size.width/2+50, cell.bounds.size.height)];
			lable2.tag = 506;
			UILabel * lable3 =[[UILabel alloc]initWithFrame:CGRectMake(cell.bounds.size.width/2+100, 0, cell.bounds.size.width/2+50, cell.bounds.size.height)];
			lable3.tag = 507;
			UILabel * lable4 =[[UILabel alloc]initWithFrame:CGRectMake(cell.bounds.size.width/2+300, 0, cell.bounds.size.width/5+50, cell.bounds.size.height)];
			lable4.tag = 508;
			UILabel * lable5 =[[UILabel alloc]initWithFrame:CGRectMake(cell.bounds.size.width/2+400, 0, cell.bounds.size.width/5+150, cell.bounds.size.height)];
			lable5.tag = 509;
			UILabel * lable6 =[[UILabel alloc]initWithFrame:CGRectMake(cell.bounds.size.width/2+610, 0, cell.bounds.size.width/3+10, cell.bounds.size.height)];
			lable6.tag = 510;
			UILabel * lable7 =[[UILabel alloc]initWithFrame:CGRectMake(cell.bounds.size.width/2+720, 0, cell.bounds.size.width/4, cell.bounds.size.height)];
			lable7.tag = 511;
			
			[cell addSubview:lable1];
			[cell addSubview:lable2];
			[cell addSubview:lable3];
			[cell addSubview:lable4];
			[cell addSubview:lable5];
			[cell addSubview:lable6];
			[cell addSubview:lable7];
		}
		
		UIImageView *imageView = (UIImageView *)[cell viewWithTag:841];
		if(imageView != nil){
			[imageView removeFromSuperview];
		}
		UILabel *lable1= (UILabel *)[cell viewWithTag:505];
		UILabel *lable2 = (UILabel *)[cell viewWithTag:506];
		UILabel *lable3 = (UILabel *)[cell viewWithTag:507];
		UILabel *lable4 = (UILabel *)[cell viewWithTag:508];
		UILabel *lable5 = (UILabel *)[cell viewWithTag:509];
		UILabel *lable6 = (UILabel *)[cell viewWithTag:510];
		UILabel *lable7 = (UILabel *)[cell viewWithTag:511];
		
		
		lable1.textAlignment = NSTextAlignmentCenter;
		lable2.textAlignment = NSTextAlignmentCenter;
		lable3.textAlignment = NSTextAlignmentCenter;
		lable4.textAlignment = NSTextAlignmentCenter;
		lable5.textAlignment = NSTextAlignmentCenter;
		lable6.textAlignment = NSTextAlignmentCenter;
		lable7.textAlignment = NSTextAlignmentCenter;
		lable1.text = [NSString stringWithFormat:@"%d",[[[self.permitWarningDataSource objectAtIndex:indexPath.row] serialnumber]intValue]];
		lable2.text = [[self.permitWarningDataSource objectAtIndex:indexPath.row] case_no];
		lable3.text = [[self.permitWarningDataSource objectAtIndex:indexPath.row] process_name];
		NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
		[dateFormat setDateFormat:@"yyyy.MM.dd"];//设定时间格式,这里可以设置成自己需要的格式
		lable4.text = [dateFormat stringFromDate:[[self.permitWarningDataSource objectAtIndex:indexPath.row] app_date]];
		lable5.text = [[self.permitWarningDataSource objectAtIndex:indexPath.row] permission_address];
		lable6.text = [[self.permitWarningDataSource objectAtIndex:indexPath.row] applicant_name];
		NSNumber *date_diff = [[self.permitWarningDataSource objectAtIndex:indexPath.row] date_diff];
		if(date_diff.integerValue == -1){
			lable7.text = @"一年以上";
		}else{
			lable7.text =  [NSString stringWithFormat: @"%@",[[self.permitWarningDataSource objectAtIndex:indexPath.row] date_diff]];
		}
		
		if(permitExpireType == 2){
			UIImageView  *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(3,13, 20, 20)];
			[imageView setImage:[UIImage imageNamed:@"flag_red.png"]];
			[cell addSubview:imageView];
			imageView.tag = 841;
		}else if(date_diff.integerValue <= 20 && date_diff.integerValue >= 17){
			UIImageView  *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(3,13, 20, 20)];
			[imageView setImage:[UIImage imageNamed:@"flag_yellow.png"]];
			[cell addSubview:imageView];
			imageView.tag = 841;
		}
	}else if(segmentIndex == 2 && patrolSegmentIndex == 0){
		if (!cell) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellString];
			
			UILabel * lable1 =[[UILabel alloc]initWithFrame:CGRectMake(10, 0, cell.bounds.size.width/2+110, cell.bounds.size.height)];
			lable1.tag = 505;
			UILabel * lable2 =[[UILabel alloc]initWithFrame:CGRectMake(cell.bounds.size.width/2+110, 0, cell.bounds.size.width/2-50, cell.bounds.size.height)];
			lable2.tag = 506;
			[cell addSubview:lable1];
			[cell addSubview:lable2];
		}
		
		
		UILabel *lable1= (UILabel *)[cell viewWithTag:505];
		UILabel *lable2 = (UILabel *)[cell viewWithTag:506];
		NSString *names = [[self.patrolStatisticsDataSource objectAtIndex:indexPath.row] names];
		
		NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
		lable2.text =  [numberFormatter stringFromNumber:[[self.patrolStatisticsDataSource objectAtIndex:indexPath.row] num_begin]];
		if([names isEqual:@"合计："]){
			lable1.text= names;
			lable1.textAlignment = NSTextAlignmentCenter;
			cell.contentView.backgroundColor = [UIColor colorWithRed:1.00f green:0.91f blue:0.82f alpha:1.00f];
			lable1.backgroundColor = [UIColor clearColor];
			lable2.backgroundColor = [UIColor clearColor];
		}else{
			lable1.text= names;
			lable1.textAlignment = NSTextAlignmentLeft;
			cell.contentView.backgroundColor = [UIColor clearColor];
		}

	}else if(segmentIndex == 2 && patrolSegmentIndex == 1){
		if (!cell) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellString];
			
			UILabel * lable1 =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, cell.bounds.size.width/5, cell.bounds.size.height)];
			lable1.tag = 505;
			UILabel * lable2 =[[UILabel alloc]initWithFrame:CGRectMake(cell.bounds.size.width/4+10, 0, cell.bounds.size.width/2-50, cell.bounds.size.height)];
			lable2.tag = 506;
			UILabel * lable3 =[[UILabel alloc]initWithFrame:CGRectMake(cell.bounds.size.width/2+70, 0, cell.bounds.size.width/2-50, cell.bounds.size.height)];
			lable3.tag = 507;
			[cell addSubview:lable1];
			[cell addSubview:lable2];
			[cell addSubview:lable3];
		}
		
		
		UILabel *lable1= (UILabel *)[cell viewWithTag:505];
		UILabel *lable2 = (UILabel *)[cell viewWithTag:506];
		UILabel *lable3 = (UILabel *)[cell viewWithTag:507];
		NSString *orgShortName = [[self.patrolComparisonDataSource objectAtIndex:indexPath.row] orgShortName];
		lable1.textAlignment = NSTextAlignmentCenter;
		lable2.textAlignment = NSTextAlignmentCenter;
		lable3.textAlignment = NSTextAlignmentCenter;
		NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
		lable3.text = [numberFormatter stringFromNumber:[[self.patrolComparisonDataSource objectAtIndex:indexPath.row] num]];
		if([orgShortName isEqual:@"合计："]){
			lable2.text= orgShortName;
			lable2.textAlignment = NSTextAlignmentCenter;
			cell.contentView.backgroundColor = [UIColor colorWithRed:1.00f green:0.91f blue:0.82f alpha:1.00f];
			lable1.backgroundColor = [UIColor clearColor];
			lable2.backgroundColor = [UIColor clearColor];
			lable3.backgroundColor = [UIColor clearColor];
		}else{
			lable2.text= orgShortName;
			lable1.text =  [[[NSNumberFormatter alloc] init] stringFromNumber:[[self.patrolComparisonDataSource objectAtIndex:indexPath.row] serialnumber]];
		}
		
	}
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;

}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

-(void)caseSegmentAction:(id)sender{
	[[[DataModelCenter defaultCenter] webService].queue cancelAllOperations];
	self.page = [[NSNumber alloc]initWithInt:1];
	[self removeAllDataSource];
	NSArray *views = [self.view viewWithTag:500].subviews;;
	for(UIView *view in views){
		[view removeFromSuperview];
	}
	UIView *caseView = nil;
	switch ([sender selectedSegmentIndex]) {
		case 0:{
			caseView = [[UIViewController alloc] initWithNibName:@"CaseStatisticsViewController" bundle:nil].view;
			caseSegmentIndex = 0;
			segmentIndex = 0;
			localTableView = (UITableView*)[caseView viewWithTag:502];
			localTableView.delegate = self;
			localTableView.dataSource = self;
			[self caseStatisticsQuery];
		}
			break;
		case 1:{
			caseView = [[UIViewController alloc] initWithNibName:@"CaseComparisonViewController" bundle:nil].view;
			caseSegmentIndex = 1;
			segmentIndex = 0;
			caseComparisonTableView = (UITableView*)[caseView viewWithTag:502];
			caseComparisonTableView.delegate = self;
			caseComparisonTableView.dataSource = self;
			UITextField *field = (UITextField *)[caseView viewWithTag:607];
			[field setDelegate:self];
			[field addTarget:self action:@selector(caseNumType:) forControlEvents:UIControlEventTouchDown];
			
			[self caseComparisonStatisticsQuery];
		}
			break;
		default:
			break;
	}
	[self fillDisplayArray];
	[self addOrgAndRadioButtons:caseView];
	[[self.view viewWithTag:500] addSubview:caseView];
}

-(void)permissionSegmentAction:(id)sender  {
	[[[DataModelCenter defaultCenter] webService].queue cancelAllOperations];
	self.page = [[NSNumber alloc]initWithInt:1];
	[self removeAllDataSource];
	NSArray *views = [self.view viewWithTag:500].subviews;;
	for(UIView *view in views){
		[view removeFromSuperview];
	}
	UIView *permissionView = nil;
	switch ([sender selectedSegmentIndex]) {
		case 0:{
			permissionView = [[UIViewController alloc] initWithNibName:@"PermissionStatisticsViewController" bundle:nil].view;
			segmentIndex = 1;
			permissionSegmentIndex = 0;
			permissionStatisticsTableView = (UITableView*)[permissionView viewWithTag:502];
			permissionStatisticsTableView.delegate = self;
			permissionStatisticsTableView.dataSource = self;

			[self permissionStatisticsQuery];
		}
			break;
		case 1:{
			permissionView = [[UIViewController alloc] initWithNibName:@"PermissionComparisonViewController" bundle:nil].view;
			segmentIndex = 1;
			permissionSegmentIndex = 1;
	
			
			
			permissionComparisonTableView = (UITableView*)[permissionView viewWithTag:502];
			permissionComparisonTableView.delegate = self;
			permissionComparisonTableView.dataSource = self;
			[self permissionComparisonStatisticsQuery];
			
			UITextField *field = (UITextField *)[permissionView viewWithTag:607];
			[field setDelegate:self];
			[field addTarget:self action:@selector(caseNumType:) forControlEvents:UIControlEventTouchDown];
		}
			break;
		case 2:{
			self.pagenum = 1;
			permissionView = [[UIViewController alloc] initWithNibName:@"PermissionMaturityQueryViewController" bundle:nil].view;
			segmentIndex = 1;
			permissionSegmentIndex = 2;
			

			
			
			
			UIButton *theFirstBtn = (UIButton*)[permissionView viewWithTag:789];
			UIButton *beforeBtn = (UIButton*)[permissionView viewWithTag:790];
			UIButton *nextBtn = (UIButton*)[permissionView viewWithTag:791];
			UIButton *theLastBtn = (UIButton*)[permissionView viewWithTag:792];
			UIScrollView *scrollView = (UIScrollView*)[permissionView viewWithTag:963];
			
			permissionMaturityQueryTableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCROLLVIEW_WIDTH, 633) style:UITableViewStylePlain];
			[permissionMaturityQueryTableView setDataSource:self];
			[permissionMaturityQueryTableView setDelegate:self];
			[scrollView addSubview:permissionMaturityQueryTableView];
			[scrollView setFrame:CGRectMake(12, 350, 1000, 335)];
			scrollView.contentMode=UIViewContentModeLeft;
			scrollView.bounces=NO;
			scrollView.contentSize=CGSizeMake(SCROLLVIEW_WIDTH, 335);
			scrollView.contentInset=UIEdgeInsetsZero;
			
			[theFirstBtn setEnabled:false];
			[beforeBtn setEnabled:false];
			[nextBtn setEnabled:false];
			[theLastBtn setEnabled:false];
			
			
			[theFirstBtn addTarget:self action:@selector(permissionQueryFrist) forControlEvents:UIControlEventTouchDown];
			[beforeBtn addTarget:self action:@selector(permissionQuerybefore) forControlEvents:UIControlEventTouchDown];
			[nextBtn addTarget:self action:@selector(permissionQuerynext) forControlEvents:UIControlEventTouchDown];
			[theLastBtn addTarget:self action:@selector(permissionQueryLast) forControlEvents:UIControlEventTouchDown];
			
			UIButton *button = (UIButton*)[permissionView viewWithTag:157];
			[button addTarget:self action:@selector(permissionQuery) forControlEvents:UIControlEventTouchDown];
			[self permissionMaturityQuery];
			break;
		}
		case 3:{
			self.pagenum = 1;
			permissionView = [[UIViewController alloc] initWithNibName:@"PermissionWarningsViewController" bundle:nil].view;
			segmentIndex = 1;
			permissionSegmentIndex = 3;
			
			
			
			
			
			UIButton *theFirstBtn = (UIButton*)[permissionView viewWithTag:789];
			UIButton *beforeBtn = (UIButton*)[permissionView viewWithTag:790];
			UIButton *nextBtn = (UIButton*)[permissionView viewWithTag:791];
			UIButton *theLastBtn = (UIButton*)[permissionView viewWithTag:792];
			UIScrollView *scrollView = (UIScrollView*)[permissionView viewWithTag:963];
			
			permissionWarningsTableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCROLLVIEW_WIDTH, 633) style:UITableViewStylePlain];
			[permissionWarningsTableView setDataSource:self];
			[permissionWarningsTableView setDelegate:self];
			[scrollView addSubview:permissionWarningsTableView];
			[scrollView setFrame:CGRectMake(12, 350, 1000, 335)];
			scrollView.contentMode=UIViewContentModeLeft;
			scrollView.bounces=NO;
			scrollView.contentSize=CGSizeMake(SCROLLVIEW_WIDTH, 335);
			scrollView.contentInset=UIEdgeInsetsZero;
			
			[theFirstBtn setEnabled:false];
			[beforeBtn setEnabled:false];
			[nextBtn setEnabled:false];
			[theLastBtn setEnabled:false];
			
			
			[theFirstBtn addTarget:self action:@selector(permissionWarningQueryFrist) forControlEvents:UIControlEventTouchDown];
			[beforeBtn addTarget:self action:@selector(permissionWarningQuerybefore) forControlEvents:UIControlEventTouchDown];
			[nextBtn addTarget:self action:@selector(permissionWarningQuerynext) forControlEvents:UIControlEventTouchDown];
			[theLastBtn addTarget:self action:@selector(permissionWarningQueryLast) forControlEvents:UIControlEventTouchDown];
			
			UIButton *button = (UIButton*)[permissionView viewWithTag:157];
			[button addTarget:self action:@selector(btnPermissionWarningQuery) forControlEvents:UIControlEventTouchDown];
			[self permissionWarningAllQuery];
		}
			break;
		default:
			break;
	}
	

	[self addOrgAndRadioButtons:permissionView];

	[[self.view viewWithTag:500] addSubview:permissionView];
}

-(void)patrolSegmentAction:(id)sender  {
	[[[DataModelCenter defaultCenter] webService].queue cancelAllOperations];
	self.page = [[NSNumber alloc]initWithInt:1];
	[self removeAllDataSource];
	NSArray *views = [self.view viewWithTag:500].subviews;;
	for(UIView *view in views){
		[view removeFromSuperview];
	}
	UIView *patrolView = nil;
	switch ([sender selectedSegmentIndex]) {
		case 0:{
			patrolView = [[UIViewController alloc] initWithNibName:@"PatrolViewController" bundle:nil].view;
			segmentIndex = 2;
			patrolSegmentIndex = 0;
			patrolStatisticsTableView = (UITableView*)[patrolView viewWithTag:502];
			patrolStatisticsTableView.delegate = self;
			patrolStatisticsTableView.dataSource = self;
			organizationTreeTableView = (UITableView*)[patrolView viewWithTag:417];
			organizationTreeTableView.delegate = self;
			organizationTreeTableView.dataSource = self;
			[organizationTreeTableView reloadData];
			[self patrolStatisticsQuery];
		}
			break;
		case 1:{
			patrolView = [[UIViewController alloc] initWithNibName:@"PatrolComparisonViewController" bundle:nil].view;
			segmentIndex = 2;
			patrolSegmentIndex = 1;
			
			patrolComparisonTableView = (UITableView*)[patrolView viewWithTag:502];
			patrolComparisonTableView.delegate = self;
			patrolComparisonTableView.dataSource = self;
			organizationTreeTableView = (UITableView*)[patrolView viewWithTag:417];
			organizationTreeTableView.delegate = self;
			organizationTreeTableView.dataSource = self;
			[organizationTreeTableView reloadData];
			[self patrolComparisonStatisticsQuery];

		}
			break;
		default:
			break;
	}
	[self addOrgAndRadioButtons:patrolView];
	[[self.view viewWithTag:500] addSubview:patrolView];
}
- (void)addOrgAndRadioButtons:(UIView*)view{
	organizationTreeTableView = (UITableView*)[view viewWithTag:417];
	organizationTreeTableView.delegate = self;
	organizationTreeTableView.dataSource = self;
	[organizationTreeTableView reloadData];
	
	
	
	yearRadioButton = (RadioButton*)[view viewWithTag:850];
	[yearRadioButton addTarget:self action:@selector(queryByYear:) forControlEvents:UIControlEventTouchDown];
	monthRadioButton = (RadioButton*)[view viewWithTag:851];
	[monthRadioButton addTarget:self action:@selector(queryByMonth:) forControlEvents:UIControlEventTouchDown];
	quarterRadioButton = (RadioButton*)[view viewWithTag:852];
	[quarterRadioButton addTarget:self action:@selector(queryByQuarter:) forControlEvents:UIControlEventTouchDown];
	sectionRadioButton = (RadioButton*)[view viewWithTag:853];
	[sectionRadioButton addTarget:self action:@selector(queryBySection:) forControlEvents:UIControlEventTouchDown];
	[monthRadioButton setSelected:YES];
	
	
	quarterSectionBeginLabel = (UILabel*)[view viewWithTag:854];
	quarterSectionEndLabel = (UILabel*)[view viewWithTag:856];
	yearMonthLabel = (UILabel*)[view viewWithTag:858];
	
	quarterSectionBeginTextField = (UITextField*)[view viewWithTag:855];
	quarterSectionBeginTextField.delegate = self;
	quarterSectionEndTextField = (UITextField*)[view viewWithTag:857];
	quarterSectionEndTextField.delegate = self;
	yearMonthTextField = (UITextField*)[view viewWithTag:859];
	
	queryButton = (UIButton*)[view viewWithTag:862];
	[queryButton addTarget:self action:@selector(radioDoQuery) forControlEvents:UIControlEventTouchDown];
	
	[self queryByMonth:nil];
	yearMonthTextField.text = [NSString stringWithFormat:@"%@年%@月",self.startYear,self.startMonth ];
}
-(void)removeAllDataSource{
    [self.caseComparisonDataSource removeAllObjects];
	[self.caseStatisticsDataSource removeAllObjects];
	[self.permissionStatisticsDataSource removeAllObjects];
	[self.permissionComparisonDataSource removeAllObjects];
	[self.permitExpireDataSource removeAllObjects];
	[self.patrolComparisonDataSource removeAllObjects];
	[self.patrolStatisticsDataSource removeAllObjects];
}

-(void)setCaseNumType:(NSNumber *)page content:(NSString*)name{
	self.page = page;
	((UITextField*)[self.view viewWithTag:607]).text = name;
	if(segmentIndex ==0 && caseSegmentIndex ==1){
		[self caseComparisonStatisticsQuery];
	}else if(segmentIndex == 1 && permissionSegmentIndex == 1){
		[self permissionComparisonStatisticsQuery];
	}
}
-(void)permissionQuery{
	self.pagenum = 1;
	[self permissionMaturityQuery];
}
-(void)permissionQueryFrist{
	self.pagenum = 1;
	[self permissionMaturityQuery];
}
-(void)permissionQuerybefore{
	self.pagenum = self.pagenum - 1;
	[self permissionMaturityQuery];
}
-(void)permissionQuerynext{
	self.pagenum = self.pagenum + 1;;
	[self permissionMaturityQuery];
}
-(void)permissionQueryLast{
	self.pagenum = self.totalPageNum;
	[self permissionMaturityQuery];
}
-(void)btnPermissionWarningQuery{
	self.pagenum = 1;
	[self permissionWarningAllQuery];
}
-(void)permissionWarningQuery{
	self.pagenum = 1;
	[self permissionWarningAllQuery];
}
-(void)permissionWarningQueryFrist{
	self.pagenum = 1;
	[self permissionWarningAllQuery];
}
-(void)permissionWarningQuerybefore{
	self.pagenum = self.pagenum - 1;
	if (self.pagenum < 1) {
		self.pagenum = 1;
	}
	[self permissionWarningAllQuery];
}
-(void)permissionWarningQuerynext{
	self.pagenum = self.pagenum + 1;
	if (self.pagenum > self.totalPageNum) {
		self.pagenum = self.totalPageNum;
	}
	[self permissionWarningAllQuery];
}
-(void)permissionWarningQueryLast{
	self.pagenum = self.totalPageNum;
	[self permissionWarningAllQuery];
}

- (void)expandCollapseNode
{
    [self fillDisplayArray];
    [organizationTreeTableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(tableView == organizationTreeTableView){
		TreeViewNode *tree = (TreeViewNode*)[self.displayArray objectAtIndex:[indexPath row]];
		self.orgID= ((OrgInfoSimpleModel*)(tree.nodeObject)).identifier;
		//取消之前cell的选中状态
		CollapseCell *collapseCell = (CollapseCell*)orgCell;
		if([((OrgInfoSimpleModel*)(collapseCell.treeNode.nodeObject)).identifier isEqualToString:self.orgID]){
			collapseCell.backgroundColor = UIColorFromRGB(0xE0F8D8);
		}else if (collapseCell.treeNode.nodeLevel == 0) {
			collapseCell.backgroundColor = UIColorFromRGB(0xF7F7F7);
		} else if (collapseCell.treeNode.nodeLevel == 1) {
			collapseCell.backgroundColor = UIColorFromRGB(0xD1EEFC);
		} else if (collapseCell.treeNode.nodeLevel == 3) {
			collapseCell.backgroundColor = UIColorFromRGB(0xFFEC8B);
		}else if (collapseCell.treeNode.nodeLevel == 2) {
			collapseCell.backgroundColor = UIColorFromRGB(0x97FFFF);
		}else if (collapseCell.treeNode.nodeLevel == 4) {
			collapseCell.backgroundColor = UIColorFromRGB(0xFFE1FF);
		}else if (collapseCell.treeNode.nodeLevel == 5) {
			collapseCell.backgroundColor = UIColorFromRGB(0xFFF5EE);
		}
		orgCell = [tableView cellForRowAtIndexPath:indexPath];
		orgCell.backgroundColor = UIColorFromRGB(0xE0F8D8);
		self.pagenum = 1;
		((UITextField*)[self.view viewWithTag:793]).text = [NSString stringWithFormat:@"%d",self.pagenum ];
		[self doQuery];
	}
	
}







- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	if(tableView == organizationTreeTableView) return tableView.tableHeaderView;
	//segmentIndex如果有操作是一定会改变的
	if(segmentIndex != 1 || (permissionSegmentIndex != 2 && permissionSegmentIndex != 3)){
		return tableView.tableHeaderView;
	}
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
//    cell.contentView.backgroundColor = [UIColor whiteColor];
	cell.contentView.backgroundColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
	UILabel * lable1 =[[UILabel alloc]initWithFrame:CGRectMake(5, 0, cell.bounds.size.width/6, cell.frame.size.height)];
	[lable1 setText: @"序号"];
    [lable1 setFont:LISTNAME_FONT];
	lable1.textAlignment = NSTextAlignmentCenter;
	 [lable1 setBackgroundColor:[UIColor clearColor]];
	UILabel * lable2 =[[UILabel alloc]initWithFrame:CGRectMake(cell.bounds.size.width/6, 0, cell.bounds.size.width/2+50, cell.bounds.size.height)];
	[lable2 setText: @"许可案号"];
    [lable2 setFont:LISTNAME_FONT];
	lable2.textAlignment = NSTextAlignmentCenter;
	[lable2 setBackgroundColor:[UIColor clearColor]];
	UILabel * lable3 =[[UILabel alloc]initWithFrame:CGRectMake(cell.bounds.size.width/2+100, 0, cell.bounds.size.width/2+50, cell.bounds.size.height)];
	[lable3 setText: @"许可申请事项"];
    [lable3 setFont:LISTNAME_FONT];
	lable3.textAlignment = NSTextAlignmentCenter;
	[lable3 setBackgroundColor:[UIColor clearColor]];
	UILabel * lable4 =[[UILabel alloc]initWithFrame:CGRectMake(cell.bounds.size.width/2+300, 0, cell.bounds.size.width/5+50, cell.bounds.size.height)];
	[lable4 setText: @"申请日期"];
    [lable4 setFont:LISTNAME_FONT];
	lable4.textAlignment = NSTextAlignmentCenter;
	[lable4 setBackgroundColor:[UIColor clearColor]];
	UILabel * lable5 =[[UILabel alloc]initWithFrame:CGRectMake(cell.bounds.size.width/2+400, 0, cell.bounds.size.width/5+150, cell.bounds.size.height)];
	[lable5 setText: @"许可地点"];
    [lable5 setFont:LISTNAME_FONT];
	lable5.textAlignment = NSTextAlignmentCenter;
	[lable5 setBackgroundColor:[UIColor clearColor]];
	UILabel * lable6 =[[UILabel alloc]initWithFrame:CGRectMake(cell.bounds.size.width/2+610, 0, cell.bounds.size.width/3+10, cell.bounds.size.height)];
	[lable6 setText: @"申请人"];
	lable6.textAlignment = NSTextAlignmentCenter;
    [lable6 setFont:LISTNAME_FONT];
	[lable6 setBackgroundColor:[UIColor clearColor]];
	timeLabel =[[UILabel alloc]initWithFrame:CGRectMake(cell.bounds.size.width/2+720, 0, cell.bounds.size.width/4, cell.bounds.size.height)];
	
	if(permitExpireType == 2 && segmentIndex == 1 && permissionSegmentIndex == 3){
		[timeLabel setText: @"超期天数"];
	}else{
		[timeLabel setText: @"剩余天数"];
	}
    [timeLabel setFont:LISTNAME_FONT];
	[timeLabel setTag:986];
	timeLabel.textAlignment = NSTextAlignmentCenter;
	[timeLabel setBackgroundColor:[UIColor clearColor]];
	[cell.contentView addSubview:lable1];
	[cell.contentView addSubview:lable2];
	[cell.contentView addSubview:lable3];
	[cell.contentView addSubview:lable4];
	[cell.contentView addSubview:lable5];
	[cell.contentView addSubview:lable6];
	[cell.contentView addSubview:timeLabel];
	
	
    return cell.contentView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	if(tableView == organizationTreeTableView) return 0;
	//segmentIndex如果有操作是一定会改变的
	if(segmentIndex != 1 || (permissionSegmentIndex != 2 && permissionSegmentIndex != 3)){
		return 0;
	}
    return 37;
}

//下面四个方法都会清空textfield的内容，所以正常的逻辑都应该是点击单选按钮的时候就只是做初始化相关的控件
//而赋值的操作应该交给视图切换相关的事件
-(IBAction)queryByYear:(id)sender{
	radioSelectedType = 0;
	self.touchTextTag = -100;
	quarterSectionBeginLabel.hidden = YES;
	quarterSectionEndLabel.hidden = YES;
	yearMonthLabel.hidden = NO;
	yearMonthLabel.text = @"选择年份";
	
	
	quarterSectionBeginTextField.hidden = YES;
	quarterSectionEndTextField.hidden = YES;
	yearMonthTextField.hidden = NO;

	[self timeFieldsRemoveTarget];
	[yearMonthTextField addTarget:self action:@selector(yearTime:) forControlEvents:UIControlEventTouchDown];
}
-(IBAction)queryByMonth:(id)sender{
	radioSelectedType = 1;
	self.touchTextTag = -100;
	quarterSectionBeginLabel.hidden = YES;
	quarterSectionEndLabel.hidden = YES;
	yearMonthLabel.hidden = NO;
	yearMonthLabel.text = @"选择月份";
	
	quarterSectionBeginTextField.hidden = YES;
	quarterSectionEndTextField.hidden = YES;
	yearMonthTextField.hidden = NO;
	[self timeFieldsRemoveTarget];
	[yearMonthTextField addTarget:self action:@selector(yearMonthTime:) forControlEvents:UIControlEventTouchDown];
}
-(IBAction)queryByQuarter:(id)sender{
	radioSelectedType = 2;
	self.touchTextTag = -100;
	quarterSectionBeginLabel.hidden = YES;
	quarterSectionEndLabel.hidden = YES;
	yearMonthLabel.hidden = NO;
	yearMonthLabel.text = @"选择季度";

	
	
	quarterSectionBeginTextField.hidden = YES;
	quarterSectionEndTextField.hidden = YES;
	yearMonthTextField.hidden = NO;
	[self timeFieldsRemoveTarget];
	[yearMonthTextField addTarget:self action:@selector(yearQuarterTime:) forControlEvents:UIControlEventTouchDown];
	
}
-(IBAction)queryBySection:(id)sender{
	radioSelectedType = 3;
	self.touchTextTag = -100;
	quarterSectionBeginLabel.hidden = NO;
	quarterSectionEndLabel.hidden = NO;
	yearMonthLabel.hidden = YES;
	quarterSectionBeginLabel.text = @"开始时间";
	quarterSectionEndLabel.text = @"截至时间";
	
	
	quarterSectionBeginTextField.hidden = NO;
	quarterSectionEndTextField.hidden = NO;
	yearMonthTextField.hidden = YES;
	
	[self timeFieldsRemoveTarget];
	[quarterSectionBeginTextField addTarget:self action:@selector(yearMonthTime:) forControlEvents:UIControlEventTouchDown];
	[quarterSectionEndTextField addTarget:self action:@selector(yearMonthTime:) forControlEvents:UIControlEventTouchDown];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
	return NO;
}


-(void)setYearQuarter:(NSString *)year  quarter:(NSString*)quarter{
	self.currentTextField.text = [year stringByAppendingFormat:@"年%@",quarter];
}
-(void)setPickerYear:(NSString *)year{
	self.currentTextField.text = [year stringByAppendingString:@"年"];
}
- (void) timeFieldsRemoveTarget{
	yearMonthTextField.delegate = self;
	[yearMonthTextField removeTarget:self action:@selector(yearMonthTime:) forControlEvents:UIControlEventTouchDown];
	[yearMonthTextField removeTarget:self action:@selector(yearQuarterTime:) forControlEvents:UIControlEventTouchDown];
	[yearMonthTextField removeTarget:self action:@selector(yearTime:) forControlEvents:UIControlEventTouchDown];
	
	[quarterSectionEndTextField removeTarget:self action:@selector(yearMonthTime:) forControlEvents:UIControlEventTouchDown];
	[quarterSectionEndTextField removeTarget:self action:@selector(yearQuarterTime:) forControlEvents:UIControlEventTouchDown];
	[quarterSectionEndTextField removeTarget:self action:@selector(yearTime:) forControlEvents:UIControlEventTouchDown];
	
	[quarterSectionBeginTextField removeTarget:self action:@selector(yearMonthTime:) forControlEvents:UIControlEventTouchDown];
	[quarterSectionBeginTextField removeTarget:self action:@selector(yearQuarterTime:) forControlEvents:UIControlEventTouchDown];
	[quarterSectionBeginTextField removeTarget:self action:@selector(yearTime:) forControlEvents:UIControlEventTouchDown];
	
	yearMonthTextField.text = @"";
	quarterSectionBeginTextField.text = @"";
	quarterSectionEndTextField.text = @"";
	
}
-(void)doQuery{
	if(segmentIndex == 0 && caseSegmentIndex == 0){
		[self caseStatisticsQuery];
	}else if(segmentIndex == 0 && caseSegmentIndex == 1){
		[self caseComparisonStatisticsQuery];
	}else if(segmentIndex == 1 && permissionSegmentIndex == 0){
		[self permissionStatisticsQuery];
	}else if(segmentIndex == 1 && permissionSegmentIndex == 1){
		[self permissionComparisonStatisticsQuery];
	}else if(segmentIndex == 1 && permissionSegmentIndex == 2){
		[self permissionMaturityQuery];
	}else if(segmentIndex == 1 && permissionSegmentIndex == 3){
		[self permissionWarningAllQuery];
	}else if(segmentIndex == 2 && patrolSegmentIndex == 0){
		[self patrolStatisticsQuery];
	}else if(segmentIndex == 2 && patrolSegmentIndex == 1){
		[self patrolComparisonStatisticsQuery];
	}
}


-(void)radioDoQuery{
	switch (radioSelectedType) {
		case 0:{
			NSString *str = yearMonthTextField.text;
			if(str == nil || str.length < 1) return;
			self.startYear = [NSNumber numberWithInt:[[str substringToIndex:str.length-1] integerValue]];
			self.startMonth = [NSNumber numberWithInt:0];
			self.endYear = nil;
			self.endMonth = nil;
		}
			break;
		case 1:{
			NSString *str = yearMonthTextField.text;
			if(str == nil || str.length < 1) return;
			NSRange rang = [str rangeOfString:@"年"];
			self.startYear = [NSNumber numberWithInt:[[yearMonthTextField.text substringToIndex:rang.location] integerValue]];
			rang.location = rang.location + 1;
			rang.length = str.length - rang.location -1;
			self.startMonth = [NSNumber numberWithInt:[[yearMonthTextField.text substringWithRange:rang] integerValue]];
			self.endYear = nil;
			self.endMonth = nil;
		}
			break;
		case 2:{
			NSString *str = yearMonthTextField.text;
			if(str == nil || str.length < 1) return;
			NSRange rang = [str rangeOfString:@"年"];
			self.startYear = self.endYear = [NSNumber numberWithInt:[[str substringToIndex:rang.location] integerValue]];
			self.startMonth = [NSNumber numberWithInt:1];
			rang.location = rang.location + 3;
			rang.length = str.length - rang.location -1;
			self.endMonth = [NSNumber numberWithInt:[[str substringWithRange:rang] integerValue]];
		}
			break;
		case 3:{
			NSString *str = quarterSectionBeginTextField.text;
			if(str != nil && str.length >= 1){
				NSRange rang = [str rangeOfString:@"年"];
				self.startYear = [NSNumber numberWithInt:[[str substringToIndex:rang.location] integerValue]];
			
				rang.location = rang.location + 1;
				rang.length = str.length - rang.location -1;
				self.startMonth = [NSNumber numberWithInt:[[str substringWithRange:rang] integerValue]];
				
				str = quarterSectionEndTextField.text;
				if(str != nil && str.length >= 1){
					rang = [str rangeOfString:@"年"];
					self.endYear = [NSNumber numberWithInt:[[str substringToIndex:rang.location] integerValue]];
					
					rang.location = rang.location + 1;
					rang.length = str.length - rang.location -1;
					self.endMonth = [NSNumber numberWithInt:[[str substringWithRange:rang] integerValue]];
				}
			}

		}
			break;
	}
	[self doQuery];
}

#pragma mark - 本页面使用到的所有查询


-(void)caseStatisticsQuery{
	NSString *startYear = [NSString stringWithFormat:@"%d",[self.startYear integerValue]];
	if (!self.startYear) {
		startYear = @"";
	}
	NSString *startMonth = [NSString stringWithFormat:@"%d",[self.startMonth integerValue]];
	if (!self.startMonth) {
		startMonth = @"";
	}
	NSString *endYear = [NSString stringWithFormat:@"%d",[self.endYear integerValue]];
	if (!self.endYear) {
		endYear = @"";
	}
	NSString *endMonth = [NSString stringWithFormat:@"%d",[self.endMonth integerValue]];
	if (!self.endMonth) {
		endMonth = @"";
	}

	self.dicData= @{@"orgId":self.orgID,@"startYear":startYear,@"startMonth":startMonth,@"endYear":endYear,@"endMonth":endMonth,@"type":@"anjian"};
	[[[DataModelCenter defaultCenter]webService]getSupervisionStatisticsNewData:self.dicData withAsyncHanlder:self.caseStatisticsRequestHandle];
}
-(void)caseComparisonStatisticsQuery{
	NSString *startYear = [NSString stringWithFormat:@"%d",[self.startYear integerValue]];
	if (!self.startYear) {
		startYear = @"";
	}
	NSString *startMonth = [NSString stringWithFormat:@"%d",[self.startMonth integerValue]];
	if (!self.startMonth) {
		startMonth = @"";
	}
	NSString *endYear = [NSString stringWithFormat:@"%d",[self.endYear integerValue]];
	if (!self.endYear) {
		endYear = @"";
	}
	NSString *endMonth = [NSString stringWithFormat:@"%d",[self.endMonth integerValue]];
	if (!self.endMonth) {
		endMonth = @"";
	}

	self.dicData= @{@"orgId":self.orgID,@"startYear":startYear,@"startMonth":startMonth,@"endYear":endYear,@"endMonth":endMonth,@"type":@"anjian",@"page":self.page};
	[[[DataModelCenter defaultCenter]webService]getSupervisionStatisticsNewLowerOrgData:self.dicData withAsyncHanlder:self.caseComparisonRequestHandle];
}



-(void)permissionStatisticsQuery{
	NSString *startYear = [NSString stringWithFormat:@"%d",[self.startYear integerValue]];
	if (!self.startYear) {
		startYear = @"";
	}
	NSString *startMonth = [NSString stringWithFormat:@"%d",[self.startMonth integerValue]];
	if (!self.startMonth) {
		startMonth = @"";
	}
	NSString *endYear = [NSString stringWithFormat:@"%d",[self.endYear integerValue]];
	if (!self.endYear) {
		endYear = @"";
	}
	NSString *endMonth = [NSString stringWithFormat:@"%d",[self.endMonth integerValue]];
	if (!self.endMonth) {
		endMonth = @"";
	}

	self.dicData= @{@"orgId":self.orgID,@"startYear":startYear,@"startMonth":startMonth,@"endYear":endYear,@"endMonth":endMonth,@"type":@"xuke"};
	[[[DataModelCenter defaultCenter]webService]getSupervisionStatisticsNewData:self.dicData withAsyncHanlder:self.permissionStatisticsRequestHandle];
}
-(void)permissionComparisonStatisticsQuery{
	NSString *startYear = [NSString stringWithFormat:@"%d",[self.startYear integerValue]];
	if (!self.startYear) {
		startYear = @"";
	}
	NSString *startMonth = [NSString stringWithFormat:@"%d",[self.startMonth integerValue]];
	if (!self.startMonth) {
		startMonth = @"";
	}
	NSString *endYear = [NSString stringWithFormat:@"%d",[self.endYear integerValue]];
	if (!self.endYear) {
		endYear = @"";
	}
	NSString *endMonth = [NSString stringWithFormat:@"%d",[self.endMonth integerValue]];
	if (!self.endMonth) {
		endMonth = @"";
	}

	self.dicData= @{@"orgId":self.orgID,@"startYear":startYear,@"startMonth":startMonth,@"endYear":endYear,@"endMonth":endMonth,@"type":@"xuke",@"page":self.page};
	[[[DataModelCenter defaultCenter]webService]getSupervisionStatisticsNewLowerOrgData:self.dicData withAsyncHanlder:self.permissionComparisonRequestHandle];
	
}
-(void)permissionMaturityQuery{
	NSString * case_no = ((UITextField*)[self.view viewWithTag:154]).text;
	if (case_no == nil) {
		case_no = @"";
	}
	NSString * applicant_name = ((UITextField*)[self.view viewWithTag:155]).text;
	if (applicant_name == nil) {
		applicant_name = @"";
	}
	UILabel *label = (UILabel*)[self.view viewWithTag:123];
	NSInteger type = ((UISegmentedControl*)[self.view viewWithTag:156]).selectedSegmentIndex;
	if (type != 0 && type != 1) {
		type = 1;
		[label setText:@"超期天数"];
	}else if(type == 1){
		[label setText:@"超期天数"];
	}else{
		[label setText:@"剩余天数"];
	}
	self.dicData= @{@"orgId":self.orgID,@"case_no":case_no,@"applicant_name":applicant_name,@"type":[[NSNumber alloc ]initWithInt:type ],@"pagenum":[[NSNumber alloc ]initWithInt:self.pagenum ]};
	[[[DataModelCenter defaultCenter]webService]getSupervisionPermitExpireList:self.dicData withAsyncHanlder:self.permitExpireRequestHandle];
	[[[DataModelCenter defaultCenter]webService]getSupervisionPermitExpireSize:self.dicData withAsyncHanlder:self.permitExpireSizeRequestHandle];
}
-(void)permissionWarningAllQuery{
	NSString * case_no = ((UITextField*)[self.view viewWithTag:154]).text;
	if (case_no == nil) {
		case_no = @"";
	}
	NSString * applicant_name = ((UITextField*)[self.view viewWithTag:155]).text;
	if (applicant_name == nil) {
		applicant_name = @"";
	}
	NSInteger type = ((UISegmentedControl*)[self.view viewWithTag:156]).selectedSegmentIndex;
	if (type != 2 && type != 1) {
		type = 2;
	}
	permitExpireType = type;
	self.dicData= @{@"orgId":self.orgID,@"case_no":case_no,@"applicant_name":applicant_name,@"isContainLowerOrg":@"0",@"warningLevel":[[NSNumber alloc ]initWithInt:type ],@"pagenum":[[NSNumber alloc ]initWithInt:self.pagenum ]};
	[[[DataModelCenter defaultCenter]webService]getSupervisionAppWarningList:self.dicData withAsyncHanlder:self.permitWarningsRequestHandle];
	[[[DataModelCenter defaultCenter]webService]getSupervisionAppWarningSize:self.dicData withAsyncHanlder:self.permitWarningSizeRequestHandle];
}

-(void)patrolStatisticsQuery{
	NSString *startYear = [NSString stringWithFormat:@"%d",[self.startYear integerValue]];
	if (!self.startYear) {
		startYear = @"";
	}
	NSString *startMonth = [NSString stringWithFormat:@"%d",[self.startMonth integerValue]];
	if (!self.startMonth) {
		startMonth = @"";
	}
	NSString *endYear = [NSString stringWithFormat:@"%d",[self.endYear integerValue]];
	if (!self.endYear) {
		endYear = @"";
	}
	NSString *endMonth = [NSString stringWithFormat:@"%d",[self.endMonth integerValue]];
	if (!self.endMonth) {
		endMonth = @"";
	}

	self.dicData= @{@"orgId":self.orgID,@"startYear":startYear,@"startMonth":startMonth,@"endYear":endYear,@"endMonth":endMonth,@"type":@"xuncha"};
	[[[DataModelCenter defaultCenter]webService]getSupervisionStatisticsNewData:self.dicData withAsyncHanlder:self.patrolStatisticsRequestHandle];
	
}
-(void)patrolComparisonStatisticsQuery{
	NSString *startYear = [NSString stringWithFormat:@"%d",[self.startYear integerValue]];
	if (!self.startYear) {
		startYear = @"";
	}
	NSString *startMonth = [NSString stringWithFormat:@"%d",[self.startMonth integerValue]];
	if (!self.startMonth) {
		startMonth = @"";
	}
	NSString *endYear = [NSString stringWithFormat:@"%d",[self.endYear integerValue]];
	if (!self.endYear) {
		endYear = @"";
	}
	NSString *endMonth = [NSString stringWithFormat:@"%d",[self.endMonth integerValue]];
	if (!self.endMonth) {
		endMonth = @"";
	}

	self.dicData= @{@"orgId":self.orgID,@"startYear":startYear,@"startMonth":startMonth,@"endYear":endYear,@"endMonth":endMonth,@"type":@"xuncha",@"page":self.page};
	[[[DataModelCenter defaultCenter]webService]getSupervisionStatisticsNewLowerOrgData:self.dicData withAsyncHanlder:self.patrolComparisonRequestHandle];
	
}



- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}



-(void)handleSingleTap:(UITapGestureRecognizer *)sender{
	[self showHTML:html];
	
}
- (void)showHTML:(NSString *)urlString{
	
    CGRect rect = CGRectMake(200, 50, 1100, 700);
    
    //如果需要在popover消失的时候做事情，需要写一些delegate方法
	//    popoverController.delegate = self;//可不设置，如果不需要的话
    //popover显示的大小
    _myPopoverController.popoverContentSize=rect.size;
    

	UIWebView* popoverView = [[UIWebView alloc]
							  initWithFrame:CGRectMake(0, 0, 1024, 768)];
	popoverView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
	_popoverContent.view = popoverView;
	[popoverView loadHTMLString:html baseURL:baseURL];
	
    UIView *view = [self.view viewWithTag:605];
    //显示popover，则理告诉它是为一个矩形框设置popover
    [_myPopoverController presentPopoverFromRect:rect inView:view
						permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
}
-(void)webViewADDGesture:(UIWebView*)webView{
	UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
	singleTap.numberOfTapsRequired = 2;
	[webView addGestureRecognizer:singleTap];
	singleTap.delegate = self;
	singleTap.cancelsTouchesInView = NO;
}

@end
