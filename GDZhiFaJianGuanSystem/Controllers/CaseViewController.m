//
//  CaseViewController.m
//  GDZhiFaJianGuanSystem
//
//  Created by quxiuyun on 14-2-18.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import "CaseViewController.h"
#import "DataModelCenter.h"
#import "DealSituationViewController.h"
#import "WorkProcessViewController.h"
#import "CaseInfoViewController.h"
#import "MBProgressHUD.h"
typedef enum _kUITag {
    kUITagTableViewDocList,
    kUITagTableViewAttachment
} kUITag;

// 附件、文书类型
static NSString *const CaseTypeReport = @"文书";
static NSString *const CaseTypeAttachment = @"附件";

@interface CaseViewController ()

@property (retain, nonatomic) UIPopoverController *myPopoverController;
@property (nonatomic, assign) DataModelCenter *dataModelCenter;
@property (nonatomic, retain) NSMutableArray * caseSituationArray;//案件办理情况Array

// 获取文书、附件列表
- (void)getCaseReportAndAttachmentlistFromServer;
// 过滤文书与附件列表
- (void)filterCaseAndAttachmentList:(NSArray *)attachList;
// 显示文书或附件
- (void)showCaseReportOrAttachmentPDF:(NSString *)urlString rect:(CGRect)cellRect;

@end

@implementation CaseViewController{
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
        _caseSituationArray = [[NSMutableArray alloc] init];
        
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];
    
    _viewInfoPage.hidden = NO;
    //办理情况需要一个标示符
    NSString * identifier = self.caseInfoModel.identifier;
    [[self.dataModelCenter webService] getSupervisionWorkflowList:identifier withAsyncHanlder:^(NSArray *taskList, NSError *err) {
		dispatch_sync(dispatch_get_main_queue(), ^{
			if (err == nil) {
				_caseSituationArray = [NSMutableArray arrayWithArray:taskList];
			}else
			{
				NSLog(@"........................");
			}
		});
    }];
}
- (void)viewDidLoad
{
	[[[DataModelCenter defaultCenter] webService].queue cancelAllOperations];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"案件信息"];
    UIBarButtonItem * backButton =[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(backButton)];
    [self.navigationItem setLeftBarButtonItem:backButton animated:YES];
    
    //为UI控件分配Tag
    [self assignUITags];
    
    //textview 边框
    _textBasicSituation.layer.borderWidth = 1;
    _textBasicSituation.layer.borderColor = UIColor.grayColor.CGColor;
    _textPerformSituation.layer.borderWidth = 1;
    _textPerformSituation.layer.borderColor = UIColor.grayColor.CGColor;
    
    
    [_caseNumber setText:_caseInfoModel.case_code];
    _caseNumber.userInteractionEnabled= NO;
    [_caseTime setText:[NSString stringWithFormat:@"%@",_caseInfoModel.happen_date]];
    _caseTime.userInteractionEnabled= NO;
    [_textBasicSituation setText:_caseInfoModel.caseqingkuang];
    [_textBasicSituation setEditable:NO];
    [_citizenName setText:_caseInfoModel.citizen_name];
    _citizenName.userInteractionEnabled= NO;
    //    [_route setText:_caseInfoModel.];
    _caseNumber.userInteractionEnabled= NO;
    [_startPointPileNo setText:_caseInfoModel.station_start_display];
    _startPointPileNo.userInteractionEnabled= NO;
    [_endPointPileNo setText:_caseInfoModel.station_end_display];
    _endPointPileNo.userInteractionEnabled= NO;
    [_claimAmount setText:_caseInfoModel.punish_sum];
    _claimAmount.userInteractionEnabled= NO;
    [_claimAmountReality setText:_caseInfoModel.fact_pay_sum];
    _claimAmountReality.userInteractionEnabled= NO;
    [_quanzongNo setText:_caseInfoModel.quanzong_no];
    _quanzongNo.userInteractionEnabled= NO;
    [_anjuanNo setText:_caseInfoModel.anjuan_no];
    _anjuanNo.userInteractionEnabled= NO;
    [_secret setText:_caseInfoModel.baomi_type];
    _secret.userInteractionEnabled= NO;
    [_fileNo setText:_caseInfoModel.danganshi_no];
    _fileNo.userInteractionEnabled= NO;
    [_eecordsRetentionTime setText:_caseInfoModel.limit];
    _eecordsRetentionTime.userInteractionEnabled= NO;
    [_textPerformSituation setText:_caseInfoModel.execute_circs];
    [_textPerformSituation setEditable:NO];
    
    [_route setText:_caseInfoModel.road_name];
    _route.userInteractionEnabled= NO;
    
    _direction.userInteractionEnabled= NO;
    _caseWeather.userInteractionEnabled= NO;
    _damageRoad.userInteractionEnabled= NO;
    _IllegalBehavior.userInteractionEnabled= NO;
    _stationEnd.userInteractionEnabled= NO;
    
    
    self.docListArray = [NSMutableArray array];
    self.attachmentArray = [NSMutableArray array];
    
    [self getCaseReportAndAttachmentlistFromServer];
}

