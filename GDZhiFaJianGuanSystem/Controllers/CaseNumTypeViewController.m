//
//  CaseNumTypeViewController.m
//  GDZhiFaJianGuanSystem
//
//  Created by yu hongwu on 14-9-19.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//


#import "CaseNumTypeViewController.h"


@interface CaseNumTypeViewController ()
@property (nonatomic,strong )NSArray *childOrgArray;
@end

@implementation CaseNumTypeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
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
		self.childOrgArray = [[NSArray alloc] init];
    }
    return self;
}
//-(id)initWithOrgData{
//	
//	self = [super init];
//	if(self){
//		_orgDataArray = [[NSMutableArray alloc]initWithObjects:@"发案数量11",@"结案数量",@"当前未结案数量", nil];
//	}
//	return self;
//}
- (void)viewDidLoad
{
	
	
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [_listTableView setDelegate:self];
    [_listTableView setDataSource:self];
    if (!_shouldBack){
        self.orgNavigationItem.leftBarButtonItem = nil;
    }
    self.orgNavigationItem.title = self.title;
}




- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(void)setDataArray{
	_orgDataArray = [[NSMutableArray alloc]initWithObjects:@"申请数量",@"结案数量",@"当前未结案数量", nil] ;
	[_listTableView reloadData];
}
-(void)setOrgDataArray{
	_orgDataArray = [[NSMutableArray alloc]initWithObjects:@"发案数量",@"结案数量",@"当前未结案数量", nil] ;
	[_listTableView reloadData];
}
#pragma mark - IBActions

- (IBAction)cancelButton:(UIBarButtonItem *)sender
{
	//    if (self.navigationController.)
	[self.pickerPopover dismissPopoverAnimated:YES];

}

- (IBAction)saveButton:(UIBarButtonItem *)sender
{
	//    [self.delegate setDate:[self.formatter stringFromDate:[self.datePicker date]]];
	//    [self.delegate setOrg:[self]]
	//    [self.pickerPopover dismissPopoverAnimated:YES];
    [self.pickerPopover dismissPopoverAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _orgDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [_orgDataArray objectAtIndex:indexPath.row];
    cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
    NSString *caseNumTypeName = self.orgDataArray[indexPath.row];
	if([caseNumTypeName isEqualToString:@"结案数量"]){
		[self.delegate setCaseNumType: [[NSNumber alloc]initWithInt:2] content:caseNumTypeName];
	}else if([caseNumTypeName isEqualToString:@"当前未结案数量"]){
		[self.delegate setCaseNumType: [[NSNumber alloc]initWithInt:3] content:caseNumTypeName];
	}else{
		[self.delegate setCaseNumType: [[NSNumber alloc]initWithInt:1] content:caseNumTypeName];
	}
	[self.pickerPopover dismissPopoverAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
