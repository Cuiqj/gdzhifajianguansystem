//
//  WorkBenchViewController.m
//  GDZhiFaJianGuanSystem
//
//  Created by XU SHIWEN on 14-2-7.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import "WorkBenchViewController.h"

@interface WorkBenchViewController ()

@end

@implementation WorkBenchViewController

+ (instancetype)newInstance
{
    return [[[self alloc] initWithNibName:@"WorkBenchView" bundle:nil] prepareForUse];
}

- (id)prepareForUse
{
    //在这里完成一些内部参数的初始化
    
    return self;
}

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
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // 做一些刷新工作
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