#pragma mark - TableView dataSource & delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger number=0;
    if (tableView.tag==kUITagTableViewDocList) {
        number=self.docListArray.count;
    } else if (tableView.tag==kUITagTableViewAttachment) {
        number=self.attachmentArray.count;
    }
    return number;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *docListViewCellIdentifier = @"docListViewCell";
    static NSString *attachmentViewCellIdentifier = @"attachmentViewCell";
    NSString *CellIdentifier = [tableView isEqual:self.docListView]?docListViewCellIdentifier:attachmentViewCellIdentifier;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    ReportAndAttechmentModel *model;
    if ([tableView isEqual:self.docListView]){
        model = self.docListArray[indexPath.row];
    }
    else{
        model = self.attachmentArray[indexPath.row];
    }
    [cell textLabel].text = model.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ReportAndAttechmentModel *model;
    if ([tableView isEqual:self.docListView]){
        model = self.docListArray[indexPath.row];
    }
    else{
        model = self.attachmentArray[indexPath.row];
    }
    if (model && model.url){
//        [self showCaseReportOrAttachmentPDF:model.url rect:[self.view convertRect:[tableView rectForRowAtIndexPath:indexPath] fromView:tableView]];
        
//        CaseInfoViewController * caseInfoVC= [[CaseInfoViewController alloc]init];
//        caseInfoVC.urlString =model.url;
//        
//        [self.navigationController pushViewController:caseInfoVC animated:YES];
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
//    UIWebView* popoverView = [[UIWebView alloc]
//							  initWithFrame:rect];
//    popoverView.backgroundColor = [UIColor whiteColor];
//    
//    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
//    [popoverView loadRequest:request];
	
	
	//    popoverView.alpha=0.2;
	
	if ([urlString hasSuffix:@"jpg" ] ||
		[urlString hasSuffix:@"JPG" ] ) {
		UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
		imageView.layer.masksToBounds = YES;
		imageView.layer.cornerRadius = 5.0f;
		imageView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
		[self addGestureRecognizerToView:imageView];
		
		//如果处理的是图片，别忘了
		[imageView setUserInteractionEnabled:YES];
		[imageView setMultipleTouchEnabled:YES];
	    popoverContent.view = imageView;

		hud = [[MBProgressHUD alloc] initWithView:popoverContent.view];
		[popoverContent.view addSubview:hud];
		
		//如果设置此属性则当前的view置于后台
		hud.dimBackground = YES;
		
		//设置对话框文字
		hud.labelText = @"正在加载...";
		[hud show:YES];
		
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
			NSURL * url = [NSURL URLWithString:urlString];
			NSData * data = [[NSData alloc]initWithContentsOfURL:url];
			UIImage *image = [[UIImage alloc]initWithData:data];
			if (data != nil) {
				dispatch_async(dispatch_get_main_queue(), ^{
					imageView.image = image;
					[hud removeFromSuperview];
				});
			}
		});
	}else{
	    UIWebView* popoverView = [[UIWebView alloc]
								  initWithFrame:CGRectMake(0, 0, 1024, 768)];
		popoverView.delegate = self;
		popoverView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
		popoverContent.view = popoverView;
			NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
			[popoverView loadRequest:request];
		
		
	}

    
    //显示popover，则理告诉它是为一个矩形框设置popover
    [_myPopoverController presentPopoverFromRect:cellRect inView:self.view
						permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
}
#pragma mark - IBActions

- (void)backButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)changeInfoPage:(UISegmentedControl *)sender
{
    switch (sender.selectedSegmentIndex) {
        case 0:{
            if (_viewInfoPage.hidden) {
                _viewInfoPage.hidden = NO;
            }
        }
            break;
        case 1:{
            _viewInfoPage.hidden = YES ;
            DealSituationViewController * dealView =[[DealSituationViewController alloc] initWithNibName:@"DealSituationViewController" bundle:nil];
            dealView.dataArray=_caseSituationArray;
            [_background addSubview:dealView.view];
            [self addChildViewController:dealView];
            
        }
            break;
        case 2:{
            _viewInfoPage.hidden = YES ;
            //初始工作流程视图
            WorkProcessViewController *processVC = [[WorkProcessViewController alloc] initWithNibName:@"WorkProcessViewController" bundle:nil];
            processVC.dataArray = _caseSituationArray;
            [_background addSubview:processVC.view];
            [self addChildViewController:processVC];

        }
            break;
        default:
            break;
    }
}

#pragma mark - Private Methods

- (void)assignUITags
{
    self.docListView.tag          =   kUITagTableViewDocList;
    self.docListView.delegate = self;
    self.docListView.dataSource = self;
    self.attachmentView.tag       =   kUITagTableViewAttachment;
    self.attachmentView.delegate = self;
    self.attachmentView.dataSource = self;
}

#pragma mark - get data

// 获取文书、附件列表
- (void)getCaseReportAndAttachmentlistFromServer{
    
    //    [self permitInfo].identifier 许可id
    // 参数为案件identifier
    [[DataModelCenter defaultCenter].webService getSupervisionCaseReportAndAttechmentList:self.caseInfoModel.identifier withAsyncHanlder:^(NSArray *attachList, NSError *err) {
		dispatch_sync(dispatch_get_main_queue(), ^{
			[self filterCaseAndAttachmentList:attachList];
			[self.docListView reloadData];
			[self.attachmentView reloadData];
		});
    }];
}

// 过滤文书与附件列表
- (void)filterCaseAndAttachmentList:(NSArray *)attachList{
    [self.docListArray removeAllObjects];
    [self.attachmentArray removeAllObjects];
    
    NSPredicate *predicateReport = [NSPredicate predicateWithFormat:@"SELF.type == %@",CaseTypeReport];
    NSPredicate *predicateAttachment = [NSPredicate predicateWithFormat:@"SELF.type == %@",CaseTypeAttachment];
    
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

- (void)showCaseReportOrAttachmentPDF:(NSString *)urlString rect:(CGRect)cellRect{
    
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
    
    NSLog(@"url : %@",urlString);
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

// 添加所有的手势
- (void) addGestureRecognizerToView:(UIView *)view
{
	
    // 缩放手势
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
    [view addGestureRecognizer:pinchGestureRecognizer];
	
}


// 处理缩放手势
- (void) pinchView:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    UIView *view = pinchGestureRecognizer.view;
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
        pinchGestureRecognizer.scale = 1;
    }
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
