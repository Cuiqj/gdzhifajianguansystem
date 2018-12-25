//
//  DateSelectController.h
//  GDZhiFaJianGuanSystem
//
//  Created by quxiuyun on 14-2-13.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SRMonthPicker.h"

@protocol MonthYearSelectDelegate;

@interface MonthYearSelectController : UIViewController

@property (nonatomic,weak) IBOutlet SRMonthPicker *monthYearPicker;
- (IBAction)btnSelect:(id)sender;
- (IBAction)btnCancel:(id)sender;
@property (weak,nonatomic) id<MonthYearSelectDelegate> delegate;
@property (weak,nonatomic)UIPopoverController *monthYearselectPopover;

@end

@protocol MonthYearSelectDelegate <NSObject>
-(void)setDate:(NSDate *)date;

@end
