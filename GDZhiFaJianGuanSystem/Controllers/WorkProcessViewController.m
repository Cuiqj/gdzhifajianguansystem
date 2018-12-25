//
//  WorkProcessViewController.m
//  GDZhiFaJianGuanSystem
//
//  Created by quxiuyun on 14-2-26.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import "WorkProcessViewController.h"
#import "TaskSimpleModel.h"
#import "LocalFileDao.h"

@interface WorkProcessViewController ()

@end

@implementation WorkProcessViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 673, 633)];
	if (self.dataArray != nil && self.dataArray.count > 0) {
		TaskSimpleModel *mod = [self.dataArray objectAtIndex:0];
		NSString *processType = mod.process_type;
		UIImageView * flowChart;
		if ([processType isEqualToString:@"120"]) {
			flowChart = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"处罚案件.gif"]];
		}else if ([processType isEqualToString:@"130"]){
			flowChart = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"赔补偿案件.gif"]];
		}else if ([processType isEqualToString:@"140"]){
			flowChart = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"强制案件.gif"]];
		}else if ([processType integerValue]>= 101 && [processType integerValue] <= 110){
			processType = @"101";
			flowChart = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"许可.gif"]];
		}
		
		[scrollView addSubview:flowChart];
		scrollView.contentMode=UIViewContentModeLeft;
		scrollView.bounces=NO;
		scrollView.contentSize=CGSizeMake(750, 506);
		scrollView.contentInset=UIEdgeInsetsZero;
		[self.view addSubview:scrollView];
		
		NSMutableDictionary *nodeDic = [[[[LocalFileDao getInstance] readFromPlistFile:@"TaskAgentsSituation"] objectForKey:processType] objectForKey:@"nodes_dic"];
		
		for (TaskSimpleModel *model in self.dataArray) {
			NSMutableDictionary *arrawDic = [nodeDic objectForKey:model.node_id];
			UIImageView *arrawIV;
			if ([model.current_status isEqualToString:@"2"]) {
				arrawIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yijingwancheng@2x.png"]];
			}else if ([model.current_status isEqualToString:@"1"])
				arrawIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zhengzaijinxing@2x.png"]];
			
			arrawIV.frame = CGRectMake([[arrawDic objectForKey:@"x"] integerValue], [[arrawDic objectForKey:@"y"] integerValue], arrawIV.frame.size.width/2, arrawIV.frame.size.height/2);
			[flowChart addSubview:arrawIV];
			if (arrawIV.frame.origin.x == 0 && arrawIV.frame.origin.y == 0) {
				[arrawIV removeFromSuperview];
			}
		}
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
