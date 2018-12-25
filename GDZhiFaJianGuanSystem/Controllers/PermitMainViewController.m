//
//  PermitMainViewController.m
//  GDZhiFaJianGuanSystem
//
//  Created by XU SHIWEN on 14-2-7.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import "PermitMainViewController.h"
#import "PermitInfoViewController.h"
#import "DateSelectController.h"
#import "DataModelCenter.h"
#import "PermitMainCell.h"
#import "CasePermitPickerViewController.h"
#import "AppUtil.h"



#define SCROLLVIEW_WIDTH 1320.0

@interface PermitMainViewController ()<UIPopoverControllerDelegate, DatetimePickerHandler>
{
    NSInteger pickerType;
	NSMutableArray *orgTreeViewNodes;
	//被选中的机构
	CollapseCell *orgCell;

}

@property (nonatomic, retain) UIPopoverController * permitListPopover;//组织的
@property (nonatomic, retain) DateSelectController * popoverContent;
@property (nonatomic, assign) NSInteger buttonIndex; // 查询button
@property (nonatomic, assign) UITextField * currentTextField;
@property (nonatomic, assign) NSInteger touchTextTag;
@property (nonatomic, retain) NSMutableArray * permitArray;
@property (nonatomic, strong) DataModelCenter * dataModelCenter;
@property (nonatomic, strong) NSMutableArray * childOrgArray;//机构第一层数组
@property (nonatomic, strong) NSString * permitType;//许可类型
@property (nonatomic, strong) NSString * orgID;
@property (nonatomic, copy) NSString *employeeId;
@property (nonatomic, retain) NSNumber * allPageNumeber;//总页数

@end

@implementation PermitMainViewController

+ (instancetype)newInstance
{
    return [[[self alloc] initWithNibName:@"PermitMainView" bundle:nil] prepareForUse];
}

- (id)prepareForUse
{
    //在这里完成一些内部参数的初始化
    self.dataModelCenter=[DataModelCenter defaultCenter];
    self.permitArray=[[NSMutableArray alloc]init];
    self.childOrgArray=[[NSMutableArray alloc] init];
	self.allOrgID = [[NSMutableArray alloc] init];
    self.permitType = @"";
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

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    self.queryView.hidden = YES;
    if ([self.permitListPopover isPopoverVisible]) {
        [self.permitListPopover dismissPopoverAnimated:NO];
    }
}

- (void)viewDidLoad
{
	[[[DataModelCenter defaultCenter] webService].queue cancelAllOperations];
    [super viewDidLoad];
	
	_textNumber.delegate = self;
	_textItemsApplication.delegate = self;
	// Do any additional setup after loading the view.
    [self setTitle:@"许可查询"];
	UIBarButtonItem * backbutton =[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(backButton)];
    [self.navigationItem setLeftBarButtonItem:backbutton animated:YES];
    
    _tableCaseList =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCROLLVIEW_WIDTH, 633) style:UITableViewStylePlain];
    [_tableCaseList setDataSource:self];
    [_tableCaseList setDelegate:self];
    [_scrollView addSubview:_tableCaseList];
    [self.scrollView setFrame:CGRectMake(12, 350, 1000, 342)];
    _scrollView.contentMode=UIViewContentModeLeft;
    _scrollView.bounces=NO;
    _scrollView.contentSize=CGSizeMake(SCROLLVIEW_WIDTH, 342);
    _scrollView.contentInset=UIEdgeInsetsZero;
    

    
    // 设置textField代理
    self.textStartTime.delegate = self;
    self.textEndTime.delegate = self;
    self.textOrg.delegate = self;
    self.textPermitType.delegate = self;
    self.textPermitType.inputView = [[UIView alloc] init];
    self.textStartTime.inputView = [[UIView alloc] init];
    self.textEndTime.inputView = [[UIView alloc] init];
    self.textOrg.inputView =[[UIView alloc] init];

    
	
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
	
	
    self.permitListPopover=[[UIPopoverController alloc] initWithContentViewController:[[UIViewController alloc] init]];
	if (!self.statisticModel && !self.employeeModel){
		
		[self buttonQuery:nil];
		[self queryButtonClicked:self.yearQueryButton];
	}
	else if (self.statisticModel){
		[self searchFromStatistic];
	}
	else if (self.employeeModel){
		[self searchFromEmployee];
	}
    
}

#pragma mark - method

