//
//  AnnouncementsViewController.m
//  GDZhiFaJianGuanSystem
//
//  Created by quxiuyun on 14-2-25.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import "AnnouncementsViewController.h"
#import "HTMLParser.h"

@interface AnnouncementsViewController ()

@end

@implementation AnnouncementsViewController

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
    UIBarButtonItem * backbutton =[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(backButton)];
    [self.navigationItem setLeftBarButtonItem:backbutton animated:YES];
    
    [_labelTitle setText:self.orgArticleModel.title];
    _labelTitle.lineBreakMode = NSLineBreakByWordWrapping;
    
    
    HTMLParser *parser = [[HTMLParser alloc] initWithString:self.orgArticleModel.content error:nil];
    HTMLNode *node = [parser body];
//    [_textContent setText:[node allContents]];
    NSString *realString = [[[node allContents] stringByReplacingOccurrencesOfString:@"&ldquo;" withString:@"“"] stringByReplacingOccurrencesOfString:@"&rdquo;" withString:@"”"];
    [_textContent setText:realString];
    
//    NSString *tmpStr = [node allContents];
//    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
//    NSData *data = [tmpStr dataUsingEncoding: enc];
//    NSString *retStr = [[NSString alloc] initWithData:data encoding:enc];
//    [_textContent setText:retStr];
    

    
    

    
    _textContent.editable = NO;
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
