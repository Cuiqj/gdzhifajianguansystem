//
//  MainPageViewController.m
//  GDZhiFaJianGuanSystem
//
//  Created by XU SHIWEN on 14-2-7.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import "MainPageViewController.h"
#import "LoginViewController.h"
#import "WorkBenchViewController.h"
#import "StatisticsMainViewController.h"
#import "CaseMainViewController.h"
#import "PermitMainViewController.h"
#import "InspectionMainViewController.h"
#import "PersonnelManagementViewController.h"
#import "MianPageListNameCell.h"
#import "DataModelCenter.h"
#import "LawViewController.h"
#import "TaskAgentsViewController.h"
#import "DataSynViewController.h"
#import "MessageCenterCell.h"
#import "AnnouncementsCell.h"
#import "AnnouncementsViewController.h"
#import "CurrentTaskModel.h"
#import "OrgArticleModel.h"
#import "TreeViewNode.h"
#import "OrgInfoSimpleModel.h"
#import "AppUtil.h"
#import "SVWebViewController.h"
#import "RoadEngrossMainViewController.h"



@interface MainPageViewController () <LoginDelegate> {
    UIView * _loginMask;
	UIView * _settingMask;
}
@property (nonatomic, assign) DataModelCenter *dataModelCenter;
@property (nonatomic, retain) NSMutableArray * dataArray;
@property (nonatomic) BOOL success;

@end

@implementation MainPageViewController

+ (instancetype)newInstance
{
    return [[[self alloc] initWithNibName:@"MainPageView" bundle:nil] prepareForUse];
}

- (id)prepareForUse
{
    //在这里完成一些内部参数的初始化
    self.workBenchController = [WorkBenchViewController newInstance];
    self.loginController = [LoginViewController newInstance];
    [self.loginController addMyTarget:self action:@selector(dismissLoginView:)];
    self.loginController.delegate = self;
    self.loginController.modalInPopover = YES;
    self.loginController.modalPresentationStyle = UIModalPresentationPageSheet;
	
	
	self.settingController = [SettingViewController newInstance];
    [self.settingController addMyTarget:self action:@selector(dismissSettingView)];
    self.settingController.delegate = self;
    self.settingController.modalInPopover = YES;
    self.settingController.modalPresentationStyle = UIModalPresentationPageSheet;
	
	
    self.dataModelCenter = [DataModelCenter defaultCenter];
    _dataArray =[[NSMutableArray alloc] init];
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

//监测是否设置当前机构，否则弹出机构选择菜单
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad
{
	[[[DataModelCenter defaultCenter] webService].queue cancelAllOperations];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSString * name= [[NSUserDefaults standardUserDefaults] objectForKey:USERKEY];
    NSString * password = [[NSUserDefaults standardUserDefaults] objectForKey:USERPASSWORD];
    if (name.length < 1 || password.length < 1) {
        [self pushLoginView];
    } else {

		if([self.dataModelCenter webService] == nil){//如果为nil则表示还没有进行过登录
			//在获取tableView数据
			[self.dataModelCenter loginWithName:name andPwd:password andResult:^(BOOL success, NSError *err){
				
				[self listOption:_segListOption];
			}];
		}else{
			[self listOption:_segListOption];
		}
		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注销" style:UIBarButtonItemStyleBordered target:self action:@selector(cancellationButton)];
		self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"BBS" style:UIBarButtonItemStyleBordered target:self action:@selector(openBBS)];
    }
    [_tvTaskList setDataSource:self];
    [_tvTaskList setDelegate:self];
   
	
//    [[self.dataModelCenter webService] getSupervisionRoadassetPrice:^(NSArray *roadasset, NSError *err) {
//        if (err == nil) {
//        }
//    }];
//    
//    [[self.dataModelCenter webService] getSupervisionRoadEngrossPrice:^(NSArray *roadEngross, NSError *err) {
//        if (err == nil) {
//        }
//    }];

    //获取全部机构，在案件界面的所属机构中用到，还有巡查信息界面的管养单位用到


}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushLoginView
{
    //选择一种方法显示出self.logController的界面
    CGFloat bottom = self.view.frame.size.height;
    CGFloat x = (self.view.frame.size.width - _loginController.view.frame.size.width) / 2;
    CGFloat y = (self.view.frame.size.height - _loginController.view.frame.size.height) / 2 - 100;
    
    // 修改起始位置
    CGRect frame =  _loginController.view.frame;
    frame.origin.x = x;
    frame.origin.y = bottom;
    _loginController.view.frame = frame;
    
    // 设置动画结束位置,设置蒙版
    frame.origin.y = y - 30;
    _loginMask = [[UIView alloc] initWithFrame:self.view.frame];
    _loginMask.backgroundColor = [UIColor colorWithRed:5/255.0 green:30/255.0 blue:45/255.0 alpha:1];
    _loginMask.alpha = 1;
    [self.view addSubview:_loginMask];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注销" style:UIBarButtonItemStyleBordered target:self action:@selector(cancellationButton)];
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStyleBordered target:self action:@selector(pushSettingView)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [UIView animateWithDuration:0.3
                     animations:^{
                         _loginController.view.frame = frame;
                     }
                     completion:^(BOOL finished) {
                     }];
    
    [self.view addSubview:_loginController.view];
}



