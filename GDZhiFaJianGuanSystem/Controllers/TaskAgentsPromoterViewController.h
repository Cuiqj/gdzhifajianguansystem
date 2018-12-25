//
//  TaskAgentsPromoterViewController.h
//  GDZhiFaJianGuanSystem
//
//  Created by quxiuyun on 14-2-24.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CurrentTaskModel.h"

//承办人意见View
@interface TaskAgentsPromoterViewController : UIViewController<UITextViewDelegate,UITextFieldDelegate>

@property (strong, nonatomic) CurrentTaskModel * currentModel;
@property (weak, nonatomic) IBOutlet UITextView *textPromoterOpinion;
@property (weak, nonatomic) IBOutlet UITextField *textPromoter;
@property (weak, nonatomic) IBOutlet UITextField *textSigningEvent;
@property (weak, nonatomic) IBOutlet UITextField *textResponsible;

- (IBAction)taskTime:(UITextField *)sender;
- (IBAction)submit:(UIButton *)sender;
- (IBAction)staging:(UIButton *)sender;


@end
