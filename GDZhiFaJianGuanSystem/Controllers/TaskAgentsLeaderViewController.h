//
//  TaskAgentsLeaderViewController.h
//  GDZhiFaJianGuanSystem
//
//  Created by quxiuyun on 14-2-24.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CurrentTaskModel.h"

// 领导人意见View
@interface TaskAgentsLeaderViewController : UIViewController<UITextViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) CurrentTaskModel * currentModel;
@property (weak, nonatomic) IBOutlet UITextView *textLeaderOpinion;
@property (weak, nonatomic) IBOutlet UITextField *textLeader;
@property (weak, nonatomic) IBOutlet UITextField *textSigningTime;
@property (weak, nonatomic) IBOutlet UITextField *textPromoterOpinion;
@property (weak, nonatomic) IBOutlet UITextField *textReviewerComments;
@property (weak, nonatomic) IBOutlet UITextField *textResponsible;


- (IBAction)taskTime:(UITextField *)sender;
- (IBAction)submit:(UIButton *)sender;
- (IBAction)staging:(UIButton *)sender;

@end
