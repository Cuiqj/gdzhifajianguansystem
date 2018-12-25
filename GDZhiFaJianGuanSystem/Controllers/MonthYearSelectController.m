//
//  DateSelectController.m
//  GDZhiFaJianGuanSystem
//
//  Created by quxiuyun on 14-2-13.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import "MonthYearSelectController.h"

@interface MonthYearSelectController ()
@property (nonatomic,readonly) NSDateFormatter *formatter;
@end

@implementation MonthYearSelectController
@synthesize monthYearPicker = _monthYearPicker;
@synthesize delegate=_delegate;
@synthesize monthYearselectPopover=_monthYearselectPopover;


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

	[self.formatter setDateFormat : @"yyyy年MM月"];
	_monthYearPicker.yearFirst = YES;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    if ([self.monthYearselectPopover isPopoverVisible]) {
        [self.monthYearselectPopover dismissPopoverAnimated:animated];
    }
    
    [super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}
//当用户点击选择的时候，则调用代理的方法
- (IBAction)btnSelect:(id)sender {
    [self.delegate setDate:[self.monthYearPicker date]];
    [self.monthYearselectPopover dismissPopoverAnimated:YES];
}

- (IBAction)btnCancel:(id)sender {
    [self.monthYearselectPopover dismissPopoverAnimated:YES];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
