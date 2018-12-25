//
//  InspectionMainViewController.m
//  GDZhiFaJianGuanSystem
//
//  Created by XU SHIWEN on 14-2-7.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import "InspectionMainViewController.h"
#import "InspectionInfoViewController.h"
#import "InspectionMainCell.h"
#import "DateSelectController.h"
#import "DataModelCenter.h"
#import "EmployeeInfoModel.h"
#import "AppUtil.h"
#import "CollapseCell.h"

@interface InspectionMainViewController ()<UIPopoverControllerDelegate,DatetimePickerHandler,OrgPickerDelegate>
{
    NSInteger pickerType;
	NSMutableArray *orgTreeViewNodes;
	//被选中的机构
	CollapseCell *orgCell;
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

@implementation InspectionMainViewController

+ (instancetype)newInstance
{
    return [[[self alloc] initWithNibName:@"InspectionMainView" bundle:nil] prepareForUse];
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
    [self setTitle:@"巡查信息查询"];
    [_tabelList setDataSource:self];
    [_tabelList setDelegate:self];
    
    self.textStartTime.delegate = self;
    self.textEndTime.delegate = self;
    self.textOrg.delegate =self;
    self.textStartTime.inputView = [[UIView alloc] init];
    self.textEndTime.inputView = [[UIView alloc] init];
    self.textOrg.inputView = [[UIView alloc] init];
	UIBarButtonItem * backbutton =[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(backButton)];
    [self.navigationItem setLeftBarButtonItem:backbutton animated:YES];
    
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
        self.textStartTime.text = startTime;
        self.textEndTime.text = endTime;
    }
    NSDictionary * dicTest = @{@"orgId":self.orgID,@"dateStart":startTime,@"dateEnd":endTime,@"pageNum":@"1",@"inspectionType":KILL_NIL_STRING(self.inspectionType),@"isContainLowerOrg":@"1",@"employeeId":KILL_NIL_STRING(self.employeeId)};
    NSDictionary * pageDic = @{@"orgId":self.orgID,@"dateStart":startTime,@"dateEnd":endTime,@"inspectionType":KILL_NIL_STRING(self.inspectionType),@"isContainLowerOrg":@"1",@"employeeId":KILL_NIL_STRING(self.employeeId)};
    [self searchWithParameters:dicTest sizeParameters:pageDic];
}

- (void)searchFromEmployee{
    self.orgID = [self employeeModel].organization_id;
    self.employeeId = [self employeeModel].identifier;
    [self setTitle:[NSString stringWithFormat:@"%@参与过的巡查",[self employeeModel].name]];
	
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
    
    NSDictionary * dicTest = @{@"orgId":self.orgID,@"dateStart":startTime,@"dateEnd":endTime,@"pageNum":@"1",@"inspectionType":KILL_NIL_STRING(self.inspectionType),@"isContainLowerOrg":@"1",@"employeeId":KILL_NIL_STRING(self.employeeId)};
    NSDictionary * pageDic = @{@"orgId":self.orgID,@"dateStart":startTime,@"dateEnd":endTime,@"inspectionType":KILL_NIL_STRING(self.inspectionType),@"isContainLowerOrg":@"1",@"employeeId":KILL_NIL_STRING(self.employeeId)};
    [self searchWithParameters:dicTest sizeParameters:pageDic];
}

