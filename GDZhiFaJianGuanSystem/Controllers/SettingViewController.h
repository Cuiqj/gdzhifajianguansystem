//
//  LoginViewController.h
//  GDZhiFaJianGuanSystem
//
//  Created by XU SHIWEN on 14-2-8.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SettingDelegate <NSObject>

- (void)settingSuccessfully;

@end

@interface SettingViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textServer;
@property (weak, nonatomic) id<SettingDelegate> delegate;
@property (weak, nonatomic) id target;
@property (nonatomic) SEL action;

- (void)addMyTarget:(id)target action:(SEL)action;

+ (instancetype)newInstance;

- (IBAction)btnSave:(UIBarButtonItem *)sender;

//轻触 Return 关闭键盘(Did End On Exit)
- (IBAction)textFiledReturnEditing:(id)sender;


@end
