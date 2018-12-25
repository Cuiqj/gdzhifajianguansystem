//
//  TaskAgentsViewController.m
//  GDZhiFaJianGuanSystem
//
//  Created by quxiuyun on 14-2-24.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import "TaskAgentsViewController.h"
#import "TaskAgentsLeaderViewController.h"
#import "TaskAgentsPromoterViewController.h"
#import "TaskAgentsReviewerViewController.h"
#import "LicensedContentViewController.h"
#import "DealSituationViewController.h"
#import "DataModelCenter.h"
#import "WorkProcessViewController.h"
#import "HTMLParser.h"

typedef enum _kUITag {
    kUITagTableViewDocList,
    kUITagTableViewAttachment
} kUITag;

// 附件、文书类型
static NSString *const TaskAgentsTypeReport = @"文书";
static NSString *const TaskAgentsTypeAttachment = @"附件";

@interface TaskAgentsViewController ()
@property (nonatomic, assign) DataModelCenter *dataModelCenter;
@property (nonatomic, retain) NSMutableArray * dataArray;
@property (retain, nonatomic) UIPopoverController *myPopoverController;
@property (retain, nonatomic) NSMutableArray *docListArray; // 文书列表
@property (retain, nonatomic) NSMutableArray *attachmentArray; // 附件列表

// 获取文书、附件列表
- (void)getCaseReportAndAttachmentlistFromServer;
// 过滤文书与附件列表
- (void)filterCaseAndAttachmentList:(NSArray *)attachList;
// 显示文书或附件
- (void)showCaseReportOrAttachmentPDF:(NSString *)urlString rect:(CGRect)cellRect;
@end

@implementation TaskAgentsViewController

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
        
        self.dataModelCenter = [DataModelCenter defaultCenter];
        _dataArray =[[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"案件查询"];
	UIBarButtonItem * backbutton =[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(backButton)];
    [self.navigationItem setLeftBarButtonItem:backbutton animated:YES];
    
    [self assignUITags];
    
    //办理情况需要一个标示符
    NSString * identifier =self.currentModel.identifier;
    
    [[self.dataModelCenter webService] getSupervisionWorkflowList:@"1200193538" withAsyncHanlder:^(NSArray *taskList, NSError *err) {
        if (err == nil) {
            _dataArray = [NSMutableArray arrayWithArray:taskList];
        }else
        {
            NSLog(@"........................");
        }
    }];
    [self sgeChange:0];
    
    self.docListArray = [NSMutableArray array];
    self.attachmentArray = [NSMutableArray array];
    
    [self getCaseReportAndAttachmentlistFromServer];
}

#pragma mark - IBActions

- (void)backButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sgeChange:(UISegmentedControl *)sender
{
    // 首先清除所有视图
    for (UIView * view in _backgroundView.subviews) {
        [view removeFromSuperview];
    }
    switch (_segListOption.selectedSegmentIndex) {
        case 0:{
            NSString * nodeId = self.currentModel.nodeId;
            if ([nodeId isEqualToString:@"302"]||[nodeId isEqualToString:@"312"]||[nodeId isEqualToString:@"322"]) {
                //初始化审核人意见视图
                TaskAgentsReviewerViewController * reviewerView =[[TaskAgentsReviewerViewController alloc] initWithNibName:@"TaskAgentsReviewerViewController" bundle:nil];
                reviewerView.currentModel =self.currentModel;
                [_backgroundView addSubview:reviewerView.view];
                _backgroundView.contentMode =UIViewContentModeLeft;
                [_segListOption setTitle:@"审核意见" forSegmentAtIndex:0];
                [self addChildViewController:reviewerView];
            }else if ([nodeId isEqualToString:@"303"]||[nodeId isEqualToString:@"313"]||[nodeId isEqualToString:@"323"]){
                //初始化领导人意见视图
                TaskAgentsLeaderViewController * leaderView =[[TaskAgentsLeaderViewController alloc] initWithNibName:@"TaskAgentsLeaderViewController" bundle:nil];
                leaderView.currentModel =self.currentModel;
                [_backgroundView addSubview:leaderView.view];
                _backgroundView.contentMode =UIViewContentModeLeft;
                [_segListOption setTitle:@"领导意见" forSegmentAtIndex:0];
                [self addChildViewController:leaderView];
            }else{
                //初始化承办人意见视图
                TaskAgentsPromoterViewController * promoterView =[[TaskAgentsPromoterViewController alloc] initWithNibName:@"TaskAgentsPromoterViewController" bundle:nil];
                promoterView.currentModel =self.currentModel;
                [_backgroundView addSubview:promoterView.view];
                _backgroundView.contentMode =UIViewContentModeLeft;
                [_segListOption setTitle:@"承办意见" forSegmentAtIndex:0];
                [self addChildViewController:promoterView];
            }
        }
            break;
        case 1:{
            //初始许可申请内容视图
            LicensedContentViewController * licensedView =[[LicensedContentViewController alloc] initWithNibName:@"LicensedContentViewController" bundle:nil];
            licensedView.currentModel =self.currentModel;
            [_backgroundView addSubview:licensedView.view];
            [self addChildViewController:licensedView];
        }
            break;
        case 2:{
            //初始办理情况视图
            DealSituationViewController * dealView =[[DealSituationViewController alloc] initWithNibName:@"DealSituationViewController" bundle:nil];
            dealView.dataArray=_dataArray;
            [_backgroundView addSubview:dealView.view];
            [self addChildViewController:dealView];
        }
            break;
        case 3:{
            //初始工作流程视图
            WorkProcessViewController *processVC = [[WorkProcessViewController alloc] initWithNibName:@"WorkProcessViewController" bundle:nil];
            processVC.dataArray = self.dataArray;
            [_backgroundView addSubview:processVC.view];
            [self addChildViewController:processVC];
            
        }
            break;
        default:
            break;
    }
}

