//
//  InspectionInfoViewController.m
//  GDZhiFaJianGuanSystem
//
//  Created by luna on 14-3-5.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import "RoadEngrossInfoViewController.h"

@interface RoadEngrossInfoViewController ()
@property (nonatomic, strong) DataModelCenter * dataModelCenter;

@property (nonatomic, strong) NSString * urlString;
@end

@implementation RoadEngrossInfoViewController

+ (instancetype)newInstance
{
    return [[[self alloc] initWithNibName:@"RoadEngrossInfoViewController" bundle:nil] prepareForUse];
}

- (id)prepareForUse
{
    //在这里完成一些内部参数的初始化
    self.dataModelCenter=[DataModelCenter defaultCenter];

    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
        if ( IOS7_OR_LATER )
        {
            self.edgesForExtendedLayout = UIRectEdgeNone;
            self.extendedLayoutIncludesOpaqueBars = NO;
            self.modalPresentationCapturesStatusBarAppearance = NO;
        }
#endif // #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    
    
    
}

- (void)viewDidLoad
{
	[[[DataModelCenter defaultCenter] webService].queue cancelAllOperations];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.navigationItem.title = @"公路占利用信息文书";
    
    [[self.dataModelCenter webService] getSupervisionRoadEngrossReportAndAttechmentList:KILL_NIL_STRING(self.roadModel.identifier) withAsyncHanlder:^(NSString *url, NSError *err) {
		dispatch_sync(dispatch_get_main_queue(), ^{
        
			if (url) {
				self.urlString = url;
			}
			
			UIWebView* popoverView = [[UIWebView alloc]
									  initWithFrame:self.view.bounds];
			popoverView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
		
			NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.urlString]];
			[popoverView loadRequest:request];

			[self.view addSubview:popoverView];
		 });
    }];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
