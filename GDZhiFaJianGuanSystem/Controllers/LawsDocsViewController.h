//
//  LawsDocsViewController.h
//  GDZhiFaJianGuanSystem
//
//  Created by quxiuyun on 14-2-20.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LawsDocsViewController : UIViewController

- (void)showTableView:(BOOL)visible;
- (void)showWebView:(BOOL)visible;
- (void)loadTableData:(id)data;
- (void)loadWebData:(NSURL *)url;

@end
