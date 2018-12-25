//
//  BasicDataViewController.h
//  GDZhiFaJianGuanSystem
//
//  Created by quxiuyun on 14-3-5.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmployeeInfoModel.h"

typedef enum {
    kAddNewRecord = 0,
    kNormalDesc
}DescState;

@interface BasicDataViewController : UIViewController<UITextFieldDelegate>

@property (nonatomic,retain)EmployeeInfoModel * basicDataModel;

@property (weak, nonatomic) IBOutlet UITextField *textOrg;
@property (weak, nonatomic) IBOutlet UITextField *textName;
@property (weak, nonatomic) IBOutlet UITextField *textAccount;
@property (weak, nonatomic) IBOutlet UITextField *textMobile;
@property (weak, nonatomic) IBOutlet UITextField *textSex;
@property (weak, nonatomic) IBOutlet UITextField *TextNation;
@property (weak, nonatomic) IBOutlet UITextField *textAcademic;
@property (weak, nonatomic) IBOutlet UITextField *textSpeciality;
@property (weak, nonatomic) IBOutlet UITextField *textTelephone;
@property (weak, nonatomic) IBOutlet UITextField *textDuty;

@property (weak, nonatomic) IBOutlet UITextField *textRoadwork_time;
@property (weak, nonatomic) IBOutlet UITextField *textResume;
@property (weak, nonatomic) IBOutlet UITextField *textRewards_punishments;
@property (weak, nonatomic) IBOutlet UITextField *textMemo;
@property (weak, nonatomic) IBOutlet UITextField *textOrderdesc;
@property (weak, nonatomic) IBOutlet UITextField *textQuality;
@property (weak, nonatomic) IBOutlet UITextField *textEmployee_code;

@property (weak, nonatomic) IBOutlet UITextField *textCardID;
@property (weak, nonatomic) IBOutlet UITextField *textBirthday;
@property (weak, nonatomic) IBOutlet UITextField *textNativePlace;
@property (weak, nonatomic) IBOutlet UITextField *textAppearance;
@property (weak, nonatomic) IBOutlet UITextField *textEmail;
@property (weak, nonatomic) IBOutlet UITextField *textWork_start_date;

@property (weak, nonatomic) IBOutlet UIImageView *imagePhoto;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property(nonatomic,retain)UITextField *currentTextField;


@property (assign, nonatomic) DescState descState;
@property (nonatomic,assign) BOOL canEdit;

//- (IBAction)saveButton:(UIButton *)sender;


@end
