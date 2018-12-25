//
//  BBSViewController.h
//  GDZhiFaJianGuanSystem
//
//  Created by yu hongwu on 14-10-13.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBSViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *webView;
+ (instancetype)newInstance;
@end