// 从巡查统计里获得搜索条件
- (void)searchFromStatistic{
    self.orgID = [self statisticModel].orgid;
    if ([self.statisticModel.typenames isEqualToString:@"超限运输许可审批"]) {
        self.permitType =@"101";
    }else if ([self.statisticModel.typenames isEqualToString:@"非公路标志许可审批"])
    {
        self.permitType =@"102";
    }else if ([self.statisticModel.typenames isEqualToString:@"占用、挖掘公路的许可审批"])
    {
        self.permitType =@"103";
    }else if ([self.statisticModel.typenames isEqualToString:@"跨越、穿越公路的许可审批"])
    {
        self.permitType =@"104";
    }else if ([self.statisticModel.typenames isEqualToString:@"埋架管线、电缆的许可审批"])
    {
        self.permitType =@"105";
    }else if ([self.statisticModel.typenames isEqualToString:@"有害机车上公路的许可审批"])
    {
        self.permitType =@"106";
    }else if ([self.statisticModel.typenames isEqualToString:@"设置交叉道口的许可审批"])
    {
        self.permitType =@"107";
    }else if ([self.statisticModel.typenames isEqualToString:@"建设工程需要使公路改线的许可"])
    {
        self.permitType =@"108";
    }else if ([self.statisticModel.typenames isEqualToString:@"砍伐修剪树木的许可审批"])
    {
        self.permitType =@"109";
    }else if ([self.statisticModel.typenames isEqualToString:@"在公路两侧埋土提高原地面标高的许可"])
    {
        self.permitType =@"110";
    }
    
    NSString *startTime = nil;
    
    NSString *endTime = nil;
    
    if ([KILL_NIL_STRING(self.statisticModel.dateTime) isEqualToString:@""]) {
        startTime = @"";
        endTime = @"";
    }else
    {
        startTime = [NSString stringWithFormat:@"%@01",[self.statisticModel.dateTime substringToIndex:8]];
        endTime = [NSString stringWithFormat:@"%@30",[self.statisticModel.dateTime substringToIndex:8]];
    }
    
    
    NSDictionary * dicTest = @{@"processId": self.permitType,@"orgId":KILL_NIL_STRING(self.statisticModel.orgid),@"dateStart":startTime,@"dateEnd":endTime,@"pageNum":@"1",@"isContainLowerOrg":@"1",@"employeeId":@"",@"number":@"",@"partiesConcerned":@""};
    
    NSDictionary * pageDic = @{@"processId": self.permitType,@"orgId":KILL_NIL_STRING(self.statisticModel.orgid),@"dateStart":startTime,@"dateEnd":endTime,@"number":@"",@"partiesConcerned":@""};
    
    [self searchWithParameters:dicTest sizeParameters:pageDic];
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
    [self setTitle:[NSString stringWithFormat:@"%@参与过的许可",[self employeeModel].name]];
	
	if(self.allOrgID == nil || [self.allOrgID count] <= 0){
		[self obtainWithAllOrgID];
	}
	for (OrgInfoSimpleModel * orgInfo in self.allOrgID) {
        if ([orgInfo.identifier isEqualToString:self.orgID]) {
            NSString * custodyOrgName =orgInfo.orgName;
            self.textOrg.text = custodyOrgName;
        }
    }
	
	
    NSString *startTime = KILL_NIL_STRING([self textStartTime].text);
    NSString *endTime = KILL_NIL_STRING([self textEndTime].text);
	NSString * partiesConcerned =self.textItemsApplication.text;//暂时不用上传
	NSString * number =self.textNumber.text;//暂时不用上传
    NSDictionary * dicTest = @{@"processId": self.permitType,@"orgId":KILL_NIL_STRING(self.orgID),@"dateStart":startTime,@"dateEnd":endTime,@"pageNum":@"1",@"isContainLowerOrg":@"1",@"employeeId":KILL_NIL_STRING(self.employeeId),@"number":KILL_NIL_STRING(number),@"partiesConcerned":KILL_NIL_STRING(partiesConcerned)};
    
    NSDictionary * pageDic = @{@"processId": self.permitType,@"orgId":KILL_NIL_STRING(self.orgID),@"dateStart":startTime,@"dateEnd":endTime,@"employeeId":KILL_NIL_STRING(self.employeeId) ,@"number":KILL_NIL_STRING(number),@"partiesConcerned":KILL_NIL_STRING(partiesConcerned)};
    
    [self searchWithParameters:dicTest sizeParameters:pageDic];
}

