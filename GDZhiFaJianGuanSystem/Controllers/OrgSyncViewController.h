//
//  OrgSyncViewController.h
//  GDZhiFaJianGuanSystem
//
//  Created by quxiuyun on 14-2-11.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebServiceHandler.h"
#import "OrgInfoSimpleModel.h"
#import "TBXML.h"

@protocol OrgSetDelegate;

@interface OrgSyncViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,WebServiceHandlerDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableOrgList;
@property (weak, nonatomic) IBOutlet UITextField *textServerAddress;
@property (weak, nonatomic) id<OrgSetDelegate> delegate;
- (IBAction)showServerAddress:(UIBarButtonItem *)sender;
- (IBAction)setCurrentOrg:(UIBarButtonItem *)sender;

@end

@protocol OrgSetDelegate <NSObject>

- (void)pushLoginView;
@end