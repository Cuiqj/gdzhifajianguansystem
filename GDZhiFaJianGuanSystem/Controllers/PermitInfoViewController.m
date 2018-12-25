//
//  PermitInfoViewController.m
//  GDZhiFaJianGuanSystem
//
//  Created by quxiuyun on 14-2-18.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import "PermitInfoViewController.h"
#import "DataModelCenter.h"
#import "DealSituationViewController.h"
#import "WorkProcessViewController.h"
#import "HTMLParser.h"
#import "MBProgressHUD.h"
#define SCROLLVIEW_WIDTH 673.0
#define SCROLLVIEW_HEIGHT 633.0
#define PAGEINFO_HEIGHT 730.0

// 附件、文书类型
static NSString *const PermitTypeReport = @"文书";
static NSString *const PermitTypeAttachment = @"附件";


@interface PermitInfoViewController () <UITableViewDataSource, UITableViewDelegate>

@property (retain, nonatomic) UIPopoverController *myPopoverController;

@property (retain, nonatomic) NSMutableArray *permitDoclist; // 文书列表
@property (retain, nonatomic) NSMutableArray *attachments; // 附件列表
@property (retain, nonatomic) AllPermitModel * permitInfo;
@property (nonatomic, assign) DataModelCenter *dataModelCenter;
@property (nonatomic, retain) NSMutableArray * dealSituationArray;//办理情况
@property (nonatomic, retain) NSMutableArray * allOrgID;//全部机构ID

// 获取文书、附件列表
- (void)getPermitReportAndAttachmentlistFromServer;
// 过滤文书与附件列表
- (void)filterReportAndAttachmentList:(NSArray *)attachList;
// 显示文书或附件
- (void)showPermitReportOrAttachmentPDF:(NSString *)urlString rect:(CGRect)cellRect;

@end

@implementation PermitInfoViewController{
	MBProgressHUD *hud;
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
        self.dataModelCenter = [DataModelCenter defaultCenter];
         _dealSituationArray = [[NSMutableArray alloc] init];
        self.allOrgID = [[NSMutableArray alloc] init];
        [self obtainWithAllOrgID];
    }
    return self;
}

