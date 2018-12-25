//
//  InspectionMainViewController.m
//  GDZhiFaJianGuanSystem
//
//  Created by XU SHIWEN on 14-2-7.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import "RoadEngrossMainViewController.h"
#import "RoadEngrossInfoViewController.h"
#import "RoadEngrossMainCell.h"
#import "DateSelectController.h"
#import "DataModelCenter.h"
#import "EmployeeInfoModel.h"
#import "AppUtil.h"
#import "CollapseCell.h"


#define SCROLLVIEW_WIDTH 1320.0

@interface RoadEngrossMainViewController ()<UIPopoverControllerDelegate,DatetimePickerHandler,OrgPickerDelegate>
{
    NSInteger pickerType;
	NSMutableArray *orgTreeViewNodes;
	//被选中的机构
	CollapseCell *orgCell;
	NSString* roadId;
	NSString* dealWith;
}
@property (nonatomic, retain) UIPopoverController * permitListPopover;
@property (nonatomic, retain) NSMutableArray * dataArray;
@property (nonatomic, assign) UITextField * currentTextField;
@property (nonatomic,assign)  NSInteger touchTextTag;
@property (nonatomic, retain) DateSelectController * popoverContent;
@property (nonatomic, strong) DataModelCenter * dataModelCenter;
@property (nonatomic, strong) NSMutableArray * childOrgArray;//机构第一层数组
@property (nonatomic, strong) NSString * orgID;//

@property (copy, nonatomic) NSString *employeeId; // 从人员管理进行查询的人员id
@property (nonatomic, retain) NSMutableArray * allOrgID;//全部机构ID
@property (nonatomic, retain) NSNumber * allPageNumeber;//总页数
@property (nonatomic, strong) NSString * inspectionType;//巡查类型
@end

@implementation RoadEngrossMainViewController

+ (instancetype)newInstance
{
    return [[[self alloc] initWithNibName:@"RoadEngrossMainView" bundle:nil] prepareForUse];
}

- (id)prepareForUse
{
    //在这里完成一些内部参数的初始化
    self.dataModelCenter=[DataModelCenter defaultCenter];
    _dataArray =[[NSMutableArray alloc] init];
    self.childOrgArray=[[NSMutableArray alloc] init];
    _allOrgID = [[NSMutableArray alloc] init];
    self.inspectionType = @"";
    self.employeeId = @"";
    [self obtainWithAllOrgID];
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

-(void)viewDidAppear:(BOOL)animated
{
    
}
- (void)viewDidLoad
{
	[[[DataModelCenter defaultCenter] webService].queue cancelAllOperations];
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
    [self setTitle:@"占利用档案"];
    roadId = @"";
	self.textAppCode.delegate = self;
	self.textStation_start.delegate = self;
	self.textStation_end.delegate = self;
	self.textRoadId.delegate = self;
	self.textDateStart.delegate = self;
	self.textDeal_with.delegate = self;
	self.textDateEnd.delegate = self;
	UIBarButtonItem * backbutton =[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(backButton)];
    [self.navigationItem setLeftBarButtonItem:backbutton animated:YES];
    
	UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCROLLVIEW_WIDTH, 633) style:UITableViewStylePlain];
	_tabelList = tableView;
    [_tabelList setDataSource:self];
    [_tabelList setDelegate:self];
    [_scrollView addSubview:_tabelList];
	_scrollView.contentMode=UIViewContentModeLeft;
    _scrollView.bounces=NO;
    _scrollView.contentSize=CGSizeMake(SCROLLVIEW_WIDTH, 342);
    _scrollView.contentInset=UIEdgeInsetsZero;
	
	
    // 设置查询视图初始状态为隐藏
