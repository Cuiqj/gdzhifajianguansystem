 //
//  CaseMainViewController.m
//  GDZhiFaJianGuanSystem
//
//  Created by XU SHIWEN on 14-2-7.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import "CaseMainViewController.h"
#import "CaseViewController.h"
#import "CaseMainCell.h"
#import "DateSelectController.h"
#import "DataModelCenter.h"
#import "AllCaseModel.h"
#import "CasePermitPickerViewController.h"
#import "EmployeeInfoModel.h"
#import "AppUtil.h"


#define SCROLLVIEW_WIDTH 1450.0

@interface CaseMainViewController ()<UIPopoverControllerDelegate,DatetimePickerHandler,OrgPickerDelegate>
{
    NSInteger pickerType;
	NSMutableArray *orgTreeViewNodes;
	//被选中的机构
	CollapseCell *orgCell;
    
}
@property (nonatomic, retain) UIPopoverController * permitListPopover;
@property (nonatomic,assign) NSInteger touchTextTag;
@property (nonatomic, retain) DateSelectController * popoverContent;
@property (nonatomic, assign) NSInteger buttonIndex; // 查询button
@property (nonatomic, assign) UITextField * currentTextField;
@property (nonatomic, retain) NSMutableArray * dataArray;
@property (nonatomic, weak) NSMutableArray * orgDataArray;
@property (nonatomic, strong) DataModelCenter * dataModelCenter;
@property (nonatomic, strong) NSMutableArray * childOrgArray;//机构第一层数组
@property (nonatomic, strong) NSString * caseType;//案件类型
@property (nonatomic, strong) NSString * orgID;
@property (nonatomic, copy) NSString *employeeId;
@property (nonatomic, retain) NSMutableArray * allOrgID;//全部机构ID
@property (nonatomic, retain) NSNumber  *allPageNumeber;//总页数
@end

@implementation CaseMainViewController

+ (instancetype)newInstance
{
    return [[[self alloc] initWithNibName:@"CaseMainView" bundle:nil] prepareForUse];
}

- (id)prepareForUse
{
    //在这里完成一些内部参数的初始化
     self.dataModelCenter=[DataModelCenter defaultCenter];
    _dataArray=[[NSMutableArray alloc]init];
    self.childOrgArray=[[NSMutableArray alloc] init];
    self.allOrgID = [[NSMutableArray alloc] init];
    [self obtainWithAllOrgID];
    self.caseType = @"";
    self.employeeId = @"";
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    NSLog(@"%@",self.statisticModel);
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([self.permitListPopover isPopoverVisible]) {
        [self.permitListPopover dismissPopoverAnimated:NO];
    }
}

- (void)viewDidLoad
{
	[[[DataModelCenter defaultCenter] webService].queue cancelAllOperations];
    [super viewDidLoad];
    


	_textParties.delegate = self;
	_textNumber.delegate = self;
    [self setTitle:@"案件查询"];
	UIBarButtonItem * backbutton =[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(backButton)];
    [self.navigationItem setLeftBarButtonItem:backbutton animated:YES];
    _tableCaseList =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCROLLVIEW_WIDTH, 633) style:UITableViewStylePlain];
    [_tableCaseList setDataSource:self];
    [_tableCaseList setDelegate:self];
    [_scrollView addSubview:_tableCaseList];
    [self.scrollView setFrame:CGRectMake(12, 350, 1000, 335)];
    _scrollView.contentMode=UIViewContentModeLeft;
    _scrollView.bounces=NO;
    _scrollView.contentSize=CGSizeMake(SCROLLVIEW_WIDTH, 335);
    _scrollView.contentInset=UIEdgeInsetsZero;
    
    // 设置textField代理
    self.textStartingTime.delegate = self;
    self.textEndTime.delegate = self;
    self.textOrg.delegate =self;
    self.textCaseType.delegate =self;
    self.textStartingTime.inputView = [[UIView alloc] init];
    self.textEndTime.inputView = [[UIView alloc] init];
    self.textOrg.inputView = [[UIView alloc] init];
    self.textCaseType.inputView = [[UIView alloc] init];

	
    self.permitListPopover=[[UIPopoverController alloc] initWithContentViewController:[[UIViewController alloc] init]];
    
	
	if (self.orgID==nil)
    {
        self.orgID = [[NSUserDefaults standardUserDefaults] objectForKey:ORGKEY];
    }
	_organizationTreeTableView.delegate = self;
	_organizationTreeTableView.dataSource = self;
	if (ORG_TREE == nil ||[ORG_TREE count]==0) {
		

		[[[DataModelCenter defaultCenter] webService] getSupervisionLowerOrgList:@"" withAsyncHanlder:^(NSArray *orgList, NSError *err) {
			dispatch_sync(dispatch_get_main_queue(), ^{
				if (err == nil) {
					if (ORG_TREE == nil ||[ORG_TREE count]==0) {
						[AppUtil getTreeViewNode:orgList];
					}
					[self fillDisplayArray];
					[_organizationTreeTableView reloadData];
				
				}
			 });
		}];

	}else{
		[self fillDisplayArray];
		[_organizationTreeTableView reloadData];
	}
	
	

	if (!self.statisticModel && !self.employeeModel) {
		[self buttonQuery:nil];
	}
	else if (self.statisticModel) {
		[self searchFromStatistic];
	}
	else if (self.employeeModel){
		
		[self searchFromEmployee];
		self.textOrg.enabled = NO;

	}

}

