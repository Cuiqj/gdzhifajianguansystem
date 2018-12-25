//
//  DateSelectController.m
//  GDZhiFaJianGuanSystem
//
//  Created by quxiuyun on 14-2-13.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import "YearSelectController.h"

@interface YearSelectController ()
@end

@implementation YearSelectController
@synthesize yearPicker = _yearPicker;
@synthesize delegate=_delegate;
@synthesize yearSelectPopover= _yearSelectPopover;


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
    if ([self.yearSelectPopover isPopoverVisible]) {
        [self.yearSelectPopover dismissPopoverAnimated:animated];
    }
    
    [super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}
//当用户点击选择的时候，则调用代理的方法
- (IBAction)btnSelect:(id)sender {
    [self.delegate setPickerYear:self.yearPicker.yearStr];
    [self.yearSelectPopover dismissPopoverAnimated:YES];
}

- (IBAction)btnCancel:(id)sender {
    [self.yearSelectPopover dismissPopoverAnimated:YES];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