//    self.queryView.hidden = YES;
    
    self.permitListPopover=[[UIPopoverController alloc] initWithContentViewController:[[UIViewController alloc] init]];
	
	_organizationTreeTableView.delegate = self;
	_organizationTreeTableView.dataSource = self;
	if (ORG_TREE == nil ||[ORG_TREE count]==0) {
		[[[DataModelCenter defaultCenter] webService] getSupervisionLowerOrgList:@"" withAsyncHanlder:^(NSArray *orgList, NSError *err) {
			if (err == nil) {
				dispatch_sync(dispatch_get_main_queue(), ^{
					if (ORG_TREE == nil ||[ORG_TREE count]==0) {
						[AppUtil getTreeViewNode:orgList];
					}
					[self fillDisplayArray];
					[_organizationTreeTableView reloadData];
				});
			}
		}];
	}else{
		[self fillDisplayArray];
		[_organizationTreeTableView reloadData];
	}

	if (!self.statisticModel && !self.employeeModel) {
		[self buttonQuery:nil];
	}
	else if (self.statisticModel){
//            [self searchFromStatistic];
	}
	else if (self.employeeModel){
//            [self searchFromEmployee];
	}
}

#pragma mark - method

// 从巡查统计里获得搜索条件
- (void)searchFromStatistic{
    self.orgID = [self statisticModel].orgid;
    NSString *startTime = nil;
    NSString *endTime = nil;
    self.inspectionType =KILL_NIL_STRING(self.statisticModel.typenames);
    
    if ([KILL_NIL_STRING(self.statisticModel.dateTime) isEqualToString:@""]&&self.statisticModel.dateTime.length<8) {
        startTime = @"";
        endTime = @"";
    }else
    {
        startTime = [NSString stringWithFormat:@"%@01",[self.statisticModel.dateTime substringToIndex:8]];
        endTime = [NSString stringWithFormat:@"%@30",[self.statisticModel.dateTime substringToIndex:8]];
        self.textDateStart.text = startTime;
        self.textDateEnd.text = endTime;
    }
    NSDictionary * dicTest = @{@"orgId":self.orgID,@"dateStart":startTime,@"dateEnd":endTime,@"pageNum":@"1",@"inspectionType":KILL_NIL_STRING(self.inspectionType),@"isContainLowerOrg":@"1",@"employeeId":KILL_NIL_STRING(self.employeeId)};
    NSDictionary * pageDic = @{@"orgId":self.orgID,@"dateStart":startTime,@"dateEnd":endTime,@"inspectionType":KILL_NIL_STRING(self.inspectionType),@"isContainLowerOrg":@"1",@"employeeId":KILL_NIL_STRING(self.employeeId)};
    [self searchWithParameters:dicTest sizeParameters:pageDic];
}

- (void)searchFromEmployee{
    self.orgID = [self employeeModel].organization_id;
    self.employeeId = [self employeeModel].identifier;
    [self setTitle:[NSString stringWithFormat:@"%@参与过的占利用档案",[self employeeModel].name]];
	
	if(self.allOrgID == nil || [self.allOrgID count] <= 0){
		[self obtainWithAllOrgID];
	}
	for (OrgInfoSimpleModel * orgInfo in self.allOrgID) {
        if ([orgInfo.identifier isEqualToString:self.orgID]) {
            NSString * custodyOrgName =orgInfo.orgName;
        }
    }
	
	
    NSString *dateStart = KILL_NIL_STRING([self textDateStart].text);
    NSString *dateEnd = KILL_NIL_STRING([self textDateEnd].text);
    
    NSDictionary * dicTest = @{@"orgId":self.orgID,@"dateStart":dateStart,@"dateEnd":dateEnd,@"pageNum":@"1",@"inspectionType":KILL_NIL_STRING(self.inspectionType),@"isContainLowerOrg":@"1",@"employeeId":KILL_NIL_STRING(self.employeeId)};
    NSDictionary * pageDic = @{@"orgId":self.orgID,@"dateStart":dateStart,@"dateEnd":dateEnd,@"inspectionType":KILL_NIL_STRING(self.inspectionType),@"isContainLowerOrg":@"1",@"employeeId":KILL_NIL_STRING(self.employeeId)};
    [self searchWithParameters:dicTest sizeParameters:pageDic];
}