- (void)pushSettingView
{

    CGFloat bottom = self.view.frame.size.height;
    CGFloat x = (self.view.frame.size.width - _settingController.view.frame.size.width) / 2;
    CGFloat y = (self.view.frame.size.height - _settingController.view.frame.size.height) / 2 - 100;
    
    // 修改起始位置
    CGRect frame =  _loginController.view.frame;
    frame.origin.x = x;
    frame.origin.y = bottom;
    _loginController.view.frame = frame;
    
    // 设置动画结束位置,设置蒙版
    frame.origin.y = y - 30;
    _settingMask = [[UIView alloc] initWithFrame:self.view.frame];
    _settingMask.backgroundColor = [UIColor colorWithRed:5/255.0 green:30/255.0 blue:45/255.0 alpha:1];
    _settingMask.alpha = 1;
    [self.view addSubview:_settingMask];
    self.navigationItem.leftBarButtonItem.enabled = NO;
    [UIView animateWithDuration:0.3
                     animations:^{
						  [_loginMask removeFromSuperview];
                         _settingController.view.frame = frame;
                     }
                     completion:^(BOOL finished) {
                     }];
    
    [self.view addSubview:_settingController.view];
}
- (void)setSettingDisable
{
	self.navigationItem.leftBarButtonItem.enabled = NO;
}
- (void)dismissLoginView:(NSArray *)dataList
{
    _dataArray = [NSMutableArray arrayWithArray:dataList];
    [_tvTaskList reloadData];
    
    // 修改起始位置
    CGRect frame =  _loginController.view.frame;
    // 设置动画结束位置
    frame.origin.y = self.view.frame.size.height;
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         _loginController.view.frame = frame;
                     }
                     completion:^(BOOL finished) {
                         [_loginMask removeFromSuperview];
						 self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"BBS" style:UIBarButtonItemStyleBordered target:self action:@selector(openBBS)];
                         self.navigationItem.rightBarButtonItem.enabled = YES;
                     }];
    
//    [self.view addSubview:_loginController.view];
}
- (void)dismissSettingView
{

    
    // 修改起始位置
    CGRect frame =  _loginController.view.frame;
    // 设置动画结束位置
    frame.origin.y = self.view.frame.size.height;
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         _settingController.view.frame = frame;
                     }
                     completion:^(BOOL finished) {
                         [_settingMask removeFromSuperview];
						 [self pushLoginView];
                         self.navigationItem.leftBarButtonItem.enabled = YES;
                     }];
    
	//    [self.view addSubview:_loginController.view];
}

