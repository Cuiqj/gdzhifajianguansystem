//
//  DateSelectController.m
//  GDZhiFaJianGuanSystem
//
//  Created by quxiuyun on 14-2-13.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import "YearQuarterSelectController.h"

@interface YearQuarterSelectController ()
@end

@implementation YearQuarterSelectController
@synthesize yearQuarterPicker = _yearQuarterPicker;
@synthesize delegate=_delegate;
@synthesize yearQuarterselectPopover= _yearQuarterselectPopover;


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

}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    if ([self.yearQuarterselectPopover isPopoverVisible]) {
        [self.yearQuarterselectPopover dismissPopoverAnimated:animated];
    }
    
    [super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}
//当用户点击选择的时候，则调用代理的方法
- (IBAction)btnSelect:(id)sender {
    [self.delegate setYearQuarter:self.yearQuarterPicker.yearStr quarter:self.yearQuarterPicker.quarterStr];
    [self.yearQuarterselectPopover dismissPopoverAnimated:YES];
}

- (IBAction)btnCancel:(id)sender {
    [self.yearQuarterselectPopover dismissPopoverAnimated:YES];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
