//
//  UserPickerViewController.h
//  GDZhiFaJianGuanSystem
//
//  Created by quxiuyun on 14-2-12.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol UserPickerDelegate;

@interface UserPickerViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *userDataArray;

@property (nonatomic,weak) id<UserPickerDelegate> delegate;
@property (nonatomic,weak) UIPopoverController *pickerPopover;

@end

@protocol UserPickerDelegate <NSObject>

-(void)setUser:(id)userInfo;


@end