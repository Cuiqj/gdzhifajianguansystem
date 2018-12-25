//
//  OrgSelectController.m
//  GDZhiFaJianGuanSystem
//
//  Created by quxiuyun on 14-2-20.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import "OrgSelectController.h"
#import "OrgInfoSimpleModel.h"
#import "DataModelCenter.h"

@interface OrgSelectController ()
@property (nonatomic,strong )NSArray *childOrgArray;
@end

@implementation OrgSelectController

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


- (void)setOrgDataArray:(NSArray *)orgDataArray
{
    if (_orgDataArray != orgDataArray) {
        _orgDataArray = orgDataArray;
    }
    [_listTableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - IBActions

- (IBAction)cancelButton:(UIBarButtonItem *)sender
{
//    if (self.navigationController.)
//    [self.pickerPopover dismissPopoverAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
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
    cell.textLabel.text = [[_orgDataArray objectAtIndex:indexPath.row] orgShortName];
    cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    OrgInfoSimpleModel *aOrg = self.orgDataArray[indexPath.row];
    NSString * orgID= aOrg.identifier;
    NSString * orgName = aOrg.orgName;
    [[[DataModelCenter defaultCenter] webService] getSupervisionLowerOrgList:orgID withAsyncHanlder:^(NSArray *orgList, NSError *err) {
        if (err == nil) {
			dispatch_sync(dispatch_get_main_queue(), ^{
				self.childOrgArray = orgList;
			
				if (self.childOrgArray.count > 0) {
					[self.delegate setOrgID:orgID withOrgName:orgName];
					OrgSelectController *child = [[OrgSelectController alloc] init];
					child.orgDataArray = self.childOrgArray;
					child.pickerPopover = self.pickerPopover;
					child.delegate = self.delegate;
					child.title = orgName;
					child.shouldBack = YES;
					[self.navigationController pushViewController:child animated:YES];
					
				}else{
					// 选中
					[self.delegate setOrgID:orgID withOrgName:orgName];
					[self.pickerPopover dismissPopoverAnimated:YES];
				}
            
			});
        }else{
            NSLog(@"-------%@",err);
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
