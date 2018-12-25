//
//  DataSynViewController.h
//  GDZhiFaJianGuanSystem
//
//  Created by quxiuyun on 14-2-24.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import <UIKit/UIKit.h>

//数据同步ViewController
@interface DataSynViewController : UIViewController<UIAlertViewDelegate>

- (IBAction)btnUpLoadData:(UIButton *)sender;

- (IBAction)btnCheckUpdate:(UIButton *)sender;

- (IBAction)btnMessageCenter:(UIButton *)sender;
- (IBAction)btnUpdateData:(UIButton *)sender;
@end
