//
//  PersonnelManagementViewController.h
//  GDZhiFaJianGuanSystem
//
//  Created by quxiuyun on 14-3-4.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrgSelectController.h"
#import "CollapseCell.h"

@interface PersonnelManagementViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,OrgPickerDelegate,UIPopoverControllerDelegate,CollapseCellDelegate>

@property (strong, nonatomic)  UITableView *tableManagementList;
@property (weak, nonatomic) IBOutlet UIView *queryView;
@property (weak, nonatomic) IBOutlet UILabel *labelPageNumber;
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *textOrg;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;




- (IBAction)queryOptions:(UIButton *)sender;

@end
