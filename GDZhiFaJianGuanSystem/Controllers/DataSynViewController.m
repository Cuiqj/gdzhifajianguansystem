//
//  DataSynViewController.m
//  GDZhiFaJianGuanSystem
//
//  Created by quxiuyun on 14-2-24.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import "DataSynViewController.h"
#import "DataModelCenter.h"
#import "MessageCenterViewController.h"
#import "AppUtil.h"
#import "MBProgressHUD.h"


//定义重设机构提示窗口tag
static NSInteger const resetOrgAlertTag = 1001;
static NSInteger const updateDataAlertTag = 1002;
@interface DataSynViewController ()
@property (nonatomic, retain) UIAlertView *alert;
@property (nonatomic, assign) DataModelCenter *dataModelCenter;
@end

@implementation DataSynViewController{
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
    }
    return self;
}

- (void)viewDidLoad
{
	[[[DataModelCenter defaultCenter] webService].queue cancelAllOperations];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem * backbutton =[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(backButton)];
    [self.navigationItem setLeftBarButtonItem:backbutton animated:YES];


}

#pragma mark - IBActions

- (void)backButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnUpLoadData:(UIButton *)sender
{
    NSManagedObjectContext *context=[MYAPPDELEGATE managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"AppSignModel" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (AppSignModel * appSign in fetchedObjects) {
        [[self.dataModelCenter webService] uploadSupervisionSign:appSign withAsyncHanlder:^(BOOL flg, NSError *err) {
			dispatch_sync(dispatch_get_main_queue(), ^{
				if (flg == 0) {
					
				}else{
					UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"成功上传业务数据！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil ];
					alert.tag = resetOrgAlertTag;
					[alert show];
				}
			});
        }];
    }
}

- (IBAction)btnCheckUpdate:(UIButton *)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告！" message:@"是否清除本地缓存？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil ];
    alert.tag = resetOrgAlertTag;
    [alert show];
}
- (IBAction)btnUpdateData:(UIButton *)sender{

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告！" message:@"是否更新基础数据？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil ];
    alert.tag = updateDataAlertTag;
    [alert show];
}
- (IBAction)btnMessageCenter:(UIButton *)sender
{
    MessageCenterViewController * messageCenterView = [[MessageCenterViewController alloc] init];
    [self.navigationController pushViewController:messageCenterView animated:YES];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	
    switch (alertView.tag) {
        case resetOrgAlertTag:
        {
            if (buttonIndex == 1) {
				
				// Should be initialized with the windows frame so the HUD disables all user input by covering the entire screen
				hud = [[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
				
				// Add HUD to screen
				[self.view.window addSubview:hud];
				
				// Register for HUD callbacks so we can remove it from the window at the right time
				hud.delegate = self;
				
				hud.labelText = NSLocalizedString(@"正在清空本地缓存", nil);
				hud.detailsLabelText = NSLocalizedString(@"请稍等...", nil);
				
				// Show the HUD while the provided method executes in a new thread
				[hud showWhileExecuting:@selector(clearLocalData) onTarget:self withObject:nil animated:YES];
				
				

            }
        }
            break;
		case updateDataAlertTag:
        {
			if (buttonIndex == 1) {
				// Should be initialized with the windows frame so the HUD disables all user input by covering the entire screen
				hud = [[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
				
				// Add HUD to screen
				[self.view.window addSubview:hud];
				
				// Register for HUD callbacks so we can remove it from the window at the right time
				hud.delegate = self;
				
				hud.labelText = NSLocalizedString(@"正在下载基础数据", nil);
				hud.detailsLabelText = NSLocalizedString(@"请稍等...", nil);
				
				// Show the HUD while the provided method executes in a new thread
				[hud showWhileExecuting:@selector(updateData) onTarget:self withObject:nil animated:YES];
				
				
			}
        }
        default:
            break;
    }
}
- (void)updateData{
	[[NSUserDefaults standardUserDefaults] synchronize];
	[self.dataModelCenter clearLocalData];
	[self.dataModelCenter syncLocalData];
	[hud removeFromSuperview];
	[self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)clearLocalData{
	[[NSUserDefaults standardUserDefaults] synchronize];
	[self.dataModelCenter clearLocalData];
	[self.dataModelCenter syncLocalData];
	[self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)hudWasHidden {
    // Remove HUD from screen
    [hud removeFromSuperview];
	
    // add here the code you may need
	
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
