//
//  MessageContentViewController.m
//  GDZhiFaJianGuanSystem
//
//  Created by quxiuyun on 14-3-12.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import "MessageContentViewController.h"

@interface MessageContentViewController ()

@end

@implementation MessageContentViewController

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
    [self setTitle:@"消息内容"];
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem * backbutton =[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(backButton)];
    [self.navigationItem setLeftBarButtonItem:backbutton animated:YES];
    
    [self.labelTitle setText:self.messageModel.title];
    [self.labelSender setText:self.messageModel.sender_name];
    [self.labelSenderTime setText:self.messageModel.send_date];
    [self.textContent setText:self.messageModel.content];
    _textContent.userInteractionEnabled= NO;
}

#pragma mark - IBActions

- (void)backButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
