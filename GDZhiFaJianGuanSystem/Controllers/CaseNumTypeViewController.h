//
//  CaseNumTypeViewController.h
//  GDZhiFaJianGuanSystem
//
//  Created by yu hongwu on 14-9-19.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CaseNumTypePickerDelegate;

@interface CaseNumTypeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *orgDataArray;
@property (nonatomic) BOOL shouldBack;

@property (weak, nonatomic) IBOutlet UITableView *listTableView;

@property (weak, nonatomic) IBOutlet UINavigationBar *orgNavigationBar;
@property (weak, nonatomic) IBOutlet UINavigationItem *orgNavigationItem;
- (IBAction)cancelButton:(UIBarButtonItem *)sender;
- (IBAction)saveButton:(UIBarButtonItem *)sender;
-(void)setDataArray;
-(void)setOrgDataArray;
@property (nonatomic,weak) id<CaseNumTypePickerDelegate> delegate;
@property (nonatomic,weak) UIPopoverController *pickerPopover;

@end

@protocol CaseNumTypePickerDelegate <NSObject>

-(void)setCaseNumType:(NSNumber *)page content:(NSString*)name;

@end