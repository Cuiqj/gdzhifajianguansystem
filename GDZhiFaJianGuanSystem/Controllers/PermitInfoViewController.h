//
//  PermitInfoViewController.h
//  GDZhiFaJianGuanSystem
//
//  Created by quxiuyun on 14-2-18.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageInfoViewController.h"
#import "AllPermitModel.h"
//许可查询ViewController的许可信息
@interface PermitInfoViewController : UIViewController<UIScrollViewDelegate,UIWebViewDelegate>


@property (nonatomic,strong)PageInfoViewController * pageInfoVC;
@property (nonatomic,retain)NSDictionary * dicTemp;

@property (weak, nonatomic) IBOutlet UIScrollView *infoView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UITableView *docListView;
@property (weak, nonatomic) IBOutlet UITableView *attachmentView;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;

- (IBAction)changeInfoPage:(UISegmentedControl *)sender;

@end