#pragma mark - UITableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger number=0;
    if (tableView.tag==kUITagTableViewDocList) {
        number=self.docListArray.count;
    } else if (tableView.tag==kUITagTableViewAttachment) {
        number=self.attachmentArray.count;
    }
    return number;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 37;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *docListViewCellIdentifier = @"docListViewCell";
    static NSString *attachmentViewCellIdentifier = @"attachmentViewCell";
    NSString *CellIdentifier = [tableView isEqual:self.tableDocumentsList]?docListViewCellIdentifier:attachmentViewCellIdentifier;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    ReportAndAttechmentModel *model;
    if ([tableView isEqual:self.tableDocumentsList]){
        model = self.docListArray[indexPath.row];
    }
    else{
        model = self.attachmentArray[indexPath.row];
    }
    
    //以下为剔除html乱码字符串的方法
    HTMLParser *parser = [[HTMLParser alloc] initWithString:model.name error:nil];
    HTMLNode *node= [parser body];
    NSString *str = [node allContents];
    str = [[str stringByReplacingOccurrencesOfString:@"<b>" withString:@""] stringByReplacingOccurrencesOfString:@"</b>" withString:@""];
    [cell textLabel].text = str;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ReportAndAttechmentModel *model;
    if ([tableView isEqual:self.tableDocumentsList]){
        model = self.docListArray[indexPath.row];
    }
    else{
        model = self.attachmentArray[indexPath.row];
    }
    if (model && model.url){
        [self showCaseReportOrAttachmentPDF:model.url rect:[self.view convertRect:[tableView rectForRowAtIndexPath:indexPath] fromView:tableView]];
    }
}

// 获取文书、附件列表
- (void)getCaseReportAndAttachmentlistFromServer{
    
    //    [self permitInfo].identifier 许可id
    [[DataModelCenter defaultCenter].webService getSupervisionCaseReportAndAttechmentList:self.currentModel.project_id withAsyncHanlder:^(NSArray *attachList, NSError *err) {

		dispatch_sync(dispatch_get_main_queue(), ^{
			[self filterCaseAndAttachmentList:attachList];
			[self.tableDocumentsList reloadData];
			[self.tableAttachmentList reloadData];
		});
    }];
}

// 过滤文书与附件列表
- (void)filterCaseAndAttachmentList:(NSArray *)attachList{
    [self.docListArray removeAllObjects];
    [self.attachmentArray removeAllObjects];
    
    NSPredicate *predicateReport = [NSPredicate predicateWithFormat:@"SELF.type == %@",TaskAgentsTypeReport];
    NSPredicate *predicateAttachment = [NSPredicate predicateWithFormat:@"SELF.type == %@",TaskAgentsTypeAttachment];
    
    NSArray *predicatelist1 = [attachList filteredArrayUsingPredicate:predicateReport];
    [self.docListArray addObjectsFromArray:predicatelist1];
    for (ReportAndAttechmentModel *model in predicatelist1) {
        NSLog(@"1 --type : %@ --name : %@ --title: %@",model.type,model.name,model.title);
    }
    
    NSArray *predicatelist2 = [attachList filteredArrayUsingPredicate:predicateAttachment];
    [self.attachmentArray addObjectsFromArray:predicatelist2];
    for (ReportAndAttechmentModel *model in predicatelist2) {
        NSLog(@"2 --type : %@ --name : %@ --title: %@",model.type,model.name,model.title);
    }
    
}