- (void)searchWithParameters:(NSDictionary *)params sizeParameters:(NSDictionary *)sizeParams{

	[[self.dataModelCenter webService]getSupervisionRoadEngrossList:params withAsyncHanlder:^(NSArray *inspectionList, NSError *err) {
		dispatch_sync(dispatch_get_main_queue(), ^{
			if (inspectionList.count==0) {
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有符合条件数据" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
				[alert show];
			}
			[_dataArray removeAllObjects];
			[_dataArray addObjectsFromArray:inspectionList];
			[_tabelList reloadData];
		});
	}];
	self.labelPageNumber.text = @"1";
	
	[[self.dataModelCenter webService] getSupervisionRoadEngrossListSize:sizeParams withAsyncHanlder:^(int inspectionList, NSError *err) {
		dispatch_sync(dispatch_get_main_queue(), ^{
			NSInteger page = ceil(inspectionList/10.0f);
			_allPageNumeber = [NSNumber numberWithInteger:0==page?1:page];
			self.labelTotalNumber.text = [NSString stringWithFormat:@"%d",inspectionList];
		});
	}];
    
}

-(void)obtainWithAllOrgID{
    //在表中读取到全部机构信息
    NSManagedObjectContext *context=[MYAPPDELEGATE managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"OrgInfoSimpleModel" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    [self.allOrgID addObjectsFromArray:fetchedObjects];
//    for (OrgInfoSimpleModel * orgInfo in fetchedObjects) {
//        NSLog(@"Name: %@", orgInfo.identifier);
//        [self.allOrgID addObject:orgInfo];
//    }
}

#pragma mark - IBActions

- (void)backButton
{
    [self.navigationController popViewControllerAnimated:YES];
}



- (IBAction)Org:(UITextField *)sender {
    OrgSelectController *orgPicker = nil;
    if ((self.touchTextTag == sender.tag) && ([self.permitListPopover isPopoverVisible])) {
        [self.permitListPopover dismissPopoverAnimated:YES];
    } else {
        self.touchTextTag=sender.tag;
        orgPicker = [[OrgSelectController alloc] init];
        orgPicker.delegate = self;
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:orgPicker];
        nav.navigationBarHidden = YES;
        self.permitListPopover=[[UIPopoverController alloc] initWithContentViewController:nav];
        [self.permitListPopover setPopoverContentSize:CGSizeMake(300, 320)];
        [self.permitListPopover presentPopoverFromRect:sender.frame inView:self.queryView permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        orgPicker.pickerPopover=self.permitListPopover;
    }
    orgPicker.orgDataArray =self.childOrgArray;
}

- (IBAction)startingTime:(UITextField *)sender {
	self.currentTextField = sender;
    [sender resignFirstResponder];
    if ((self.touchTextTag == sender.tag) && ([self.permitListPopover isPopoverVisible])) {
        [self.permitListPopover dismissPopoverAnimated:YES];
    } else {
        self.touchTextTag=sender.tag;
        DateSelectController *datePicker=[[DateSelectController alloc] init];
        datePicker.delegate=self;
        datePicker.pickerType = pickerType;
        [self.permitListPopover setContentViewController:datePicker];
        [self.permitListPopover setPopoverContentSize:CGSizeMake(300, 260)];
        [self.permitListPopover presentPopoverFromRect:sender.frame inView:self.queryView permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
        datePicker.dateselectPopover=self.permitListPopover;
    }
}

- (IBAction)endTime:(UITextField *)sender {
	self.currentTextField = sender;
    [sender resignFirstResponder];
    if ((self.touchTextTag == sender.tag) && ([self.permitListPopover isPopoverVisible])) {
        [self.permitListPopover dismissPopoverAnimated:YES];
    } else {
        self.touchTextTag=sender.tag;
        DateSelectController *datePicker=[[DateSelectController alloc] init];
        datePicker.delegate=self;
        datePicker.pickerType = pickerType;
        [self.permitListPopover setContentViewController:datePicker];
        [self.permitListPopover setPopoverContentSize:CGSizeMake(300, 260)];
        [self.permitListPopover presentPopoverFromRect:sender.frame inView:self.queryView permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
        datePicker.dateselectPopover=self.permitListPopover;
    }
}

-(void)setOrgID:(NSString *)identifier withOrgName:(NSString *)orgName{
    self.orgID=identifier;
}

- (IBAction)buttonQuery:(id)sender
{


    self.labelPageNumber.text =@"1";
    

	NSString * appCode = KILL_NIL_STRING(self.textAppCode.text);
	if(self.textRoadId.text == nil || [self.textRoadId.text isEmpty]){
		roadId = @"";
	}
	NSString * station_start = KILL_NIL_STRING(self.textStation_start.text);
	NSString * station_end = KILL_NIL_STRING(self.textStation_end.text);
	if(self.textDeal_with.text == nil || [self.textDeal_with.text isEmpty]){
		dealWith = @"";
	}
	NSString * dateStart = KILL_NIL_STRING(self.textDateStart.text);
	NSString * dateEnd = KILL_NIL_STRING(self.textDateEnd.text);
	
    if (!self.orgID)
    {
         self.orgID = [[NSUserDefaults standardUserDefaults] objectForKey:ORGKEY];
    }
	
	//三个中有任一个有值
	if((dateStart != nil && ![dateStart isEmpty]) || (dateStart != nil && ![dateStart isEmpty]) || (dealWith != nil && ![dealWith isEmpty])){
		if((dateStart != nil && ![dateStart isEmpty]) && (dateStart != nil && ![dateStart isEmpty]) && (dealWith != nil && ![dealWith isEmpty])){
			//三个都有值，不用做任何操作
		}else{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"查询类型 开始日期 结束日期三个必须都有值" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
			return;
		}
	}
    NSDictionary * dicTest = @{@"orgId":self.orgID,@"isContainLowerOrg":@"1",@"appCode":appCode,@"roadId":KILL_NIL_STRING(roadId),@"station_start":station_start,@"station_end":station_end,@"deal_with":KILL_NIL_STRING(dealWith),@"dateStart":dateStart,@"dateEnd":dateEnd,@"pageNum":self.labelPageNumber.text};
    [[self.dataModelCenter webService]getSupervisionRoadEngrossList:dicTest withAsyncHanlder:^(NSArray *inspectionList, NSError *err) {
        dispatch_sync(dispatch_get_main_queue(), ^{
			if (inspectionList.count==0) {
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有符合条件数据" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
				[alert show];
			}
			
			[_dataArray removeAllObjects];
			[_dataArray addObjectsFromArray:inspectionList];
			[_tabelList reloadData];
		});
    }];
	
    NSDictionary * pageDic = @{@"orgId":self.orgID,@"isContainLowerOrg":@"1",@"employeeId":KILL_NIL_STRING(self.employeeId),@"appCode":KILL_NIL_STRING(appCode),@"roadId":KILL_NIL_STRING(roadId),@"station_start":KILL_NIL_STRING(station_start),@"station_end":KILL_NIL_STRING(station_end),@"deal_with":KILL_NIL_STRING(dealWith),@"dateStart":KILL_NIL_STRING(dateStart),@"dateEnd":KILL_NIL_STRING(dateEnd)};
    [[self.dataModelCenter webService] getSupervisionRoadEngrossListSize:pageDic withAsyncHanlder:^(int inspectionList, NSError *err) {
		dispatch_sync(dispatch_get_main_queue(), ^{
			NSInteger page = ceil(inspectionList/10.0f);
			_allPageNumeber = [NSNumber numberWithInteger:0==page?1:page];
			self.labelTotalNumber.text = [NSString stringWithFormat:@"%d",inspectionList];
		});
    }];
}
- (IBAction)bthPreviousPage:(UIButton *)sender
{
    if ([self.labelPageNumber.text intValue] == 1) {
        return;
    }
    if (![_labelPageNumber.text  isEqual: @"1"]) {
        _labelPageNumber.text = [NSString stringWithFormat:@"%d",_labelPageNumber.text.intValue - 1] ;
        NSString * pageNumber = _labelPageNumber.text;
		NSString * appCode = KILL_NIL_STRING(self.textAppCode.text);

		if(self.textRoadId.text == nil || [self.textRoadId.text isEmpty]){
			roadId = @"";
		}
		NSString * station_start = KILL_NIL_STRING(self.textStation_start.text);
		NSString * station_end = KILL_NIL_STRING(self.textStation_end.text);
		if(self.textDeal_with.text == nil || [self.textDeal_with.text isEmpty]){
			dealWith = @"";
		}
		NSString * dateStart = KILL_NIL_STRING(self.textDateStart.text);
		NSString * dateEnd = KILL_NIL_STRING(self.textDateEnd.text);
		NSDictionary * dicTest = @{@"orgId":self.orgID,@"isContainLowerOrg":@"1",@"appCode":KILL_NIL_STRING(appCode),@"roadId":KILL_NIL_STRING(roadId),@"station_start":KILL_NIL_STRING(station_start),@"station_end":KILL_NIL_STRING(station_end),@"deal_with":KILL_NIL_STRING(dealWith),@"dateStart":KILL_NIL_STRING(dateStart),@"dateEnd":KILL_NIL_STRING(dateEnd),@"pageNum":pageNumber};
        [[self.dataModelCenter webService]getSupervisionRoadEngrossList:dicTest withAsyncHanlder:^(NSArray *inspectionList, NSError *err) {
            dispatch_sync(dispatch_get_main_queue(), ^{
				if (inspectionList.count==0) {
					UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有符合条件数据" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
					[alert show];
				}
				[_dataArray removeAllObjects];
				[_dataArray addObjectsFromArray:inspectionList];
				[_tabelList reloadData];
			});
        }];
    }
}
- (IBAction)bthNextPage:(UIButton *)sender
{
    if ([_allPageNumeber intValue] == [self.labelPageNumber.text intValue]) {
        return;
    }
    
    _labelPageNumber.text = [NSString stringWithFormat:@"%d",_labelPageNumber.text.intValue + 1] ;
    NSString * pageNumber = _labelPageNumber.text;

	NSString * appCode = KILL_NIL_STRING(self.textAppCode.text);
	if(self.textRoadId.text == nil || [self.textRoadId.text isEmpty]){
		roadId = @"";
	}
	NSString * station_start = KILL_NIL_STRING(self.textStation_start.text);
	NSString * station_end = KILL_NIL_STRING(self.textStation_end.text);
	if(self.textDeal_with.text == nil || [self.textDeal_with.text isEmpty]){
		dealWith = @"";
	}
	NSString * dateStart = KILL_NIL_STRING(self.textDateStart.text);
	NSString * dateEnd = KILL_NIL_STRING(self.textDateEnd.text);
    NSDictionary * dicTest = @{@"orgId":self.orgID,@"isContainLowerOrg":@"1",@"appCode":KILL_NIL_STRING(appCode),@"roadId":KILL_NIL_STRING(roadId),@"station_start":KILL_NIL_STRING(station_start),@"station_end":KILL_NIL_STRING(station_end),@"deal_with":KILL_NIL_STRING(dealWith),@"dateStart":KILL_NIL_STRING(dateStart),@"dateEnd":KILL_NIL_STRING(dateEnd),@"pageNum":pageNumber};
    [[self.dataModelCenter webService]getSupervisionRoadEngrossList:dicTest withAsyncHanlder:^(NSArray *inspectionList, NSError *err) {
        dispatch_sync(dispatch_get_main_queue(), ^{
			if (inspectionList.count==0) {
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有符合条件数据" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
				[alert show];
			}
			[_dataArray removeAllObjects];
			[_dataArray addObjectsFromArray:inspectionList];
			[_tabelList reloadData];
		});
    }];

}
- (IBAction)bthEndPage:(UIButton *)sender
{
    if ([self.labelPageNumber.text intValue] == [self.allPageNumeber integerValue]) {
        return;
    }
    _labelPageNumber.text = [self.allPageNumeber stringValue];
    NSString * pageNumber = self.labelPageNumber.text;
	NSString * appCode = KILL_NIL_STRING(self.textAppCode.text);
	if(self.textRoadId.text == nil || [self.textRoadId.text isEmpty]){
		roadId = @"";
	}
	
	NSString * station_start = KILL_NIL_STRING(self.textStation_start.text);
	NSString * station_end = KILL_NIL_STRING(self.textStation_end.text);
	if(self.textDeal_with.text == nil || [self.textDeal_with.text isEmpty]){
		dealWith = @"";
	}
	NSString * dateStart = KILL_NIL_STRING(self.textDateStart.text);
	NSString * dateEnd = KILL_NIL_STRING(self.textDateEnd.text);
	
    NSDictionary * dicTest = @{@"orgId":self.orgID,@"isContainLowerOrg":@"1",@"appCode":KILL_NIL_STRING(appCode),@"roadId":KILL_NIL_STRING(roadId),@"station_start":KILL_NIL_STRING(station_start),@"station_end":KILL_NIL_STRING(station_end),@"deal_with":KILL_NIL_STRING(dealWith),@"dateStart":KILL_NIL_STRING(dateStart),@"dateEnd":KILL_NIL_STRING(dateEnd),@"pageNum":pageNumber};
    [[self.dataModelCenter webService]getSupervisionRoadEngrossList:dicTest withAsyncHanlder:^(NSArray *inspectionList, NSError *err) {
        dispatch_sync(dispatch_get_main_queue(), ^{
			if (inspectionList.count==0) {
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有符合条件数据" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
				[alert show];
			}
			[_dataArray removeAllObjects];
			[_dataArray addObjectsFromArray:inspectionList];
			[_tabelList reloadData];
		});
    }];
}

#pragma mark - UITextFieldDelegateMethod
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	
    self.currentTextField = textField;
	CGRect queryViewRect = _queryView.frame;
	if(textField == _textAppCode || textField == _textStation_end || textField == _textStation_start){
		_queryView.frame = CGRectMake(queryViewRect.origin.x, queryViewRect.origin.y-250, queryViewRect.size.width, queryViewRect.size.height);
	}
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
	CGRect queryViewRect = _queryView.frame;
	if(textField == _textAppCode || textField == _textStation_end || textField == _textStation_start){
		_queryView.frame = CGRectMake(queryViewRect.origin.x, 385, queryViewRect.size.width, queryViewRect.size.height);
	}
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [self.currentTextField resignFirstResponder];
}

- (void)setDate:(NSString *)date
{
    self.currentTextField.text = date;
    [self.currentTextField resignFirstResponder];
    [self.permitListPopover dismissPopoverAnimated:YES];
    
    if (self.currentTextField == self.textDateStart) {
        self.textDateStart.text = self.currentTextField.text;
    }else if (self.currentTextField == self.textDateEnd){
        self.textDateEnd.text = self.currentTextField.text;
    }
}

#pragma mark - UITableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	if(tableView == _organizationTreeTableView){
		return orgTreeViewNodes.count;
	}
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 37;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(tableView == _organizationTreeTableView){
		static NSString *CellIdentifier = @"treeNodeCell";
		UINib *nib = [UINib nibWithNibName:@"CollapseCell" bundle:nil];
		[tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
		
		CollapseCell *cell = (CollapseCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		
		TreeViewNode *node = [orgTreeViewNodes objectAtIndex:indexPath.row];
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

    static NSString * CellIdentifier = @"Cell";
    RoadEngrossMainCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[RoadEngrossMainCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
	cell.labelNumber.text = [NSString stringWithFormat:@"%d", indexPath.row + 1];
    [cell configureCellWithCaseArray:[_dataArray objectAtIndex:indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	if(tableView == _organizationTreeTableView) return 0;
    return 37;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	if(tableView == _organizationTreeTableView) return tableView.tableHeaderView;
    RoadEngrossMainCell * view = [[RoadEngrossMainCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    view.contentView.backgroundColor = [UIColor lightGrayColor];
    [view titleLabel];
    return view.contentView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	if(tableView == _organizationTreeTableView){
		TreeViewNode *tree = (TreeViewNode*)[orgTreeViewNodes objectAtIndex:[indexPath row]];
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
		orgCell = (CollapseCell*)[tableView cellForRowAtIndexPath:indexPath];
		orgCell.backgroundColor = UIColorFromRGB(0xE0F8D8);
		[self buttonQuery:nil];
		return;
		
	}

    
    RoadEngrossInfoViewController * roadEngrossInfoVC= [RoadEngrossInfoViewController newInstance];
    
    roadEngrossInfoVC.roadModel =[_dataArray objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:roadEngrossInfoVC animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}



//This function is used to fill the array that is actually displayed on the table view
- (void)fillDisplayArray
{
    orgTreeViewNodes = [[NSMutableArray alloc]init];
    for (TreeViewNode *node in ORG_TREE) {
        [orgTreeViewNodes addObject:node];
        if ([node.nodeChildren count] > 0 && node.isExpanded == YES) {
            [self fillNodeWithChildrenArray:node.nodeChildren];
        }
    }
}

//This function is used to add the children of the expanded node to the display array
- (void)fillNodeWithChildrenArray:(NSArray *)childrenArray
{
    for (TreeViewNode *node in childrenArray) {
        [orgTreeViewNodes addObject:node];
        if ([node.nodeChildren count] > 0 && node.isExpanded == YES) {
            [self fillNodeWithChildrenArray:node.nodeChildren];
        }
    }
}





- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(tableView == _organizationTreeTableView){
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
	
	if(tableView == _organizationTreeTableView){
		UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
		
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


- (void)expandCollapseNode
{
    [self fillDisplayArray];
    [_organizationTreeTableView reloadData];
}
-(void)setRoadIdDelegate:(NSString *)name withNumber:(NSString *)number{
	self.textRoadId.text = name;
	roadId = number;
}

- (IBAction)roadId:(UITextField *)sender
{
    __block RoadPickerViewController * roadPicker = nil;
    if ((self.touchTextTag == sender.tag) && ([self.permitListPopover isPopoverVisible])) {
        [self.permitListPopover dismissPopoverAnimated:YES];
    } else {
		
		if(roadList == nil || [roadList count] <= 0){
			[[[DataModelCenter defaultCenter] webService] getSupervisionRoadList:^(NSMutableArray *list, NSError *err) {
				dispatch_sync(dispatch_get_main_queue(), ^{
					roadList = list;
					[roadList insertObject:@"" atIndex:0];
					self.touchTextTag=sender.tag;
					roadPicker = [[RoadPickerViewController alloc] init];
					roadPicker.delegate = self;
					self.permitListPopover=[[UIPopoverController alloc] initWithContentViewController:roadPicker];
					[self.permitListPopover setPopoverContentSize:CGSizeMake(200, 200)];
					[roadPicker.tableView setFrame:CGRectMake(0, 0, 200, 200)];
					[self.permitListPopover presentPopoverFromRect:sender.frame inView:self.queryView permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
					roadPicker.pickerPopover=self.permitListPopover;
				});
			}];
		}else{
			self.touchTextTag=sender.tag;
			roadPicker = [[RoadPickerViewController alloc] init];
			roadPicker.delegate = self;
			self.permitListPopover=[[UIPopoverController alloc] initWithContentViewController:roadPicker];
			[self.permitListPopover setPopoverContentSize:CGSizeMake(200, 200)];
			[roadPicker.tableView setFrame:CGRectMake(0, 0, 200, 200)];
			[self.permitListPopover presentPopoverFromRect:sender.frame inView:self.queryView permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
			roadPicker.pickerPopover=self.permitListPopover;
		}
		

    }
}
- (IBAction)dealWith:(UITextField *)sender{
    CasePermitPickerViewController * casePicker = nil;
    if ((self.touchTextTag == sender.tag) && ([self.permitListPopover isPopoverVisible])) {
        [self.permitListPopover dismissPopoverAnimated:YES];
    } else {
        self.touchTextTag=sender.tag;
        casePicker = [[CasePermitPickerViewController alloc] init];
        casePicker.delegate = self;
        casePicker.pickerType =2;
        self.permitListPopover=[[UIPopoverController alloc] initWithContentViewController:casePicker];
        [self.permitListPopover setPopoverContentSize:CGSizeMake(200, 200)];
        [casePicker.tableView setFrame:CGRectMake(0, 0, 200, 200)];
        [self.permitListPopover presentPopoverFromRect:sender.frame inView:self.queryView permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
        casePicker.pickerPopover=self.permitListPopover;
    }
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
	if(textField == self.textRoadId || textField == self.textDateStart || textField == self.textDateEnd|| textField == self.textDeal_with){
		return NO;
	}
	return YES;
}
-(void)setDealWithDelegate:(NSString *)dealWithType withNumber:(NSString *)number{
		self.textDeal_with.text = dealWithType;
		dealWith = number;
}


@end
