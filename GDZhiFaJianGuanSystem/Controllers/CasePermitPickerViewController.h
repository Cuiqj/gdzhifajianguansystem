//
//  CasePermitPickerViewController.h
//  GDZhiFaJianGuanSystem
//
//  Created by quxiuyun on 14-2-27.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CasePermitHandler.h"

@interface CasePermitPickerViewController : UITableViewController


@property (weak,nonatomic) UIPopoverController *pickerPopover;
@property (nonatomic,assign) NSInteger pickerType;
@property (nonatomic,weak) id<CasePermitHandler> delegate;

@end
