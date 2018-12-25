//
//  MessageCenterViewController.m
//  GDZhiFaJianGuanSystem
//
//  Created by quxiuyun on 14-3-12.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import "MessageCenterViewController.h"
#import "SendMessageViewController.h"
#import "DataModelCenter.h"
#import "MessageCenterCell.h"
#import "MessageContentViewController.h"

@interface MessageCenterViewController ()

@property (nonatomic, strong)SendMessageViewController * sendMessageView;
@property (nonatomic, assign) DataModelCenter *dataModelCenter;
@property (nonatomic, retain)NSMutableArray * messageArray;
@end

@implementation MessageCenterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	[[[DataModelCenter defaultCenter] webService].queue cancelAllOperations];
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
        
        self.dataModelCenter = [DataModelCenter defaultCenter];
        _messageArray =[[NSMutableArray alloc] init];
        [_tableMessageList setHidden:YES];
    }
    return self;
}

- (void)viewDidLoad
{
	[[[DataModelCenter defaultCenter] webService].queue cancelAllOperations];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"消息中心"];
    [_tableMessageList setDataSource:self];
    [_tableMessageList setDelegate:self];

    UIBarButtonItem * backbutton =[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(backButton)];
    [self.navigationItem setLeftBarButtonItem:backbutton animated:YES];
    
    _labelUserName.text = [[NSUserDefaults standardUserDefaults] objectForKey:USERNAME];
    [self listOption:0];
}

#pragma mark - IBActions

- (void)backButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)listOption:(id)sender
{
    switch (_segmentedControl.selectedSegmentIndex) {
        case 0:{
            
            _tableMessageList.hidden = NO;
            [_sendMessageView.view setHidden:YES];
            [[self.dataModelCenter webService] getSupervisionMessageList:@"1" withAsyncHanlder:^(NSArray *messageList, NSError *err) {
                if (err == nil) {
                    [_messageArray removeAllObjects];
                    for (MessageModel * model in messageList) {
                        //MessageModel 表中is_readed字段   1是已读，0是未读
                        if ([model.is_readed  isEqual: @"0"]) {
                            [_messageArray addObject:model];
                        }
                        if ([_messageArray count] !=0) {
                            _labelState.text =@"[您有新的消息]";
                        }else if([_messageArray count] ==0)
                        {
                            _labelState.text =@"[暂时没有新消息]";
                        }
                    }
                    if ([messageList count]==0) {
                        _labelState.text =@"[暂时没有新消息]";
                    }
                    [_tableMessageList reloadData];
                }
            }];
        }
            break;
        case 1:{
            _labelState.text =@"[所有已读消息]";
            [_tableMessageList setHidden:NO];
            [_sendMessageView.view setHidden:YES];
            [[self.dataModelCenter webService] getSupervisionMessageList:@"1" withAsyncHanlder:^(NSArray *messageList, NSError *err) {
				dispatch_sync(dispatch_get_main_queue(), ^{
					if (err == nil) {
						[_messageArray removeAllObjects];
						for (MessageModel * model in messageList) {
							if ([model.is_readed  isEqual: @"1"]) {
								[_messageArray addObject:model];
							}
						}
						[_tableMessageList reloadData];
					}
				});
            }];
        }
            break;
        case 2:{
            _labelState.text =@"[发送消息]";
            [_tableMessageList setHidden:YES];
            _sendMessageView= [[SendMessageViewController alloc] initWithNibName:@"SendMessageViewController" bundle:nil];
            _sendMessageView.view.frame = CGRectMake(0, 100, 1000, 567);
            [_backGroundView addSubview:_sendMessageView.view];
            [self addChildViewController:_sendMessageView];
        }
            break;
        default:
            break;
    }
}

#pragma mark - UITableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _messageArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 37;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (_segmentedControl.selectedSegmentIndex) {
        case 0:{
            static NSString * MessCellIdentifier = @"MessCell";
            MessageCenterCell * cell = [tableView dequeueReusableCellWithIdentifier:MessCellIdentifier];
            if (cell == nil) {
                cell = [[MessageCenterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MessCellIdentifier];
            }
            [cell configureCellWithMessageArray:[_messageArray objectAtIndex:indexPath.row]];
            return cell;
        }
            break;
        case 1:{
            static NSString * MessCellIdentifier = @"MessCell";
            MessageCenterCell * cell = [tableView dequeueReusableCellWithIdentifier:MessCellIdentifier];
            if (cell == nil) {
                cell = [[MessageCenterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MessCellIdentifier];
            }
            [cell configureCellWithMessageArray:[_messageArray objectAtIndex:indexPath.row]];
            return cell;
        }
            break;
        default:
            break;
    }
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 37;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    switch (_segmentedControl.selectedSegmentIndex) {
        case 0:{
        MessageCenterCell * messageCell =[[MessageCenterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        messageCell.contentView.backgroundColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
        [messageCell titleLabel];
        return messageCell.contentView;
        }
            break;
        case 1:{
            MessageCenterCell * messageCell =[[MessageCenterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            messageCell.contentView.backgroundColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
            [messageCell titleLabel];
            return messageCell.contentView;
        }
            break;
        default:
            break;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (_segmentedControl.selectedSegmentIndex) {
        case 0:{
            
            MessageContentViewController * contentViewController = [[MessageContentViewController alloc]initWithNibName:@"MessageContentViewController" bundle:nil];
            MessageModel * model = [_messageArray objectAtIndex:indexPath.row];
            contentViewController.messageModel =model;
            [[self.dataModelCenter webService]readSupervisionMessage:model.identifier withAsyncHanlder:^(BOOL flg, NSError *err) {
                model.is_readed =@"1";
                NSLog(@"%hhd",flg);
            }];
            [self.navigationController pushViewController:contentViewController animated:YES];
        }
            break;
        case 1:{
            MessageContentViewController * contentViewController = [[MessageContentViewController alloc]initWithNibName:@"MessageContentViewController" bundle:nil];
            MessageModel * model = [_messageArray objectAtIndex:indexPath.row];
            contentViewController.messageModel =model;
            [self.navigationController pushViewController:contentViewController animated:YES];
        }
            break;
        default:
            break;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
