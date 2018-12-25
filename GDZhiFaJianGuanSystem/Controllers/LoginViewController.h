//
//  LoginViewController.h
//  GDZhiFaJianGuanSystem
//
//  Created by XU SHIWEN on 14-2-8.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserPickerViewController.h" 

@protocol LoginDelegate <NSObject>

- (void)loginSuccessfully;

@end

@interface LoginViewController : UIViewController<UITextFieldDelegate,UserPickerDelegate>

@property (weak, nonatomic) IBOutlet UISwitch *passwordSwitch;
@property (weak, nonatomic) IBOutlet UITextField *textUser;
@property (weak, nonatomic) IBOutlet UITextField *textPassword;
@property (weak, nonatomic) id<LoginDelegate> delegate;
@property (weak, nonatomic) id target;
@property (nonatomic) SEL action;

- (void)addMyTarget:(id)target action:(SEL)action;

+ (instancetype)newInstance;

- (IBAction)switchRememberPassword:(id)sender;
- (IBAction)btnOK:(UIBarButtonItem *)sender;
- (IBAction)userName:(UITextField *)sender;
- (IBAction)userPassword:(UITextField *)sender;

//轻触 Return 关闭键盘(Did End On Exit)
- (IBAction)textFiledReturnEditing:(id)sender;


@end
