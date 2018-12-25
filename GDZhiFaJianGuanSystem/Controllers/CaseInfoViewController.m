//
//  CaseInfoViewController.m
//  GDZhiFaJianGuanSystem
//
//  Created by luna on 14-3-5.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import "CaseInfoViewController.h"
#import "MBProgressHUD.h"
@interface CaseInfoViewController ()

@end

@implementation CaseInfoViewController

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

	
    // Do any additional setup after loading the view from its nib.
	
	
    self.navigationItem.title = @"案件详情";
	
	
	if ([self.urlString hasSuffix:@"jpg" ] ||
		[self.urlString hasSuffix:@"JPG" ] ) {
		UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
		imageView.layer.masksToBounds = YES;
		imageView.layer.cornerRadius = 5.0f;
		imageView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
		[self addGestureRecognizerToView:imageView];
		
		//如果处理的是图片，别忘了
		[imageView setUserInteractionEnabled:YES];
		[imageView setMultipleTouchEnabled:YES];
		[self.view addSubview:imageView];
		
		MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
		[self.view addSubview:hud];
		
		//如果设置此属性则当前的view置于后台
		hud.dimBackground = YES;
		
		//设置对话框文字
		hud.labelText = @"正在加载图片...";
		[hud show:YES];
		
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
			NSURL * url = [NSURL URLWithString:self.urlString];
			NSData * data = [[NSData alloc]initWithContentsOfURL:url];
			UIImage *image = [[UIImage alloc]initWithData:data];
			if (data != nil) {
				dispatch_async(dispatch_get_main_queue(), ^{
					imageView.image = image;
					[hud removeFromSuperview];
				});
			}
		});
	}else{
	    UIWebView* popoverView = [[UIWebView alloc]
								  initWithFrame:CGRectMake(0, 0, 1024, 768)];
		popoverView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
		
		NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.urlString]];
		[popoverView loadRequest:request];
		
		[self.view addSubview:popoverView];

	}

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 添加所有的手势
- (void) addGestureRecognizerToView:(UIView *)view
{

    // 缩放手势
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
    [view addGestureRecognizer:pinchGestureRecognizer];

}


// 处理缩放手势
- (void) pinchView:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    UIView *view = pinchGestureRecognizer.view;
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
        pinchGestureRecognizer.scale = 1;
    }
}



@end
