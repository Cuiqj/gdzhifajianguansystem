//
//  DateSelectController.h
//  GDZhiFaJianGuanSystem
//
//  Created by quxiuyun on 14-2-13.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SRYearQuarterPicker.h"

@protocol YearQuarterSelectDelegate;

@interface YearQuarterSelectController : UIViewController

@property (nonatomic,weak) IBOutlet SRYearQuarterPicker *yearQuarterPicker;
- (IBAction)btnSelect:(id)sender;
- (IBAction)btnCancel:(id)sender;
@property (weak,nonatomic) id<YearQuarterSelectDelegate> delegate;
@property (weak,nonatomic)UIPopoverController *yearQuarterselectPopover;

@end

@protocol YearQuarterSelectDelegate <NSObject>
-(void)setYearQuarter:(NSString *)year  quarter:(NSString*)quarter;

@end
