//
//  DateSelectController.h
//  GDZhiFaJianGuanSystem
//
//  Created by quxiuyun on 14-2-13.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DatetimePickerHandler;

@interface DateSelectController : UIViewController

@property (nonatomic,weak) IBOutlet UIDatePicker *datePicker;
- (IBAction)btnSave:(id)sender;
//取消按钮不是单单就是关闭日期选择窗口，还包括清楚文本框
- (IBAction)btnCancel:(id)sender;
- (void)showdate:(NSString *)date;
@property (weak,nonatomic) id<DatetimePickerHandler> delegate;
@property (copy,nonatomic) NSString *datefrom;
@property (weak,nonatomic)UIPopoverController *dateselectPopover;
//时间选择器类型标识，为0时只选择日期，为1时可选择日期和具体时间
@property (assign,nonatomic) NSInteger pickerType;

@end

@protocol DatetimePickerHandler <NSObject>
-(void)setDate:(NSString *)date;

@end
