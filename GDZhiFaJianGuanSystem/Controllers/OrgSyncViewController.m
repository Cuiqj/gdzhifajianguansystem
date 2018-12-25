//
//  OrgSyncViewController.m
//  GDZhiFaJianGuanSystem
//
//  Created by quxiuyun on 14-2-11.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import "OrgSyncViewController.h"
#import "AGAlertViewWithProgressbar.h"

@interface OrgSyncViewController ()
@property (nonatomic,retain) NSArray *data;
@property (nonatomic,retain) AGAlertViewWithProgressbar *progressView;
@property (nonatomic,assign) NSInteger parserCount;
@property (nonatomic,assign) NSInteger currentParserCount;
@property (nonatomic,assign) BOOL stillParsing;

@end

@implementation OrgSyncViewController

@synthesize tableOrgList = _tableOrgList;
@synthesize textServerAddress = _textServerAddress;
@synthesize data = _data;
@synthesize progressView = _progressView;
@synthesize parserCount = _parserCount;
@synthesize currentParserCount = _currentParserCount;

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
//    self.textServerAddress.text=[MYAPPDELEGATE serverAddress];
    //载入所有机构信息
//    self.data = [OrgInfoModel allOrgInfo];
    //若本机无机构信息，则从服务器获取
    if (self.data.count == 0) {
        [self getOrgList];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateProgress:) name:@"UpdateProgress" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(parserFinished:) name:@"ParserFinished" object:nil];

    [super viewDidLoad];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.delegate pushLoginView];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);//屏幕朝向，自动旋转
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
//    cell.textLabel.text=[[self.data objectAtIndex:indexPath.row] valueForKey:@"orgname"];
//    cell.detailTextLabel.text=[[self.data objectAtIndex:indexPath.row] valueForKey:@"orgshortname"];
    return cell;
}

#pragma mark - IBActions

- (IBAction)showServerAddress:(UIBarButtonItem *)sender
{
    if (self.tableOrgList.frame.origin.y<100) {
        sender.title=@"确定地址";
        [UIView transitionWithView:self.tableOrgList
                          duration:0.3
                           options:UIViewAnimationOptionCurveEaseInOut
                        animations:^{
                            self.tableOrgList.frame = CGRectMake(0, 226, 540, 374);
                        }
                        completion:nil];
    } else {
        sender.title=@"设置服务器地址";
        [UIView transitionWithView:self.tableOrgList
                          duration:0.3
                           options:UIViewAnimationOptionCurveEaseInOut
                        animations:^{
                            self.tableOrgList.frame = CGRectMake(0, 44, 540, 556);
                        }
                        completion:^(BOOL finished){
//                            if (![self.textServerAddress.text isEqualToString:[MYAPPDELEGATE serverAddress]]) {//比较服务器地址是否相同
//                                NSString *error;
//                                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
//                                NSString *libraryDirectory = [paths objectAtIndex:0];
//                                NSString *plistFileName = @"Settings.plist";
//                                NSString *plistPath = [libraryDirectory stringByAppendingPathComponent:plistFileName];
//                                NSDictionary *serverSettingsDict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects: self.textServerAddress.text, [MYAPPDELEGATE fileAddress], nil]
//                                                                                               forKeys:[NSArray arrayWithObjects: @"server address", @"file address", nil]];
//                                NSPropertyListFormat format;
//                                NSString *errorDesc = nil;
//                                NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
//                                NSMutableDictionary *plistDict = [[NSPropertyListSerialization
//                                                                   propertyListFromData:plistXML
//                                                                   mutabilityOption:NSPropertyListMutableContainersAndLeaves
//                                                                   format:&format
//                                                                   errorDescription:&errorDesc] mutableCopy];
//                                [plistDict setObject:serverSettingsDict forKey:@"Server Settings"];
//                                NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:plistDict
//                                                                                               format:NSPropertyListXMLFormat_v1_0
//                                                                                     errorDescription:&error];
//                                
//                                if ([[NSFileManager defaultManager] isWritableFileAtPath:plistPath]) {
//                                    if(plistData) {
//                                        [plistData writeToFile:plistPath atomically:YES];
//                                    }
//                                }
//                                if (MYAPPDELEGATE == nil) {
//                                    [[MYAPPDELEGATE serverAddress] stringByAppendingString:self.textServerAddress.text];
//                                }
//                            }
                            [self getOrgList];
                            
                        }];
    }
}

- (IBAction)setCurrentOrg:(UIBarButtonItem *)sender
{
    NSIndexPath *indexPath=[self.tableOrgList indexPathForSelectedRow];
    if (indexPath) {
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.progressView=[[AGAlertViewWithProgressbar alloc] initWithTitle:@"同步基础数据" message:@"正在下载，请稍候……" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
            [self.progressView show];
        });
    }else {
        void(^ShowAlert)(void)=^(void){
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"错误" message:@"请先选择所属机构，再开始同步基础数据。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        };
        MAINDISPATCH(ShowAlert);
    }
}

- (void)updateProgress:(NSNotification *)noti{
    if ([self.progressView isVisible]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *service=[[noti userInfo] valueForKey:@"service"];
            service=[[NSString alloc] initWithFormat:@"正在下载%@,请稍候……",service];
            [self.progressView setMessage:service];
        });
    }
}


- (void)parserFinished:(NSNotification *)noti{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.progressView isVisible]) {
            NSString *service=[[noti userInfo] valueForKey:@"service"];
            service=[[NSString alloc] initWithFormat:@"%@下载完成,请稍候……",service];
            self.currentParserCount=self.currentParserCount-1;
            [self.progressView setMessage:service];
            [self.progressView setProgress:(int)(((float)(-self.currentParserCount+self.parserCount)/(float)self.parserCount)*100.0)];
            
            self.stillParsing = NO;
            if (self.currentParserCount==0) {
                [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
                [self.progressView hide];
                NSIndexPath *indexPath=[self.tableOrgList indexPathForSelectedRow];
                [[NSUserDefaults standardUserDefaults] setValue:[[self.data objectAtIndex:indexPath.row] valueForKey:@"myid"] forKey:ORGKEY] ;
                [[NSUserDefaults standardUserDefaults] synchronize];
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }
    });
}

- (void)getOrgList
{
    NSOperationQueue *myqueue=[[NSOperationQueue alloc] init];
    [myqueue setMaxConcurrentOperationCount:1];
    NSBlockOperation *clearTable=[NSBlockOperation blockOperationWithBlock:^{
        [self setData:nil];
        [self.tableOrgList reloadData];
//        [MYAPPDELEGATE clearEntityForName:@"OrgInfo"];
    }];
    [myqueue addOperation:clearTable];
    if ([WebServiceHandler isServerReachable]) {
        NSBlockOperation *getOrgInfo=[NSBlockOperation blockOperationWithBlock:^{
            WebServiceHandler *web = [[WebServiceHandler alloc] init];
            web.delegate=self;
//            [web getOrgInfo];
        }];
        [getOrgInfo addDependency:clearTable];
        [myqueue addOperation:getOrgInfo];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
