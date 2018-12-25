//
//  DateSelectController.h
//  GDZhiFaJianGuanSystem
//
//  Created by quxiuyun on 14-2-13.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SRYearPicker.h"

@protocol YearSelectDelegate;

@interface YearSelectController : UIViewController

@property (nonatomic,weak) IBOutlet SRYearPicker *yearPicker;
- (IBAction)btnSelect:(id)sender;
- (IBAction)btnCancel:(id)sender;
@property (weak,nonatomic) id<YearSelectDelegate> delegate;
@property (weak,nonatomic)UIPopoverController *yearSelectPopover;

@end

@protocol YearSelectDelegate <NSObject>
-(void)setPickerYear:(NSString *)year;

@end
