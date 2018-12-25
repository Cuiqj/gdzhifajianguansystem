//
//  LoginViewController.m
//  GDZhiFaJianGuanSystem
//
//  Created by XU SHIWEN on 14-2-8.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import "LoginViewController.h"
#import "DataModelCenter.h"
#import "MainPageViewController.h"
#import "MBProgressHUD.h"
@interface LoginViewController ()
@property (nonatomic,retain) NSString *loginUserID;
@property (nonatomic,assign) NSInteger touchTextTag;
@property (nonatomic,retain) UIPopoverController *pickerPopover;
@property (nonatomic,weak)WebServiceHandler *webService;
@property (nonatomic, strong) DataModelCenter *dataModelCenter;
@property (nonatomic, retain) NSMutableArray * dataArray;
@end

@implementation LoginViewController{
	MBProgressHUD *hud;
}
@synthesize textUser;
@synthesize textPassword;
@synthesize loginUserID = _loginUserID;
@synthesize touchTextTag = _touchTextTag;

+ (instancetype)newInstance
{
    return [[[self alloc] initWithNibName:@"LoginView" bundle:nil] prepareForUse];
}

- (id)prepareForUse
{
    //在这里完成一些内部参数的初始化
    self.dataModelCenter = [DataModelCenter defaultCenter];
    _dataArray =[[NSMutableArray alloc] init];
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	[self.dataModelCenter.webService.queue cancelAllOperations];
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated
{
	
    [super viewWillDisappear:animated];
    if ([self.pickerPopover isPopoverVisible]) {
        [self.pickerPopover dismissPopoverAnimated:animated];
    }
   
}

- (void)viewDidLoad
{
	[self.dataModelCenter.webService.queue cancelAllOperations];
    [super viewDidLoad];
    BOOL isRe = [[NSUserDefaults standardUserDefaults]boolForKey:ISREMEMBERED];
    self.passwordSwitch.on = isRe;
    if (isRe){
        self.textUser.text = [[NSUserDefaults standardUserDefaults] objectForKey:USERKEY];
        self.textPassword.text = [[NSUserDefaults standardUserDefaults] objectForKey:USERPASSWORD];
    }
	// Do any additional setup after loading the view.
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

#pragma mark - IBActions
- (IBAction)switchRememberPassword:(id)sender
{
    UISwitch *switchButton = (UISwitch *)sender;
    [[NSUserDefaults standardUserDefaults] setBool:switchButton.isOn forKey:ISREMEMBERED];
//    [[NSUserDefaults standardUserDefaults] setValue:self.loginUserID forKey:USERKEY];
//    [[NSUserDefaults standardUserDefaults] synchronize];//同步到文件里
}

- (IBAction)btnOK:(UIBarButtonItem *)sender
{
    NSString * name = self.textUser.text;
    NSString * password = self.textPassword.text;
    if (name.length < 1 || password.length < 1) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"错误" message:@"用户名或密码错误!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    } else {
        [self.dataModelCenter loginWithName:name andPwd:password andResult:^(BOOL success, NSError *err){
                if (success)
                {
                    if ([self.passwordSwitch isOn]) {
                        [[NSUserDefaults standardUserDefaults] setValue:name forKey:USERKEY];
                        [[NSUserDefaults standardUserDefaults] setValue:password forKey:USERPASSWORD];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    } else {
                        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:USERKEY];
                        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:USERPASSWORD];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }

					
//					dispatch_sync(dispatch_get_main_queue(), ^{
//						hud = [[MBProgressHUD alloc] initWithView:self.view];
//						[self.view addSubview:hud];
//						
//						//如果设置此属性则当前的view置于后台
//						hud.dimBackground = YES;
//						
//						//设置对话框文字
//						hud.labelText = @"正在下载基础数据，请稍等...";
//						[(MainPageViewController*)self.target setSettingDisable];
//						[hud show:YES];
//					});
//					//当登录成功之后第一件申请就是清除基础数据 加载基础数据
//					[self.dataModelCenter clearLocalData];
//					[self.dataModelCenter syncLocalData];
					

					

					[[self.dataModelCenter webService] getSupervisionMessageList:@"1" withAsyncHanlder:^(NSArray *messageList, NSError *err) {
						dispatch_sync(dispatch_get_main_queue(), ^{
							[_dataArray removeAllObjects];
							[_dataArray addObjectsFromArray:messageList];
							if (self.target && self.action) {
								[(MainPageViewController*)self.target dismissLoginView:_dataArray];
								[hud removeFromSuperview];
								
							}
						});
					}];
                }else{
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"错误" message:@"用户名或密码错误!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                    [[self.dataModelCenter webService] getSupervisionMessageList:@"1" withAsyncHanlder:^(NSArray *messageList, NSError *err) {
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            [_dataArray removeAllObjects];
                            [_dataArray addObjectsFromArray:messageList];
                            if (self.target && self.action) {
                                [(MainPageViewController*)self.target dismissLoginView:_dataArray];
                                [hud removeFromSuperview];
                                
                            }
                        });
                    }];
                }
        }];
        
    }
    // 请求服务器, 验证用户信息
    [self.textUser resignFirstResponder];
    [self.textPassword resignFirstResponder];
}

- (void)addMyTarget:(MainPageViewController*)target action:(SEL)action
{
    self.target = target;
    self.action = action;
}

- (IBAction)userName:(UITextField *)sender
{
    //    if ((self.touchTextTag == sender.tag) && ([self.pickerPopover isPopoverVisible])) {
    //        [self.pickerPopover dismissPopoverAnimated:YES];
    //    } else {
    //        self.touchTextTag=sender.tag;
    //        UserPickerViewController *acPicker=[[UserPickerViewController alloc] init];
    //        acPicker.delegate=self;
    //        self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:acPicker];
    //        [self.pickerPopover setPopoverContentSize:CGSizeMake(140, 200)];
    //        [self.pickerPopover presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    //        acPicker.pickerPopover=self.pickerPopover;
    //    }
}

- (IBAction)userPassword:(UITextField *)sender
{
    textPassword.secureTextEntry = YES;//加密
}

- (IBAction)textFiledReturnEditing:(id)sender
{
     [sender resignFirstResponder];
}

- (void)setUser:(EmployeeInfoModel *)userInfo{
    if (self.touchTextTag==10) {
        self.loginUserID=userInfo.identifier;
    }
    [(UITextField *)[self.view viewWithTag:self.touchTextTag] setText:userInfo.name];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
