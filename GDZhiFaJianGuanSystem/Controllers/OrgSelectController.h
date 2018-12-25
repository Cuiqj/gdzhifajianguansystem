//
//  OrgSelectController.h
//  GDZhiFaJianGuanSystem
//
//  Created by quxiuyun on 14-2-20.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OrgPickerDelegate;

@interface OrgSelectController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) NSArray *orgDataArray;
@property (nonatomic) BOOL shouldBack;

@property (weak, nonatomic) IBOutlet UITableView *listTableView;

@property (weak, nonatomic) IBOutlet UINavigationBar *orgNavigationBar;
@property (weak, nonatomic) IBOutlet UINavigationItem *orgNavigationItem;
- (IBAction)cancelButton:(UIBarButtonItem *)sender;
- (IBAction)saveButton:(UIBarButtonItem *)sender;

@property (nonatomic,weak) id<OrgPickerDelegate> delegate;
@property (nonatomic,weak) UIPopoverController *pickerPopover;

@end

@protocol OrgPickerDelegate <NSObject>

-(void)setOrgID:(NSString *)identifier withOrgName:(NSString *)orgName;

@end