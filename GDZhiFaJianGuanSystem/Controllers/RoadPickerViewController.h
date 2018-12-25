//
//  CasePermitPickerViewController.h
//  GDZhiFaJianGuanSystem
//
//  Created by quxiuyun on 14-2-27.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import <UIKit/UIKit.h>
NSMutableArray *roadList;
@protocol RoadPickerDelegate <NSObject>

@optional
-(void)setRoadIdDelegate:(NSString *)name withNumber:(NSString *)number;


@end

@interface RoadPickerViewController : UITableViewController


@property (weak,nonatomic) UIPopoverController *pickerPopover;
@property (nonatomic,weak) id<RoadPickerDelegate> delegate;

@end
