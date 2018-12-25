//
//  PageInfoViewController.m
//  GDZhiFaJianGuanSystem
//
//  Created by quxiuyun on 14-2-18.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import "PageInfoViewController.h"

@interface PageInfoViewController ()

@end

@implementation PageInfoViewController

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
    _bianHaoTextField.userInteractionEnabled= NO;
    _app_dateTextField.userInteractionEnabled= NO;
    _reasonTextField.userInteractionEnabled= NO;
    _reason_detailTF.userInteractionEnabled= NO;
    _addressTF.userInteractionEnabled= NO;
    _startTimeTF.userInteractionEnabled= NO;
    _dateCut.userInteractionEnabled= NO;
    _timeOutTF.userInteractionEnabled= NO;
    _admissibleAddressTF.userInteractionEnabled= NO;
    _applicant_nameTF.userInteractionEnabled= NO;
    _zhengjianTF.userInteractionEnabled= NO;
    _cardNumTF.userInteractionEnabled= NO;
    _legal_spokesmanTF.userInteractionEnabled= NO;
    _applicant_addressTF.userInteractionEnabled= NO;
    _youzhengTF.userInteractionEnabled= NO;
    _telephoneTF.userInteractionEnabled= NO;
    _phoneTF.userInteractionEnabled= NO;
    _emailTF.userInteractionEnabled= NO;
    _qingdanTF.userInteractionEnabled= NO;
    _changbanNameTF.userInteractionEnabled= NO;
    _chengbanInfo.userInteractionEnabled= NO;
    _shenhe1TF.userInteractionEnabled= NO;
    _shenheInfo1.userInteractionEnabled= NO;
    _shennhe2.userInteractionEnabled= NO;
    _shenheInfo2.userInteractionEnabled= NO;
    _limitTF.userInteractionEnabled= NO;
    _quanzong_notf.userInteractionEnabled= NO;
    _anjuan_noTF.userInteractionEnabled= NO;
    _baomi_typeTF.userInteractionEnabled= NO;
    _danganshi_noTF.userInteractionEnabled= NO;
    _paysumTF.userInteractionEnabled= NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
