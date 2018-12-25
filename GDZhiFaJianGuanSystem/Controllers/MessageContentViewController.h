//
//  MessageContentViewController.h
//  GDZhiFaJianGuanSystem
//
//  Created by quxiuyun on 14-3-12.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"

//点击每条消息进入的详细界面
@interface MessageContentViewController : UIViewController

@property (nonatomic, strong)MessageModel * messageModel;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelSender;
@property (weak, nonatomic) IBOutlet UILabel *labelSenderTime;

@property (weak, nonatomic) IBOutlet UITextView *textContent;



@end
