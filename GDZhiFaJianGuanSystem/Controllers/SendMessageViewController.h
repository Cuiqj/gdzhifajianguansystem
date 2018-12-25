//
//  SendMessageViewController.h
//  GDZhiFaJianGuanSystem
//
//  Created by quxiuyun on 14-3-12.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    kAddNewRecord = 0,
    kNormalDesc
}DescState;

//发送消息界面
@interface SendMessageViewController : UIViewController<UITextViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *textRecipient;
@property (weak, nonatomic) IBOutlet UITextField *textTitle;
@property (weak, nonatomic) IBOutlet UITextView *textContent;

@property(nonatomic,weak) id currentTextView;
@property (assign, nonatomic) DescState descState;
@property (nonatomic,assign) BOOL canEdit;

- (IBAction)btnSend:(UIButton *)sender;
- (IBAction)textRecipient:(UITextField *)sender;



@end