- (void)hideLogin
{
    //根据showLogin来隐藏login界面
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareWorkBench
{
    [self addChildViewController:self.workBenchController];
    [self.childContainer addSubview:self.workBenchController.view];
    [self.workBenchController didMoveToParentViewController:self];
}

#pragma mark - IBActions

-(void)cancellationButton
{
//    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:USERKEY];
//    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:USERPASSWORD];
    
    [_dataArray removeAllObjects];
    [_tvTaskList reloadData];
    
    [self pushLoginView];
}
-(void)openBBS
{
	
	NSArray *array = [[AppDelegate App].serverAddress componentsSeparatedByString:@"/"];
	NSURL *url = [NSURL URLWithString:[[(NSString*)[array objectAtIndex:0] stringByAppendingFormat:@"//%@",(NSString*)[array objectAtIndex:2] ] stringByAppendingFormat:@"%@", BBS_LOCATION ]];
	SVWebViewController *webViewController = [[SVWebViewController alloc] initWithURL:url];
	[self.navigationController pushViewController:webViewController animated:YES];
}
- (IBAction)listOption:(id)sender
{
    _segListOption.userInteractionEnabled = NO;
    switch (_segListOption.selectedSegmentIndex) {
        case 0:{
            [[self.dataModelCenter webService] getSupervisionMessageList:@"1" withAsyncHanlder:^(NSArray *messageList, NSError *err) {
				dispatch_sync(dispatch_get_main_queue(), ^{
					if (err == nil) {
						[_dataArray removeAllObjects];
						_dataArray = [NSMutableArray arrayWithArray:messageList];
						[_tvTaskList reloadData];
					}
					_segListOption.userInteractionEnabled = YES;
				});
            }];
        }
            break;
        case 1:{
            [[self.dataModelCenter webService] getSupervisionOrgArticleList:@"1" withAsyncHanlder:^(NSArray *orgArticleList, NSError *err) {
				dispatch_sync(dispatch_get_main_queue(), ^{
					if (err == nil) {
						[_dataArray removeAllObjects];
						_dataArray = [NSMutableArray arrayWithArray:orgArticleList];
						[_tvTaskList reloadData];
					}
					_segListOption.userInteractionEnabled = YES;
				});
            }];
        }
            break;
        case 2:{
			[[self.dataModelCenter webService] getSupervisionUserSignTask:^(NSArray *userSignTaskList, NSError *err) {
				dispatch_sync(dispatch_get_main_queue(), ^{
					if (err == nil){
						[_dataArray removeAllObjects];
						_dataArray = [NSMutableArray arrayWithArray:userSignTaskList];
						[_tvTaskList reloadData];
					}
					_segListOption.userInteractionEnabled = YES;
				});
            }];
        }
            break;
        default:
            break;
    }
}

- (IBAction)boxUp:(id)sender
{
    if (_buttonView.frame.origin.y<510) {
        _bthBox.selected = YES;
        [UIView transitionWithView:_buttonView
                          duration:0.3
                           options:UIViewAnimationOptionCurveEaseInOut
                        animations:^{
                            _buttonView.frame = CGRectMake(0, 677, 1024, 204);
                        }
                        completion:nil];
        [UIView transitionWithView:_childContainer
                          duration:0.3
                           options:UIViewAnimationOptionCurveEaseInOut
                        animations:^{
                            _childContainer.frame = CGRectMake(20, 74, 986, 600);
                        }
                        completion:nil];
    }
    else {
        _bthBox.selected = NO;
        [UIView transitionWithView:_buttonView
                          duration:0.3
                           options:UIViewAnimationOptionCurveEaseInOut
                        animations:^{
                            _buttonView.frame = CGRectMake(0, 500, 1024, 204);
                        }
                        completion:nil];
        [UIView transitionWithView:_childContainer
                          duration:0.3
                           options:UIViewAnimationOptionCurveEaseInOut
                        animations:^{
                            _childContainer.frame = CGRectMake(20, 74, 986, 423);
                        }
                        completion:nil];
    }
}



- (IBAction)statisticsBtnTouched:(id)sender
{
    [self.navigationController pushViewController:[StatisticsMainViewController newInstance] animated:YES];
}

- (IBAction)caseBtnTouched:(id)sender
{
    [self.navigationController pushViewController:[CaseMainViewController newInstance] animated:YES];
}

- (IBAction)permitBtnTouched:(id)sender
{
    [self.navigationController pushViewController:[PermitMainViewController newInstance] animated:YES];
}
- (IBAction)roadEngrossBtnTouched:(id)sender
{
    [self.navigationController pushViewController:[RoadEngrossMainViewController newInstance] animated:YES];
}
- (IBAction)inspectionBtnTouched:(id)sender
{
    [self.navigationController pushViewController:[InspectionMainViewController newInstance] animated:YES];
}

- (IBAction)lawBtnTouched:(id)sender
{


    LawViewController * lawView =[[LawViewController alloc] init];
    [self.navigationController pushViewController:lawView animated:YES];
}

- (IBAction)syncBtnTouched:(id)sender
{
    DataSynViewController * dataSynView =[[DataSynViewController alloc] init];
    [self.navigationController pushViewController:dataSynView animated:YES];
}

- (IBAction)managementTouched:(id)sender
{
    PersonnelManagementViewController * managementView = [[PersonnelManagementViewController alloc] init];
    [self.navigationController pushViewController:managementView animated:YES];
}

#pragma mark - UITableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 37;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (_segListOption.selectedSegmentIndex) {
        case 0:{
            static NSString * MessCellIdentifier = @"MessCell";
            MessageCenterCell * cell = [tableView dequeueReusableCellWithIdentifier:MessCellIdentifier];
            if (cell == nil) {
                cell = [[MessageCenterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MessCellIdentifier];
            }
            [cell configureCellWithMessageArray:[_dataArray objectAtIndex:indexPath.row]];
			//不需要交互
			cell.userInteractionEnabled = NO; 
			//选中之后颜色不会变
			[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
            break;
        case 1:{
            static NSString * AnnCellIdentifier = @"AnnCell";
            AnnouncementsCell * cell = [tableView dequeueReusableCellWithIdentifier:AnnCellIdentifier];
            if (cell == nil) {
                cell = [[AnnouncementsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AnnCellIdentifier];
            }
            [cell configureCellWithOrgArticleArray:[_dataArray objectAtIndex:indexPath.row]];
            return cell;
        }
            break;
        case 2:{
			static NSString * CellIdentifier = @"Cell";
            MianPageListNameCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[MianPageListNameCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            [cell configureCellWithCaseArray:[_dataArray objectAtIndex:indexPath.row]];
            return cell;
        }
            break;
        default:
            break;
    }
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 37;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    switch (_segListOption.selectedSegmentIndex) {
        case 0:{
            MianPageListNameCell * view = [[MianPageListNameCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
           view.contentView.backgroundColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
            [view titleLabel];
            return view.contentView;
        }
            break;
        case 1:{
            AnnouncementsCell * view =[[AnnouncementsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            view.contentView.backgroundColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
            [view titleLabel];
            return view.contentView;
        }
            break;
        case 2:{
            MessageCenterCell * view =[[MessageCenterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            view.contentView.backgroundColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
            [view titleLabel];
            return view.contentView;
        }
            break;
        default:
            break;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (_segListOption.selectedSegmentIndex) {
        case 0:{

        }
            break;
        case 1:{
            AnnouncementsViewController * annViewController = [[ AnnouncementsViewController alloc] initWithNibName:@"AnnouncementsViewController" bundle:nil];
            OrgArticleModel * orgArticle = [_dataArray objectAtIndex:indexPath.row];
            annViewController.orgArticleModel =orgArticle;
            [[self.dataModelCenter webService] readSupervisionOrgArticle:orgArticle.identifier withAsyncHanlder:^(BOOL flg, NSError *err) {
				dispatch_sync(dispatch_get_main_queue(), ^{
					int count =[orgArticle.read_count intValue];
					orgArticle.read_count =[NSString stringWithFormat:@"%d",count + 1] ;
				});
            }];
            [self.navigationController pushViewController:annViewController animated:YES];
        }
            break;
        case 2:{
			TaskAgentsViewController * taskViewController = [[TaskAgentsViewController alloc]initWithNibName:@"TaskAgentsViewController" bundle:nil];
            CurrentTaskModel * currentTask = [_dataArray objectAtIndex:indexPath.row];
            taskViewController.currentModel =currentTask;
            [self.navigationController pushViewController:taskViewController animated:YES];
        }
            break;
        default:
            break;
    }
}
#pragma mark - Delegate Methods Implementation

- (void)loginSuccessfully
{
    [self hideLogin];
    
}
@end
