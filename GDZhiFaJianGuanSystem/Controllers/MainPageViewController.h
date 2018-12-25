//
//  MainPageViewController.h
//  GDZhiFaJianGuanSystem
//
//  Created by XU SHIWEN on 14-2-7.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LoginViewController;
@class WorkBenchViewController;
@class SettingViewController;
#import "SettingViewController.h"

@interface MainPageViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,SettingDelegate>

@property (weak, nonatomic) IBOutlet UIButton * bthBox;
@property (weak, nonatomic) IBOutlet UIView * childContainer;
@property (weak, nonatomic) IBOutlet UIView * buttonContainer;
@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (weak, nonatomic) IBOutlet UITableView *tvTaskList;
@property (weak, nonatomic) IBOutlet UISegmentedControl * segListOption;
@property (strong, nonatomic) WorkBenchViewController * workBenchController;
@property (strong, nonatomic) LoginViewController * loginController;
@property (strong, nonatomic) SettingViewController * settingController;
//@property(assign,atomic)BOOL canDownloadData;   //现在是否可以下载数据，默认在一个网络请求未结束时，为NO，不允许其他网络请求


+ (instancetype)newInstance;

- (IBAction)boxUp:(id)sender;
- (IBAction)listOption:(id)sender;
- (IBAction)statisticsBtnTouched:(id)sender;
- (IBAction)caseBtnTouched:(id)sender;
- (IBAction)permitBtnTouched:(id)sender;
- (IBAction)roadEngrossBtnTouched:(id)sender;
- (IBAction)inspectionBtnTouched:(id)sender;
- (IBAction)lawBtnTouched:(id)sender;
- (IBAction)syncBtnTouched:(id)sender;
- (IBAction)managementTouched:(id)sender;
- (void)dismissLoginView:(NSArray *)dataList;
- (void)dismissSettingView;
//设置左边的设置按钮不可点击(当后台在进行登录操作的时候，前台就不允许进行设置操作)
- (void)setSettingDisable;
@end