- (void)searchWithParameters:(NSDictionary *)params sizeParameters:(NSDictionary *)sizeParams{
	[[DataModelCenter defaultCenter].webService getSupervisionAllPermitList:params withAsyncHanlder:^(NSArray *permitList, NSError *err) {
		dispatch_sync(dispatch_get_main_queue(), ^{
			if (permitList.count==0) {
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有符合条件数据" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
				[alert show];
				
			}
			[self.permitArray removeAllObjects];
			[self.permitArray addObjectsFromArray:permitList];
			[_tableCaseList reloadData];
		});
		
	}];
	self.lebelPageNumber.text = @"1";
	
	[[self.dataModelCenter webService] getSupervisionAllPermitListSize:sizeParams withAsyncHanlder:^(int permitList, NSError *err) {
		dispatch_sync(dispatch_get_main_queue(), ^{
				NSInteger page = ceil(permitList/10.0f);
				_allPageNumeber = [NSNumber numberWithInteger:0==page?1:page];
				self.labelTotalNumber.text = [NSString stringWithFormat:@"%d",permitList];
			});
	}];
}

#pragma mark - IBActions

- (void)backButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)Org:(UITextField *)sender
{
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
     [_textOrg resignFirstResponder];
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

- (IBAction)queryOptions:(id)sender
{
    if (self.queryView.hidden) {
        self.queryView.hidden = NO;
        [self.scrollView setFrame:CGRectMake(12, 225, 1000, 419)];
        _scrollView.contentMode=UIViewContentModeLeft;
        _scrollView.bounces=NO;
        _scrollView.contentSize=CGSizeMake(SCROLLVIEW_WIDTH, 419);
        _scrollView.contentInset=UIEdgeInsetsZero;
    } else {
        self.queryView.hidden = YES;
        [self.scrollView setFrame:CGRectMake(12, 60, 1000, 581)];
        _scrollView.contentMode=UIViewContentModeLeft;
        _scrollView.bounces=NO;
        _scrollView.contentSize=CGSizeMake(SCROLLVIEW_WIDTH, 581);
        _scrollView.contentInset=UIEdgeInsetsZero;
    }
}

- (IBAction)permitType:(UITextField *)sender {
    CasePermitPickerViewController * casePicker = nil;
    if ((self.touchTextTag == sender.tag) && ([self.permitListPopover isPopoverVisible])) {
        [self.permitListPopover dismissPopoverAnimated:YES];
    } else {
        self.touchTextTag=sender.tag;
        casePicker = [[CasePermitPickerViewController alloc] init];
        casePicker.delegate = self;
        casePicker.pickerType =1;
        self.permitListPopover=[[UIPopoverController alloc] initWithContentViewController:casePicker];
        [self.permitListPopover setPopoverContentSize:CGSizeMake(300, 240)];
        [casePicker.tableView setFrame:CGRectMake(0, 0, 300, 240)];
        [self.permitListPopover presentPopoverFromRect:sender.frame inView:self.queryView permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        casePicker.pickerPopover=self.permitListPopover;
    }
}

- (IBAction)queryButtonClicked:(UIButton *)sender
{
    self.buttonIndex = sender.tag - 1000;
    pickerType = self.buttonIndex;
    
    self.yearQueryButton.enabled = YES;
    self.monthQueryButton.enabled = YES;
    self.dayQueryButton.enabled = YES;
    self.yearQueryButton.backgroundColor = [UIColor lightGrayColor];
    self.monthQueryButton.backgroundColor = [UIColor lightGrayColor];
    self.dayQueryButton.backgroundColor = [UIColor lightGrayColor];
    sender.enabled = NO;
    sender.backgroundColor = [UIColor darkGrayColor];
}

-(void)setOrgID:(NSString *)identifier withOrgName:(NSString *)orgName{
    self.textOrg.text = orgName;
    self.orgID=identifier;
}

- (IBAction)buttonQuery:(id)sender
{
    
    [self.tableCaseList reloadData];
    
    NSString * number =self.textNumber.text;//暂时不用上传
    NSString * startTime =KILL_NIL_STRING(self.textStartTime.text);
    NSString * endTime = KILL_NIL_STRING(self.textEndTime.text);
    NSString * partiesConcerned =self.textItemsApplication.text;//暂时不用上传
    if (self.orgID==nil)
    {
        self.orgID = [[NSUserDefaults standardUserDefaults] objectForKey:ORGKEY];
    }
    if (self.permitType==nil)
    {
        self.permitType=@"";
    }
    _lebelPageNumber.text =@"1";
    NSDictionary * dicTest = @{@"processId": self.permitType,@"orgId":self.orgID,@"dateStart":startTime,@"dateEnd":endTime,@"pageNum":@"1",@"isContainLowerOrg":@"1",@"employeeId":KILL_NIL_STRING(self.employeeId),@"number":KILL_NIL_STRING(number),@"partiesConcerned":KILL_NIL_STRING(partiesConcerned)};
    [[DataModelCenter defaultCenter].webService getSupervisionAllPermitList:dicTest withAsyncHanlder:^(NSArray *permitList, NSError *err) {
        dispatch_sync(dispatch_get_main_queue(), ^{
			if (permitList.count==0) {
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有符合条件数据" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
				[alert show];
				
			}
			[self.permitArray removeAllObjects];
			[self.permitArray addObjectsFromArray:permitList];
			[_tableCaseList reloadData];
		});
    }];
    NSDictionary * pageDic = @{@"processId": self.permitType,
                               @"orgId":self.orgID,
                               @"dateStart":startTime,
                               @"dateEnd":endTime,
                               @"isContainLowerOrg":@"1",
                               @"employeeId":KILL_NIL_STRING(self.employeeId),@"number":KILL_NIL_STRING(number),@"partiesConcerned":KILL_NIL_STRING(partiesConcerned)};
    [[self.dataModelCenter webService] getSupervisionAllPermitListSize:pageDic withAsyncHanlder:^(int permitList, NSError *err) {
		dispatch_sync(dispatch_get_main_queue(), ^{
			NSInteger page = ceil(permitList/10.0f);
			_allPageNumeber = [NSNumber numberWithInteger:0==page?1:page];
			self.labelTotalNumber.text = [NSString stringWithFormat:@"%d",permitList];
		});
    }];
    
}

- (IBAction)bthPreviousPage:(UIButton *)sender
{
    if ([self.lebelPageNumber.text intValue] == 1) {
        return;
    }
    if (![_lebelPageNumber.text  isEqual: @"1"]) {
        _lebelPageNumber.text = [NSString stringWithFormat:@"%d",_lebelPageNumber.text.intValue - 1] ;
        NSString * pageNumber = _lebelPageNumber.text;
        NSString * startTime =KILL_NIL_STRING(self.textStartTime.text);
        NSString * endTime = KILL_NIL_STRING(self.textEndTime.text);
		NSString * partiesConcerned =self.textItemsApplication.text;//暂时不用上传
		NSString * number =self.textNumber.text;//暂时不用上传
        NSDictionary * dicTest = @{@"processId": self.permitType,@"orgId":self.orgID,@"dateStart":startTime,@"dateEnd":endTime,@"pageNum":pageNumber,@"isContainLowerOrg":@"1",@"employeeId":KILL_NIL_STRING(self.employeeId),@"number":KILL_NIL_STRING(number),@"partiesConcerned":KILL_NIL_STRING(partiesConcerned)};
        [[DataModelCenter defaultCenter].webService getSupervisionAllPermitList:dicTest withAsyncHanlder:^(NSArray *permitList, NSError *err) {
            dispatch_sync(dispatch_get_main_queue(), ^{
				if (permitList.count==0) {
					UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有符合条件数据" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
					[alert show];
					
				}
				[self.permitArray removeAllObjects];
				[self.permitArray addObjectsFromArray:permitList];
				[_tableCaseList reloadData];
			});
        }];
    }

}
- (IBAction)bthNextPage:(UIButton *)sender
{
    if ([_allPageNumeber intValue] == [self.lebelPageNumber.text intValue]) {
        return;
    }
    _lebelPageNumber.text = [NSString stringWithFormat:@"%d",_lebelPageNumber.text.intValue + 1] ;
    NSString * pageNumber = _lebelPageNumber.text;
    NSString * startTime =KILL_NIL_STRING(self.textStartTime.text);
    NSString * endTime = KILL_NIL_STRING(self.textEndTime.text);
	NSString * partiesConcerned =self.textItemsApplication.text;//暂时不用上传
	NSString * number =self.textNumber.text;//暂时不用上传

    NSDictionary * dicTest = @{@"processId": self.permitType,@"orgId":self.orgID,@"dateStart":startTime,@"dateEnd":endTime,@"pageNum":pageNumber,@"isContainLowerOrg":@"1",@"employeeId":KILL_NIL_STRING(self.employeeId) ,@"number":KILL_NIL_STRING(number),@"partiesConcerned":KILL_NIL_STRING(partiesConcerned)};
    [[DataModelCenter defaultCenter].webService getSupervisionAllPermitList:dicTest withAsyncHanlder:^(NSArray *permitList, NSError *err) {
        dispatch_sync(dispatch_get_main_queue(), ^{
			if (permitList.count==0) {
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有符合条件数据" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
				[alert show];
				
			}
			[self.permitArray removeAllObjects];
			[self.permitArray addObjectsFromArray:permitList];
			[_tableCaseList reloadData];
		});
    }];
}
- (IBAction)bthEndPage:(UIButton *)sender
{
    if ([self.lebelPageNumber.text intValue] == [self.allPageNumeber integerValue]) {
        return;
    }
    _lebelPageNumber.text = [self.allPageNumeber stringValue];
    NSString * pageNumber = _lebelPageNumber.text;
    NSString * startTime =KILL_NIL_STRING(self.textStartTime.text);
    NSString * endTime = KILL_NIL_STRING(self.textEndTime.text);
	NSString * partiesConcerned =self.textItemsApplication.text;//暂时不用上传
	NSString * number =self.textNumber.text;//暂时不用上传
    NSDictionary * dicTest = @{@"processId": self.permitType,@"orgId":self.orgID,@"dateStart":startTime,@"dateEnd":endTime,@"pageNum":pageNumber,@"isContainLowerOrg":@"1",@"employeeId":KILL_NIL_STRING(self.employeeId) ,@"number":KILL_NIL_STRING(number),@"partiesConcerned":KILL_NIL_STRING(partiesConcerned)};
    [[DataModelCenter defaultCenter].webService getSupervisionAllPermitList:dicTest withAsyncHanlder:^(NSArray *permitList, NSError *err) {
        dispatch_sync(dispatch_get_main_queue(), ^{
			if (permitList.count==0) {
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有符合条件数据" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
				[alert show];
				
			}
			[self.permitArray removeAllObjects];
			[self.permitArray addObjectsFromArray:permitList];
			[_tableCaseList reloadData];
		});
    }];
}

#pragma mark - UITextFieldDelegateMethod
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    //    [textField resignFirstResponder];
    self.currentTextField = textField;
	CGRect queryViewRect = _queryView.frame;
	if(textField == _textNumber || textField == _textItemsApplication){
		_queryView.frame = CGRectMake(queryViewRect.origin.x, queryViewRect.origin.y-210, queryViewRect.size.width, queryViewRect.size.height);
	}
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
	CGRect queryViewRect = _queryView.frame;
	if(textField == _textNumber || textField == _textItemsApplication){
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
    
    if (self.currentTextField == self.textStartTime) {
        self.textStartTime.text = self.currentTextField.text;
    }else if (self.currentTextField == self.textEndTime){
        self.textEndTime.text = self.currentTextField.text;
    }
}

-(void)setPermitTypeDelegate:(NSString *)permitType withNumber:(NSString *)number//textPermitType赋值
{
    self.textPermitType.text=permitType;
    self.permitType = number;
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
    return [self.permitArray count];
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
    PermitMainCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[PermitMainCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
//    AllPermitModel *model = [self.permitArray objectAtIndex:indexPath.row];
    if (_permitArray != nil) {
        
    }
    cell.labelNumber.text = [NSString stringWithFormat:@"%d", indexPath.row + 1];
    [cell configureCellWithAllPermitArray:[_permitArray objectAtIndex:indexPath.row]];
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
    PermitMainCell * view = [[PermitMainCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    view.contentView.backgroundColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
    [view titleLabel];
    return view.contentView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[_textNumber resignFirstResponder];
	[_textItemsApplication resignFirstResponder];
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PermitInfoViewController * permitInfoView =[[PermitInfoViewController alloc] init];
    AllPermitModel *model = [self.permitArray objectAtIndex:indexPath.row];
    permitInfoView.dicTemp = @{@"permitModel": model};
    [self.navigationController pushViewController:permitInfoView animated:YES];
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
