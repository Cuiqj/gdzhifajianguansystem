//
//  BasicDataViewController.m
//  GDZhiFaJianGuanSystem
//
//  Created by quxiuyun on 14-3-5.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import "BasicDataViewController.h"

@interface BasicDataViewController ()

@end

@implementation BasicDataViewController

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.descState = kAddNewRecord;
    
    UIBarButtonItem * backbutton =[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(backButton)];
    [self.navigationItem setLeftBarButtonItem:backbutton animated:YES];
    
    if (self.canEdit) {
        self.textOrg.userInteractionEnabled = self.canEdit;
        self.textName.userInteractionEnabled = self.canEdit;
        self.textAccount.userInteractionEnabled = self.canEdit;
        self.textMobile.userInteractionEnabled = self.canEdit;
        self.textSex.userInteractionEnabled = self.canEdit;
        self.TextNation.userInteractionEnabled = self.canEdit;
        self.textAcademic.userInteractionEnabled = self.canEdit;
        self.textSpeciality.userInteractionEnabled = self.canEdit;
        self.textTelephone.userInteractionEnabled = self.canEdit;
        self.textDuty.userInteractionEnabled = self.canEdit;
        
        self.textRoadwork_time.userInteractionEnabled = self.canEdit;
        self.textResume.userInteractionEnabled = self.canEdit;
        self.textRewards_punishments.userInteractionEnabled = self.canEdit;
        self.textMemo.userInteractionEnabled = self.canEdit;
        self.textOrderdesc.userInteractionEnabled = self.canEdit;
        self.textQuality.userInteractionEnabled = self.canEdit;
        self.textEmployee_code.userInteractionEnabled = self.canEdit;
        
        self.textCardID.userInteractionEnabled = self.canEdit;
        self.textBirthday.userInteractionEnabled = self.canEdit;
        self.textNativePlace.userInteractionEnabled = self.canEdit;
        self.textAppearance.userInteractionEnabled = self.canEdit;
        self.textEmail.userInteractionEnabled = self.canEdit;
        self.textWork_start_date.userInteractionEnabled = self.canEdit;

    }
    
    self.textOrg.text = self.basicDataModel.orderdesc;
    self.textOrg.delegate = self;
    self.textName.text =self.basicDataModel.name;
    self.textName.delegate = self;
    self.textAccount.text =self.basicDataModel.enforce_code;
    self.textAccount.delegate = self;
    self.textMobile.text =self.basicDataModel.mobile;
    self.textMobile.delegate = self;
    self.textSex.text =self.basicDataModel.sex;
    self.textSex.delegate = self;
    self.TextNation.text =self.basicDataModel.nation;
    self.TextNation.delegate = self;
    self.textAcademic.text =self.basicDataModel.academic;
    self.textAcademic.delegate = self;
    self.textSpeciality.text =self.basicDataModel.speciality;
    self.textSpeciality.delegate = self;
    self.textTelephone.text =self.basicDataModel.telephone;
    self.textTelephone.delegate = self;
    self.textDuty.text =self.basicDataModel.duty;
    self.textDuty.delegate = self;
    
    self.textRoadwork_time.text =self.basicDataModel.roadwork_time;
    self.textRoadwork_time.delegate = self;
    self.textResume.text =self.basicDataModel.resume;
    self.textResume.delegate = self;
    self.textRewards_punishments.text =self.basicDataModel.rewards_punishments;
    self.textRewards_punishments.delegate = self;
    
    
    self.textMemo.text =self.basicDataModel.memo;
    self.textMemo.delegate = self;
    self.textOrderdesc.text =self.basicDataModel.orderdesc;
    self.textOrderdesc.delegate = self;
    self.textQuality.text =self.basicDataModel.quality;
    self.textQuality.delegate = self;
    self.textEmployee_code.text =self.basicDataModel.employee_code;
    self.textQuality.delegate = self;

    self.textCardID.text =self.basicDataModel.cardID;
    self.textCardID.delegate = self;
    self.textBirthday.text =self.basicDataModel.birthday;//现在时nsdate
    self.textBirthday.delegate = self;
    self.textNativePlace.text =self.basicDataModel.nativePlace;
    self.textNativePlace.delegate = self;
    self.textAppearance.text =self.basicDataModel.appearance;
    self.textAppearance.delegate = self;
    self.textEmail.text =self.basicDataModel.email;
    self.textEmail.delegate = self;
    self.textWork_start_date.text =self.basicDataModel.work_start_date;
    self.textWork_start_date.delegate = self;
    
    [self.imagePhoto setImage:[UIImage imageNamed:self.basicDataModel.photo]];

    _scrollView.contentMode=UIViewContentModeLeft;
    _scrollView.bounces=NO;
    _scrollView.contentSize=CGSizeMake(1007, 632);
    _scrollView.contentInset=UIEdgeInsetsZero;
}

#pragma mark - IBActions

- (void)backButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.currentTextField = textField;
}

//软键盘隐藏，恢复左下scrollview位置
- (void)keyboardWillHide:(NSNotification *)aNotification{
    if (self.descState == kAddNewRecord) {
        [self.scrollView setContentSize:self.scrollView.frame.size];
    }
}

//软键盘出现，上移scrollview至左上，防止编辑界面被阻挡
- (void)keyboardWillShow:(NSNotification *)aNotification{
    if (self.descState == kAddNewRecord) {
        self.scrollView.contentOffset = CGPointMake(0, self.currentTextField.frame.origin.y + 100);
        [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width,self.scrollView.frame.size.height+self.currentTextField.frame.origin.y-200)];
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
