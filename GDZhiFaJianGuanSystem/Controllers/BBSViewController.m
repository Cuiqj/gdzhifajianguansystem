//
//  BBSViewController.m
//  GDZhiFaJianGuanSystem
//
//  Created by yu hongwu on 14-10-13.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import "BBSViewController.h"

@interface BBSViewController ()

@end

@implementation BBSViewController

+ (instancetype)newInstance
{
    return [[[self alloc] initWithNibName:@"BBSViewController" bundle:nil] prepareForUse];
}
- (id)prepareForUse
{

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
    // Do any additional setup after loading the view from its nib.
	
	NSURL *url = [NSURL URLWithString:[[AppDelegate App].serverAddress stringByAppendingFormat:@"%@", BBS_LOCATION ]];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
	[self.webView loadRequest:request];
	

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