- (void)searchWithParameters:(NSDictionary *)params sizeParameters:(NSDictionary *)sizeParams{

	[[self.dataModelCenter webService]getSupervisionAllInspectionList:params withAsyncHanlder:^(NSArray *inspectionList, NSError *err) {
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
	
	[[self.dataModelCenter webService] getSupervisionAllInspectionListSize:sizeParams withAsyncHanlder:^(int inspectionList, NSError *err) {
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
    [_textOrg resignFirstResponder];
}

- (IBAction)startingTime:(UITextField *)sender {
    [sender resignFirstResponder];
    if ((self.touchTextTag == sender.tag) && ([self.permitListPopover isPopoverVisible])) {
        [self.permitListPopover dismissPopoverAnimated:YES];
    } else {
		self.currentTextField = self.textStartTime;
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
		self.currentTextField = self.textEndTime;
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
    self.textOrg.text = orgName;
    self.orgID=identifier;
}

- (IBAction)buttonQuery:(id)sender
{

    self.labelPageNumber.text =@"1";
    
    NSString * startTime = KILL_NIL_STRING(self.textStartTime.text);
    NSString * endTime = KILL_NIL_STRING(self.textEndTime.text);
    if (!self.orgID)
    {
//        self.orgID=@"";
         self.orgID = [[NSUserDefaults standardUserDefaults] objectForKey:ORGKEY];
    }
    NSDictionary * dicTest = @{@"orgId":self.orgID,@"dateStart":startTime,@"dateEnd":endTime,@"pageNum":self.labelPageNumber.text,@"inspectionType":self.inspectionType,@"isContainLowerOrg":@"1",@"employeeId":KILL_NIL_STRING(self.employeeId)};
    
    [[self.dataModelCenter webService]getSupervisionAllInspectionList:dicTest withAsyncHanlder:^(NSArray *inspectionList, NSError *err) {
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
    NSDictionary * pageDic = @{@"orgId":self.orgID,@"dateStart":startTime,@"dateEnd":endTime,@"inspectionType":self.inspectionType,@"isContainLowerOrg":@"1",@"employeeId":KILL_NIL_STRING(self.employeeId)};
    [[self.dataModelCenter webService] getSupervisionAllInspectionListSize:pageDic withAsyncHanlder:^(int inspectionList, NSError *err) {
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
        NSString * startTime = KILL_NIL_STRING(self.textStartTime.text);
        NSString * endTime = KILL_NIL_STRING(self.textEndTime.text);
        NSDictionary * dicTest = @{@"orgId":self.orgID,@"dateStart":startTime,@"dateEnd":endTime,@"pageNum":pageNumber,@"inspectionType":self.inspectionType,@"isContainLowerOrg":@"1",@"employeeId":KILL_NIL_STRING(self.employeeId)};
        [[self.dataModelCenter webService]getSupervisionAllInspectionList:dicTest withAsyncHanlder:^(NSArray *inspectionList, NSError *err) {
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
    NSString * startTime = KILL_NIL_STRING(self.textStartTime.text);
    NSString * endTime = KILL_NIL_STRING(self.textEndTime.text);
    NSDictionary * dicTest = @{@"orgId":self.orgID,@"dateStart":startTime,@"dateEnd":endTime,@"pageNum":pageNumber,@"inspectionType":self.inspectionType,@"isContainLowerOrg":@"1",@"employeeId":KILL_NIL_STRING(self.employeeId)};
    [[self.dataModelCenter webService]getSupervisionAllInspectionList:dicTest withAsyncHanlder:^(NSArray *inspectionList, NSError *err) {
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
    NSString * startTime = KILL_NIL_STRING(self.textStartTime.text);
    NSString * endTime = KILL_NIL_STRING(self.textEndTime.text);
    NSDictionary * dicTest = @{@"orgId":self.orgID,@"dateStart":startTime,@"dateEnd":endTime,@"pageNum":pageNumber,@"inspectionType":@"",@"isContainLowerOrg":@"1",@"employeeId":KILL_NIL_STRING(self.employeeId)};
    [[self.dataModelCenter webService]getSupervisionAllInspectionList:dicTest withAsyncHanlder:^(NSArray *inspectionList, NSError *err) {
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
    InspectionMainCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[InspectionMainCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    for (OrgInfoSimpleModel * orgInfo in _allOrgID) {
        if ([orgInfo.identifier isEqualToString:[[_dataArray objectAtIndex:indexPath.row] organization_id]]) {
            NSString * custodyOrgName =orgInfo.orgName;
            cell.labelCustodyUnit.text = custodyOrgName;
        }
    }
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
    InspectionMainCell * view = [[InspectionMainCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
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

    
    InspectionInfoViewController * inspectionInfoVC= [InspectionInfoViewController newInstance];
    
    inspectionInfoVC.InspectionModel =[_dataArray objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:inspectionInfoVC animated:YES];
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
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
	return NO;
}
@end
