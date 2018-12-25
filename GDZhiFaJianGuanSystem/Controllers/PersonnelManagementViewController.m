//
//  PersonnelManagementViewController.m
//  GDZhiFaJianGuanSystem
//
//  Created by quxiuyun on 14-3-4.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import "PersonnelManagementViewController.h"
#import "PersonnelManagementCell.h"
#import "DataModelCenter.h"
#import "BasicDataViewController.h"
#import "CaseMainViewController.h"
#import "InspectionMainViewController.h"
#import "PermitMainViewController.h"
#import "OrgTreeViewController.h"
#import "AppUtil.h"
#import "CollapseCell.h"


#define SCROLLVIEW_WIDTH 1000.0
@interface PersonnelManagementViewController ()


@property (nonatomic, retain) NSMutableArray * dataArray;
@property (nonatomic, strong) DataModelCenter * dataModelCenter;
@property (nonatomic, strong) NSString * orgID;//
@end

@implementation PersonnelManagementViewController{
	UIView *orgTreeView;
	UITableView *organizationTreeTableView;
	NSMutableArray *orgTreeViewNodes;
	//被选中的机构
	CollapseCell *orgCell;
	BOOL flag;
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
        
        self.dataModelCenter=[DataModelCenter defaultCenter];
        _dataArray =[[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
	[[[DataModelCenter defaultCenter] webService].queue cancelAllOperations];
    [super viewDidLoad];
	flag = YES;
	self.orgID = [[NSUserDefaults standardUserDefaults] objectForKey:ORGKEY];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"人员管理"];

    
	UIBarButtonItem * backbutton =[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(backButton)];
    [self.navigationItem setLeftBarButtonItem:backbutton animated:YES];
    

    

    
    _tableManagementList =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCROLLVIEW_WIDTH, 633) style:UITableViewStylePlain];
    [_tableManagementList setDataSource:self];
    [_tableManagementList setDelegate:self];
    [_scrollView addSubview:_tableManagementList];
    [self.scrollView setFrame:CGRectMake(12, 350, 1000, 335)];
    _scrollView.contentMode=UIViewContentModeLeft;
    _scrollView.bounces=NO;
    _scrollView.contentSize=CGSizeMake(SCROLLVIEW_WIDTH, 330);
    _scrollView.contentInset=UIEdgeInsetsZero;


    // 自动获取 2014-04-04
    [self queryPerson];
	[self queryOptions:nil];
}



#pragma mark - IBActions

- (void)backButton
{
    [self.navigationController popViewControllerAnimated:YES];
}



- (IBAction)queryOptions:(UIButton *)sender
{
	if(orgTreeView == nil){
		orgTreeView = [[UIViewController alloc] initWithNibName:@"OrgTreeViewController" bundle:nil].view;
		organizationTreeTableView = (UITableView*)[orgTreeView viewWithTag:417];
		organizationTreeTableView.dataSource = self;
		organizationTreeTableView.delegate = self;
	}
	[orgTreeView setFrame:CGRectMake(12, 13, 200, 675)];


	

	
	

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
	}else{
		[self fillDisplayArray];
		[organizationTreeTableView reloadData];
	}
	
	
	[self.view addSubview:orgTreeView];
	
	

	
	_tableManagementList =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCROLLVIEW_WIDTH, 680) style:UITableViewStylePlain];
	[_tableManagementList setDataSource:self];
	[_tableManagementList setDelegate:self];
	[_scrollView addSubview:_tableManagementList];
	_scrollView.contentMode=UIViewContentModeLeft;
	_scrollView.bounces=NO;
	_scrollView.contentSize=CGSizeMake(SCROLLVIEW_WIDTH, 330);
	_scrollView.contentInset=UIEdgeInsetsZero;

}

- (IBAction)queryPerson
{



    NSString * org = [self.orgID emptyString];
    
    [[self.dataModelCenter webService] getSupervisionEmployeeInfoList:@{@"orgId": KILL_NIL_STRING(org)} withAsyncHanlder:^(NSArray *employeeList, NSError *err) {
		dispatch_sync(dispatch_get_main_queue(), ^{
			if (employeeList.count==0) {
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有符合条件数据" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
				[alert show];
			}
			[_dataArray removeAllObjects];
			[_dataArray addObjectsFromArray:employeeList];
			[_tableManagementList reloadData];
		});
    }];
}

#pragma mark - UITableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	if(tableView == organizationTreeTableView){
		return orgTreeViewNodes.count;
	}
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 37;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	
	
	if(tableView == organizationTreeTableView){
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
    PersonnelManagementCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[PersonnelManagementCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

    }
    

    
    cell.caseSearchButton.tag = 1000+indexPath.row;

	
    [cell.caseSearchButton addTarget:self action:@selector(caseSearchButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.inspectionSearchButton.tag = 2000+indexPath.row;

    [cell.inspectionSearchButton addTarget:self action:@selector(inspectionSearchButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.permitSearchButton.tag = 3000+indexPath.row;

    [cell.permitSearchButton addTarget:self action:@selector(permitSearchButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell configureCellWithAllPermitArray:[_dataArray objectAtIndex:indexPath.row]];
    cell.labelNumber.text = [NSString stringWithFormat:@"%d", indexPath.row + 1];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	if(tableView == organizationTreeTableView) return 0;
    return 37;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	if(tableView == organizationTreeTableView) return tableView.tableHeaderView;
    PersonnelManagementCell * view = [[PersonnelManagementCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
	view.caseSearchButton.hidden = YES;
	view.inspectionSearchButton.hidden = YES;
	view.permitSearchButton.hidden = YES;
	

    view.contentView.backgroundColor = [UIColor lightGrayColor];
    [view titleLabel];
    return view.contentView;
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_dataArray removeObjectAtIndex:indexPath.row];
        // Delete the row from the data source.
        [_tableManagementList deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
    
    [_tableManagementList reloadData];
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	
	if(tableView == organizationTreeTableView){
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
		[self queryPerson];
		return;
		
	}
    BasicDataViewController * basicDataView =[[BasicDataViewController alloc] init];
    EmployeeInfoModel * employeeInfoModel =[_dataArray objectAtIndex:indexPath.row];
    basicDataView.basicDataModel =employeeInfoModel;
    basicDataView.canEdit = NO;
    [self.navigationController pushViewController:basicDataView animated:YES];
}

-(void)caseSearchButtonClicked:(UIButton *)sender
{
    
    CaseMainViewController * caseMainView =[CaseMainViewController newInstance];
    
    EmployeeInfoModel * employeeInfoModel =[_dataArray objectAtIndex:sender.tag-1000];
    caseMainView.employeeModel = employeeInfoModel;
    [self.navigationController pushViewController:caseMainView animated:YES];
}

-(void)inspectionSearchButtonClicked:(UIButton *)sender
{
    
    InspectionMainViewController * basicDataView =[InspectionMainViewController newInstance];
    EmployeeInfoModel * employeeInfoModel =[_dataArray objectAtIndex:sender.tag-2000];
    basicDataView.employeeModel =employeeInfoModel;
    [self.navigationController pushViewController:basicDataView animated:YES];
}

-(void)permitSearchButtonClicked:(UIButton *)sender
{
    
    PermitMainViewController * basicDataView =[PermitMainViewController newInstance];
    EmployeeInfoModel * employeeInfoModel =[_dataArray objectAtIndex:sender.tag-3000];
    basicDataView.employeeModel =employeeInfoModel;
    [self.navigationController pushViewController:basicDataView animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
	
	if(tableView == organizationTreeTableView){
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
    [organizationTreeTableView reloadData];
}


@end