- (void)viewDidLoad
{
	[[[DataModelCenter defaultCenter] webService].queue cancelAllOperations];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"许可信息"];
    [_infoView setDelegate:self];
    UIBarButtonItem * backButton =[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(backButton)];
    [self.navigationItem setLeftBarButtonItem:backButton animated:YES];
    [self changeInfoPage:0];

    self.permitInfo = [self.dicTemp valueForKey:@"permitModel"];
    
    self.permitDoclist = [NSMutableArray array];
    self.attachments = [NSMutableArray array];

    [self getPermitReportAndAttachmentlistFromServer];
    
    //办理情况需要一个标示符
    AllPermitModel * permit = [self.dicTemp valueForKey:@"permitModel"];
    NSString * identifier = permit.identifier;
    [[self.dataModelCenter webService] getSupervisionWorkflowList:identifier withAsyncHanlder:^(NSArray *taskList, NSError *err) {
        if (err == nil) {
			dispatch_sync(dispatch_get_main_queue(), ^{
				_dealSituationArray = [NSMutableArray arrayWithArray:taskList];
			});
        }else
        {
            NSLog(@"........................");
        }
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
#pragma mark - IBActions

- (void)backButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)changeInfoPage:(UISegmentedControl *)sender
{
    // 首先清除所有视图
    for (UIView * view in _infoView.subviews) {
        [view removeFromSuperview];
    }
    switch (sender.selectedSegmentIndex) {
        case 0:{
            _infoView.hidden = NO ;
            AllPermitModel * permit = [self.dicTemp valueForKey:@"permitModel"];
            NSLog(@"%@",permit);
            //事故信息页面初始化
            _pageInfoVC = [[PageInfoViewController alloc] initWithNibName:@"PageInfoViewController" bundle:nil];
            _pageInfoVC.view.frame=CGRectMake(0.0, 0.0, SCROLLVIEW_WIDTH,PAGEINFO_HEIGHT);
            
            _pageInfoVC.bianHaoTextField.text=permit.app_no;
            _pageInfoVC.app_dateTextField.text= permit.app_date;
            _pageInfoVC.reasonTextField.text=permit.reason;
            _pageInfoVC.reason_detailTF.text=permit.reason_detail;
            _pageInfoVC.applicant_addressTF.text=permit.applicant_address;
            NSArray *dateEndArray = [permit.date_step componentsSeparatedByString:@"至"];

			if(dateEndArray.count > 0){
				_pageInfoVC.startTimeTF.text = dateEndArray[0];
			}
			if(dateEndArray.count > 1){
				_pageInfoVC.dateCut.text=[dateEndArray objectAtIndex:1];
			}
            
            _pageInfoVC.timeOutTF.text=permit.admissible_date;

			if(permit.admissible_date != nil && permit.admissible_date.length >= 10){
				_pageInfoVC.timeOutTF.text= [permit.admissible_date substringToIndex:10];
			}

            _pageInfoVC.addressTF.text = permit.permission_address;
            _pageInfoVC.applicant_nameTF.text=permit.applicant_name;
            _pageInfoVC.paysumTF.text=permit.paysum;
            _pageInfoVC.danganshi_noTF.text=permit.danganshi_no;
            _pageInfoVC.baomi_typeTF.text=permit.baomi_type;
            _pageInfoVC.anjuan_noTF.text=permit.anjuan_no;
            _pageInfoVC.quanzong_notf.text=permit.quanzong_no;
            _pageInfoVC.limitTF.text=permit.limit;
            _pageInfoVC.shennhe2.text=permit.countyjigname2;
            _pageInfoVC.shenheInfo2.text=permit.countyjigyijian2;
            _pageInfoVC.shenheInfo1.text=permit.countychbyijian1;
            _pageInfoVC.shenhe1TF.text=permit.countychbname1;
            _pageInfoVC.legal_spokesmanTF.text = permit.legal_spokesman;
            
            //受理单位：org_id，只保存了机构id，需要查询机构列表，显示对应的机构名称
            for (OrgInfoSimpleModel * orgInfo in self.allOrgID) {
                if ([orgInfo.identifier isEqualToString:permit.org_id]) {
                    NSString * custodyOrgName =orgInfo.orgName;
                    _pageInfoVC.admissibleAddressTF.text = custodyOrgName;
                }
            }
            if ([_pageInfoVC.admissibleAddressTF.text isEmpty]){
                _pageInfoVC.admissibleAddressTF.text = permit.org_id;
            }
            
            [_infoView addSubview:_pageInfoVC.view];
            _infoView.contentMode=UIViewContentModeLeft;
            _infoView.bounces=NO;
            _infoView.contentSize=CGSizeMake(SCROLLVIEW_WIDTH, PAGEINFO_HEIGHT);
            self.infoView.contentInset=UIEdgeInsetsZero;
            
            break;
        }
        case 1: {
            //办理情况页面初始化
            _infoView.hidden = YES ;
            DealSituationViewController * dealView =[[DealSituationViewController alloc] initWithNibName:@"DealSituationViewController" bundle:nil];
            dealView.dataArray=_dealSituationArray;
            [_backgroundView addSubview:dealView.view];
            [self addChildViewController:dealView];
            break;
        }
        case 2: {
            //初始工作流程视图
            _infoView.hidden = YES ;
            WorkProcessViewController *processVC = [[WorkProcessViewController alloc] initWithNibName:@"WorkProcessViewController" bundle:nil];
            processVC.dataArray = _dealSituationArray;
            [_backgroundView addSubview:processVC.view];
            [self addChildViewController:processVC];
            break;
        }
        default:
            break;
    }
}

#pragma mark - get data

// 获取文书、附件列表
- (void)getPermitReportAndAttachmentlistFromServer{
//    [self permitInfo].identifier 许可id
    [[DataModelCenter defaultCenter].webService getSupervisionPermitReportAndAttechmentList:[self permitInfo].identifier withAsyncHanlder:^(NSArray *attachList, NSError *err) {
		dispatch_sync(dispatch_get_main_queue(), ^{
			[self filterReportAndAttachmentList:attachList];
		});
    }];
}

// 过滤文书与附件列表
- (void)filterReportAndAttachmentList:(NSArray *)attachList{
    [self.permitDoclist removeAllObjects];
    [self.attachments removeAllObjects];
    
    NSPredicate *predicateReport = [NSPredicate predicateWithFormat:@"SELF.type == %@",PermitTypeReport];
    NSPredicate *predicateAttachment = [NSPredicate predicateWithFormat:@"SELF.type == %@",PermitTypeAttachment];
    
    NSArray *predicatelist1 = [attachList filteredArrayUsingPredicate:predicateReport];
    [self.permitDoclist addObjectsFromArray:predicatelist1];
//    for (ReportAndAttechmentModel *model in predicatelist1) {
//        NSLog(@"1 --type : %@ --name : %@ --title: %@",model.type,model.name,model.title);
//    }
    
    NSArray *predicatelist2 = [attachList filteredArrayUsingPredicate:predicateAttachment];
    [self.attachments addObjectsFromArray:predicatelist2];
//    for (ReportAndAttechmentModel *model in predicatelist2) {
//        NSLog(@"2 --type : %@ --name : %@ --title: %@",model.type,model.name,model.title);
//    }
    
    [self.docListView reloadData];
    [self.attachmentView reloadData];
}



#pragma mark - tableview delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if ([tableView isEqual:self.docListView]){
        return [self permitDoclist].count;
    }
    else{
        return [self attachments].count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *docListViewCellIdentifier = @"docListViewCell";
    static NSString *attachmentViewCellIdentifier = @"attachmentViewCell";
    NSString *CellIdentifier = [tableView isEqual:self.permitDoclist]?docListViewCellIdentifier:attachmentViewCellIdentifier;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    ReportAndAttechmentModel *model;
    if ([tableView isEqual:self.docListView]){
        model = [self.permitDoclist objectAtIndex:indexPath.row];
    }
    else{
        model = self.attachments[indexPath.row];
    }
    
    HTMLParser *parser = [[HTMLParser alloc] initWithString:model.name error:nil];
    HTMLNode *node = [parser body];
    NSString *str = [node allContents];
    str = [[str stringByReplacingOccurrencesOfString:@"<b>" withString:@""] stringByReplacingOccurrencesOfString:@"</b>" withString:@""];
    
    [cell textLabel].text = str;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ReportAndAttechmentModel *model;
    if ([tableView isEqual:self.docListView]){
        model = [self.permitDoclist objectAtIndex:indexPath.row];
    }
    else{
        model = self.attachments[indexPath.row];
    }
    if (model && model.url){
        NSArray *urls = [model.url componentsSeparatedByString:@","];
        [self showPermitReportOrAttachmentPDF:[urls lastObject] rect:[self.view convertRect:[tableView rectForRowAtIndexPath:indexPath] fromView:tableView]];
    }
}

#pragma mark - show report or attachment

- (void)showPermitReportOrAttachmentPDF:(NSString *)urlString rect:(CGRect)cellRect{

    CGRect rect = CGRectMake(0, 0, 1100, 700);
    
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
    popoverView.delegate = self;
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    [popoverView loadRequest:request];
//    popoverView.alpha=0.2;
    popoverContent.view = popoverView;
    
    //显示popover，则理告诉它是为一个矩形框设置popover
    [_myPopoverController presentPopoverFromRect:cellRect inView:self.view
                     permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark-UIWebViewDelegate
/**
 *WebView开始加载资源的时候调用（开始发送请求）
 */
-(void)webViewDidStartLoad:(UIWebView *)webView
{
	hud = [[MBProgressHUD alloc] initWithView:webView];
	[webView addSubview:hud];
	
	//如果设置此属性则当前的view置于后台
	hud.dimBackground = YES;
	
	//设置对话框文字
	hud.labelText = @"正在加载...";
	[hud show:YES];
	
}

/**
 52  *WebView加载完毕的时候调用（请求完毕）
 53  */
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
	[hud removeFromSuperview];
}

/**
 *WebView加载失败的时候调用（请求失败）
 */
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	[hud removeFromSuperview];
}
@end
