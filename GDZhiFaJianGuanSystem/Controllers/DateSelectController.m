//
//  DateSelectController.m
//  GDZhiFaJianGuanSystem
//
//  Created by quxiuyun on 14-2-13.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import "DateSelectController.h"

@interface DateSelectController ()
@property (nonatomic,readonly) NSDateFormatter *formatter;
@end

@implementation DateSelectController
@synthesize datePicker=_datePicker;
@synthesize delegate=_delegate;
@synthesize datefrom=_datefrom;
@synthesize formatter=_formatter;
@synthesize dateselectPopover=_dateselectPopover;
//时间选择器类型标识，为0时只选择日期，为1时可选择日期和具体时间
@synthesize pickerType=_pickerType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
        if ( IOS7_OR_LATER )
        {
            self.edgesForExtendedLayout = UIRectEdgeNone;
            self.extendedLayoutIncludesOpaqueBars = NO;
            self.modalPresentationCapturesStatusBarAppearance = NO;
        }
#endif // #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)setPickerType:(NSInteger)pickerType
{
    _pickerType = pickerType;
    
    if (self.formatter==nil) {
        _formatter=[[NSDateFormatter alloc] init];
        [self.formatter setLocale:[NSLocale currentLocale]];
    }
    
    if (_pickerType==0) { // day
        _datePicker.datePickerMode=UIDatePickerModeDate;
        [_datePicker setTimeZone:[NSTimeZone localTimeZone]];
        [_formatter setDateFormat : @"yyyy-MM-dd"];
    } else if (_pickerType==1) { // month
        _datePicker.datePickerMode=UIDatePickerModeDate;
        [_datePicker setTimeZone:[NSTimeZone localTimeZone]];
        [_formatter setDateFormat:@"yyyy-MM-dd"];
    } else if (_pickerType==2) { // year
        _datePicker.datePickerMode=UIDatePickerModeDate;
        [_datePicker setTimeZone:[NSTimeZone localTimeZone]];
        [_formatter setDateFormat : @"yyyy-MM-dd"];
    }
    
    if (self.datefrom ==nil) {
        [_formatter setDateFormat : @"yyyy-MM-dd"];
        NSDate *datenew=[NSDate date];
        [self.datePicker setDate:datenew];
    }else{
        [_formatter setDateFormat : @"yyyy-MM-dd"];
        NSDate *dateTime = [self.formatter dateFromString:_datefrom];
        if (dateTime==nil) {
            dateTime=[NSDate date];
        }
        [self.datePicker setDate:dateTime];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    if ([self.dateselectPopover isPopoverVisible]) {
        [self.dateselectPopover dismissPopoverAnimated:animated];
    }
    
    [super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (IBAction)btnSave:(id)sender {
    [self.delegate setDate:[self.formatter stringFromDate:[self.datePicker date]]];
    NSLog(@"- %@ - %@",[self.formatter stringFromDate:[self.datePicker date]],self.delegate);
    [self.dateselectPopover dismissPopoverAnimated:YES];
}


- (IBAction)btnCancel:(id)sender {
	[self.delegate setDate:@""];
    [self.dateselectPopover dismissPopoverAnimated:YES];
}

-(void)showdate:(NSString *)date{
    self.datefrom=date;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
