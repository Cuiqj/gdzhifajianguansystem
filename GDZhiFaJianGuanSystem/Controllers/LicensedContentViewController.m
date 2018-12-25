//
//  LicensedContentViewController.m
//  GDZhiFaJianGuanSystem
//
//  Created by quxiuyun on 14-2-24.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import "LicensedContentViewController.h"

@interface LicensedContentViewController ()

@end

@implementation LicensedContentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [_textLicenseNum setText:self.currentModel.app_no];
    NSLog(@"--------%@",self.currentModel.app_no);
    _textLicenseNum.userInteractionEnabled= NO;
    _textLicenseReason.userInteractionEnabled= NO;
    _textLicenseMatters.userInteractionEnabled= NO;
    _textSpecificAdd.userInteractionEnabled= NO;
    _textTimeLimitOne.userInteractionEnabled= NO;
    [_textTimeLimitSecond setText:self.currentModel.date_cut];
    _textTimeLimitSecond.userInteractionEnabled= NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