- (void)showCaseReportOrAttachmentPDF:(NSString *)urlString rect:(CGRect)cellRect{
    
    CGRect rect = CGRectMake(0, 0, 670, 700);
    
    //创建一个新的控制器
    UIViewController* popoverContent = [[UIViewController alloc] init];
    //创建popover控制器，用上面的控制器赋值初始化
    _myPopoverController=[[UIPopoverController alloc]initWithContentViewController:popoverContent];
    //如果需要在popover消失的时候做事情，需要写一些delegate方法
    //    popoverController.delegate = self;//可不设置，如果不需要的话
    //popover显示的大小
    _myPopoverController.popoverContentSize=rect.size;
    
    //popover要显示的view
    UIWebView* popoverView = [[UIWebView alloc]
                              initWithFrame:rect];
    popoverView.backgroundColor = [UIColor whiteColor];
    
    NSLog(@"url : %@",urlString);
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    [popoverView loadRequest:request];
    //    popoverView.alpha=0.2;
    popoverContent.view = popoverView;
    
    //显示popover，则理告诉它是为一个矩形框设置popover
    [_myPopoverController presentPopoverFromRect:cellRect inView:self.view
                        permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
}
#pragma mark - Private Methods

- (void)assignUITags
{
    self.tableDocumentsList.tag          =   kUITagTableViewDocList;
    self.tableDocumentsList.delegate = self;
    self.tableDocumentsList.dataSource = self;
    self.tableAttachmentList.tag       =   kUITagTableViewAttachment;
    self.tableAttachmentList.delegate = self;
    self.tableAttachmentList.dataSource = self;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - get data

// 获取文书、附件列表
- (void)getTaskAgentsReportAndAttachmentlistFromServer{
    
    //    [self permitInfo].identifier 许可id
    [[DataModelCenter defaultCenter].webService getSupervisionCaseReportAndAttechmentList:@"1200193538" withAsyncHanlder:^(NSArray *attachList, NSError *err) {
		dispatch_sync(dispatch_get_main_queue(), ^{
			[self filterTaskAgentsReportAndAttachmentList:attachList];
			[self.tableAttachmentList reloadData];
			[self.tableDocumentsList reloadData];
		});
    }];
}

// 过滤文书与附件列表
- (void)filterTaskAgentsReportAndAttachmentList:(NSArray *)attachList{
    [self.docListArray removeAllObjects];
    [self.attachmentArray removeAllObjects];
    
    NSPredicate *predicateReport = [NSPredicate predicateWithFormat:@"SELF.type == %@",TaskAgentsTypeReport];
    NSPredicate *predicateAttachment = [NSPredicate predicateWithFormat:@"SELF.type == %@",TaskAgentsTypeAttachment];
    
    NSArray *predicatelist1 = [attachList filteredArrayUsingPredicate:predicateReport];
    [self.docListArray addObjectsFromArray:predicatelist1];
    for (ReportAndAttechmentModel *model in predicatelist1) {
        NSLog(@"1 --type : %@ --name : %@ --title: %@",model.type,model.name,model.title);
    }
    
    NSArray *predicatelist2 = [attachList filteredArrayUsingPredicate:predicateAttachment];
    [self.attachmentArray addObjectsFromArray:predicatelist2];
    for (ReportAndAttechmentModel *model in predicatelist2) {
        NSLog(@"2 --type : %@ --name : %@ --title: %@",model.type,model.name,model.title);
    }
    
}

#pragma mark - show report or attachment

- (void)showTaskAgentsReportOrAttachmentPDF:(NSString *)urlString rect:(CGRect)cellRect{
    
    CGRect rect = CGRectMake(0, 0, 670, 700);
    
    //创建一个新的控制器
    UIViewController* popoverContent = [[UIViewController alloc] init];
    //创建popover控制器，用上面的控制器赋值初始化
    _myPopoverController=[[UIPopoverController alloc]initWithContentViewController:popoverContent];
    //如果需要在popover消失的时候做事情，需要写一些delegate方法
    //    popoverController.delegate = self;//可不设置，如果不需要的话
    //popover显示的大小
    _myPopoverController.popoverContentSize=rect.size;
    
    //popover要显示的view
    UIWebView* popoverView = [[UIWebView alloc]
                              initWithFrame:rect];
    popoverView.backgroundColor = [UIColor whiteColor];
    
    NSLog(@"url : %@",urlString);
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    [popoverView loadRequest:request];
    //    popoverView.alpha=0.2;
    popoverContent.view = popoverView;
    
    //显示popover，则理告诉它是为一个矩形框设置popover
    [_myPopoverController presentPopoverFromRect:cellRect inView:self.view
                        permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
}

@end