#pragma mark - method

// 从巡查统计里获得搜索条件
- (void)searchFromStatistic{
    //        [_dataArray removeAllObjects];
    //        [_tableCaseList reloadData];
    self.orgID = [self statisticModel].orgid;
    if ([self.statisticModel.typenames isEqualToString:@"行政处罚案件"]) {
        self.caseType =@"120";
    }else if ([self.statisticModel.typenames isEqualToString:@"赔补偿案件"])
    {
        self.caseType =@"130";
    }else if ([self.statisticModel.typenames isEqualToString:@"强制措施案件"])
    {
        self.caseType =@"140";
    }
    NSString *startTime =[NSString stringWithFormat:@"%@01",[self.statisticModel.dateTime substringToIndex:8]];
    
    NSString *endTime =[NSString stringWithFormat:@"%@30",[self.statisticModel.dateTime substringToIndex:8]];


	NSDictionary * dicTest = @{@"processId": self.caseType ,@"orgId":self.statisticModel.orgid,@"dateStart":startTime,@"dateEnd":endTime,@"pageNum":@"1",@"isContainLowerOrg":@"1",@"employeeId":@"",@"codeNo":@"",@"citizenName":@""};
    [[self.dataModelCenter webService] getSupervisionAllCaseList:dicTest withAsyncHanlder:^(NSArray *caseList, NSError *err) {
		dispatch_sync(dispatch_get_main_queue(), ^{
			if (caseList.count==0) {
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有符合条件数据" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
				[alert show];
            
			}
			[_dataArray removeAllObjects];
			[_dataArray addObjectsFromArray:caseList];
			[_tableCaseList reloadData];
		});
    }];
    self.lebelPageNumber.text = @"1";
    NSDictionary * pageDic = @{@"processId": self.caseType ,@"orgId":self.statisticModel.orgid,@"dateStart":startTime,@"dateEnd":endTime,@"isContainLowerOrg":@"1",@"employeeId":@"",@"number":@"",@"partiesConcerned":@""};
    [[self.dataModelCenter webService] getSupervisionAllCaseListSize:pageDic withAsyncHanlder:^(int listSize, NSError *err) {
         dispatch_sync(dispatch_get_main_queue(), ^{
			 NSInteger page = ceil(listSize/10.0f);
			 self.allPageNumeber = [NSNumber numberWithInteger:0==page?1:page];
			 self.labelTotalNumber.text = [NSString stringWithFormat:@"%d",listSize];
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
    for (OrgInfoSimpleModel * orgInfo in fetchedObjects) {
        
        [self.allOrgID addObject:orgInfo];
    }
}
- (void)searchFromEmployee{
    self.orgID = [self employeeModel].organization_id;
    self.employeeId = [self employeeModel].identifier;
	[self setTitle:[NSString stringWithFormat:@"%@参与过的案件询",[self employeeModel].name]];
	if(self.allOrgID == nil || [self.allOrgID count] <= 0){
		[self obtainWithAllOrgID];
	}
	for (OrgInfoSimpleModel * orgInfo in self.allOrgID) {
        if ([orgInfo.identifier isEqualToString:self.orgID]) {
            NSString * custodyOrgName =orgInfo.orgName;
            self.textOrg.text = custodyOrgName;
        }
    }
	
    NSString *startTime = KILL_NIL_STRING([self textStartingTime].text);
    NSString *endTime = KILL_NIL_STRING([self textEndTime].text);
    NSString * number =self.textNumber.text;//暂时不用上传
	NSString * partiesConcerned =self.textParties.text;//暂时不用上传
    NSDictionary * dicTest = @{@"processId": self.caseType ,@"orgId":self.orgID,@"dateStart":startTime,@"dateEnd":endTime,@"pageNum":@"1",@"isContainLowerOrg":@"1",@"employeeId":[self employeeModel].identifier,@"codeNo":KILL_NIL_STRING(number),@"citizenName":KILL_NIL_STRING(partiesConcerned)};
    [[self.dataModelCenter webService] getSupervisionAllCaseList:dicTest withAsyncHanlder:^(NSArray *caseList, NSError *err) {
		dispatch_sync(dispatch_get_main_queue(), ^{
			if (caseList.count==0) {
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有符合条件数据" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
				[alert show];
            
			}
			[_dataArray removeAllObjects];
			[_dataArray addObjectsFromArray:caseList];
			[_tableCaseList reloadData];
		});
    }];
    self.lebelPageNumber.text = @"1";
    NSDictionary * pageDic = @{@"processId": self.caseType ,@"orgId":self.orgID,@"dateStart":startTime,@"dateEnd":endTime,@"isContainLowerOrg":@"1",@"employeeId":[self employeeModel].identifier,@"number":KILL_NIL_STRING(number),@"partiesConcerned":KILL_NIL_STRING(partiesConcerned)};
    [[self.dataModelCenter webService] getSupervisionAllCaseListSize:pageDic withAsyncHanlder:^(int listSize, NSError *err) {
        dispatch_sync(dispatch_get_main_queue(), ^{
			NSInteger page = ceil(listSize/10.0f);
			self.allPageNumeber = [NSNumber numberWithInteger:0==page?1:page];
			self.labelTotalNumber.text = [NSString stringWithFormat:@"%d",listSize];
		});
    }];
}


#pragma mark - IBActions

- (void)backButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)bthPreviousPage:(UIButton *)sender
{
    if ([self.lebelPageNumber.text intValue] == 1) {
        return;
    }
    if (![_lebelPageNumber.text  isEqual: @"1"]) {
        _lebelPageNumber.text = [NSString stringWithFormat:@"%d",_lebelPageNumber.text.intValue - 1] ;
        NSString * pageNumber = _lebelPageNumber.text;
        NSString * startTime = KILL_NIL_STRING(_textStartingTime.text);
        NSString * endTime = KILL_NIL_STRING(_textEndTime.text);
		NSString * number =self.textNumber.text;//暂时不用上传
		NSString * partiesConcerned =self.textParties.text;//暂时不用上传
		NSDictionary * dicTest = @{@"processId": self.caseType ,@"orgId":self.orgID,@"dateStart":startTime,@"dateEnd":endTime,@"pageNum":pageNumber,@"isContainLowerOrg":@"1",@"employeeId":self.employeeId,@"codeNo":KILL_NIL_STRING(number),@"citizenName":KILL_NIL_STRING(partiesConcerned)};
        [[self.dataModelCenter webService] getSupervisionAllCaseList:dicTest withAsyncHanlder:^(NSArray *caseList, NSError *err) {
			dispatch_sync(dispatch_get_main_queue(), ^{
				if (caseList.count==0) {
					UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有符合条件数据" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
					[alert show];
				}
				[_dataArray removeAllObjects];
				[_dataArray addObjectsFromArray:caseList];
				[_tableCaseList reloadData];
			});
        }];
    }
}

- (IBAction)bthNextPage:(UIButton *)sender
{
    if ([_allPageNumeber integerValue] == [self.lebelPageNumber.text intValue]) {
        return;
    }
    _lebelPageNumber.text = [NSString stringWithFormat:@"%d",_lebelPageNumber.text.intValue + 1] ;
    NSString * pageNumber = _lebelPageNumber.text;
    NSString * startTime = KILL_NIL_STRING(_textStartingTime.text);
    NSString * endTime = KILL_NIL_STRING(_textEndTime.text);
	NSString * number =self.textNumber.text;//暂时不用上传
	NSString * partiesConcerned =self.textParties.text;//暂时不用上传
	NSDictionary * dicTest = @{@"processId": self.caseType ,@"orgId":self.orgID,@"dateStart":startTime,@"dateEnd":endTime,@"pageNum":pageNumber,@"isContainLowerOrg":@"1",@"employeeId":self.employeeId,@"codeNo":KILL_NIL_STRING(number),@"citizenName":KILL_NIL_STRING(partiesConcerned)};
    [[self.dataModelCenter webService] getSupervisionAllCaseList:dicTest withAsyncHanlder:^(NSArray *caseList, NSError *err) {
		dispatch_sync(dispatch_get_main_queue(), ^{
			if (caseList.count==0) {
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有符合条件数据" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
				[alert show];
				
			}
			[_dataArray removeAllObjects];
			[_dataArray addObjectsFromArray:caseList];
			[_tableCaseList reloadData];
		});
        
    }];
}

- (IBAction)bthEndPage:(UIButton *)sender
{
    if ([self.lebelPageNumber.text intValue] == [self.allPageNumeber intValue]) {
        return;
    }

    _lebelPageNumber.text = [self.allPageNumeber stringValue];
    NSString * pageNumber = self.lebelPageNumber.text;
//    NSString * pageNumber = _allPageNumeber.stringValue;
    NSString * startTime = KILL_NIL_STRING(_textStartingTime.text);
    NSString * endTime = KILL_NIL_STRING(_textEndTime.text);
	NSString * number =self.textNumber.text;//暂时不用上传
	NSString * partiesConcerned =self.textParties.text;//暂时不用上传
	NSDictionary * dicTest = @{@"processId": self.caseType ,@"orgId":self.orgID,@"dateStart":startTime,@"dateEnd":endTime,@"pageNum":pageNumber,@"isContainLowerOrg":@"1",@"employeeId":self.employeeId,@"codeNo":KILL_NIL_STRING(number),@"citizenName":KILL_NIL_STRING(partiesConcerned)};
    [[self.dataModelCenter webService] getSupervisionAllCaseList:dicTest withAsyncHanlder:^(NSArray *caseList, NSError *err) {
		dispatch_sync(dispatch_get_main_queue(), ^{
			if (caseList.count==0) {
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有符合条件数据" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
				[alert show];
				
			}
			[_dataArray removeAllObjects];
			[_dataArray addObjectsFromArray:caseList];
			[_tableCaseList reloadData];
		});
        
    }];
}

- (IBAction)queryTextClicked:(UIButton *)sender {
    self.buttonIndex = sender.tag - 1000;
    self.popoverContent.pickerType = self.buttonIndex;
    
    self.yearQueryBth.enabled = YES;
    self.monthQueryBth.enabled = YES;
    self.dayQueryBth.enabled = YES;
    
    self.yearQueryBth.backgroundColor = [UIColor lightGrayColor];
    self.monthQueryBth.backgroundColor = [UIColor lightGrayColor];
    self.dayQueryBth.backgroundColor = [UIColor lightGrayColor];
    sender.enabled = NO;
    sender.backgroundColor = [UIColor darkGrayColor];
}

- (IBAction)startingTime:(UITextField *)sender {
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



- (IBAction)caseType:(UITextField *)sender
{
    CasePermitPickerViewController * casePicker = nil;
    if ((self.touchTextTag == sender.tag) && ([self.permitListPopover isPopoverVisible])) {
        [self.permitListPopover dismissPopoverAnimated:YES];
    } else {
        self.touchTextTag=sender.tag;
        casePicker = [[CasePermitPickerViewController alloc] init];
        casePicker.delegate = self;
        casePicker.pickerType =0;
        self.permitListPopover=[[UIPopoverController alloc] initWithContentViewController:casePicker];
        [self.permitListPopover setPopoverContentSize:CGSizeMake(200, 200)];
        [casePicker.tableView setFrame:CGRectMake(0, 0, 200, 200)];
        [self.permitListPopover presentPopoverFromRect:sender.frame inView:self.queryView permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
        casePicker.pickerPopover=self.permitListPopover;
    }
}



-(void)setOrgID:(NSString *)identifier withOrgName:(NSString *)orgName{
    self.textOrg.text = orgName;
    self.orgID=identifier;
}

- (IBAction)buttonQuery:(id)sender
{
    self.lebelPageNumber.text =@"1";
    
    NSString * number =self.textNumber.text;//暂时不用上传
    NSString *startTime = KILL_NIL_STRING(self.textStartingTime.text);
    NSString *endTime = KILL_NIL_STRING(self.textEndTime.text);
    NSString * partiesConcerned =self.textParties.text;//暂时不用上传
    if (!self.caseType)
    {
        self.caseType=@"";
    }
	if (!number)
    {
        number=@"";
    }
	if (!partiesConcerned)
    {
        partiesConcerned=@"";
    }
    if (!self.orgID)
    {
        self.orgID=@"";
//        self.orgID = [[NSUserDefaults standardUserDefaults] objectForKey:ORGKEY];
    }
    

	NSDictionary * dicTest = @{@"processId": self.caseType ,@"orgId":self.orgID,@"dateStart":startTime,@"dateEnd":endTime,@"pageNum":self.lebelPageNumber.text,@"isContainLowerOrg":@"1",@"employeeId":self.employeeId,@"codeNo":KILL_NIL_STRING(number),@"citizenName":KILL_NIL_STRING(partiesConcerned)};
    [[self.dataModelCenter webService] getSupervisionAllCaseList:dicTest withAsyncHanlder:^(NSArray *caseList, NSError *err) {
		dispatch_sync(dispatch_get_main_queue(), ^{
			if (caseList.count==0) {
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有符合条件数据" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
				[alert show];
				
			}
			[_dataArray removeAllObjects];
			[_dataArray addObjectsFromArray:caseList];
			[_tableCaseList reloadData];
		});
    }];
    
    NSDictionary * pageDic = @{@"processId": self.caseType ,@"orgId":self.orgID,@"dateStart":startTime,@"dateEnd":endTime,@"isContainLowerOrg":@"1",@"employeeId":self.employeeId,@"number":KILL_NIL_STRING(number),@"partiesConcerned":KILL_NIL_STRING(partiesConcerned)};
    [[self.dataModelCenter webService] getSupervisionAllCaseListSize:pageDic withAsyncHanlder:^(int listSize, NSError *err) {
		dispatch_sync(dispatch_get_main_queue(), ^{
			NSInteger page = ceil(listSize/10.0f);
			self.allPageNumeber = [NSNumber numberWithInteger:0==page?1:page];
			self.labelTotalNumber.text = [NSString stringWithFormat:@"%d",listSize];
		});
    }];
}

#pragma mark - UITextFieldDelegateMethod
- (void)textFieldDidBeginEditing:(UITextField *)textField
{

    self.currentTextField = textField;
	CGRect queryViewRect = _queryView.frame;
	if(textField == _textNumber || textField == _textParties){
		_queryView.frame = CGRectMake(queryViewRect.origin.x, queryViewRect.origin.y-210, queryViewRect.size.width, queryViewRect.size.height);
	}
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
	CGRect queryViewRect = _queryView.frame;
	if(textField == _textNumber || textField == _textParties){
		_queryView.frame = CGRectMake(queryViewRect.origin.x, 429, queryViewRect.size.width, queryViewRect.size.height);
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
    
    if (self.currentTextField == self.textStartingTime) {
        self.textStartingTime.text = self.currentTextField.text;
    }else if (self.currentTextField == self.textEndTime){
        self.textEndTime.text = self.currentTextField.text;
    }
}

-(void)setCaseTypeDelegate:(NSString *)caseType withNumber:(NSString *)number//self.textcaseType赋值
{
    self.textCaseType.text = caseType;
    self.caseType = number;
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
    CaseMainCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[CaseMainCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    for (OrgInfoSimpleModel * orgInfo in self.allOrgID) {
        if ([orgInfo.identifier isEqualToString:[[_dataArray objectAtIndex:indexPath.row] org_id]]) {
            NSString * custodyOrgName =orgInfo.orgName;
            cell.labelOrg.text = custodyOrgName;
        }
    }
    [cell configureCellWithAllCaseArray:[_dataArray objectAtIndex:indexPath.row]];
    cell.labelNumber.text = [NSString stringWithFormat:@"%d", indexPath.row + 1];
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
    CaseMainCell * view = [[CaseMainCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    view.contentView.backgroundColor = [UIColor lightGrayColor];
    [view titleLabel];
    return view.contentView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	[_textNumber resignFirstResponder];
	[_textParties resignFirstResponder];
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
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CaseViewController * caseView = [[CaseViewController alloc] init];
    AllCaseModel * caseInfoModel = [_dataArray objectAtIndex:indexPath.row];
    caseView.caseInfoModel = caseInfoModel;
    [self.navigationController pushViewController:caseView animated:YES];
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

@end
