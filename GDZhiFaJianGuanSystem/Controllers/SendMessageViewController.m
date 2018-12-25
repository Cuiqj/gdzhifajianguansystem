//
//  SendMessageViewController.m
//  GDZhiFaJianGuanSystem
//
//  Created by quxiuyun on 14-3-12.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import "SendMessageViewController.h"
#import "DataModelCenter.h"
#import "MessageModel.h"
#import "UserPickerViewController.h"

@interface SendMessageViewController () <UIPopoverControllerDelegate,UserPickerDelegate>{
    UserInfoSimpleModel *toUser;
}
@property (nonatomic, strong) DataModelCenter * dataModelCenter;
@property (nonatomic, retain) UIPopoverController * pickerPopover;
@property (nonatomic, assign) NSInteger touchTextTag;
@property (nonatomic, strong) NSMutableArray * employeeList;//人员列表
@property (nonatomic, strong) NSString * identifier;//需要上传的参数
@property (nonatomic, strong) UserPickerViewController * userPicker;

@end

@implementation SendMessageViewController

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

        self.dataModelCenter=[DataModelCenter defaultCenter];
        self.employeeList = [[NSMutableArray alloc] init];

    }
    return self;
}

- (void)viewDidLoad
{
	[[[DataModelCenter defaultCenter] webService].queue cancelAllOperations];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.descState = kAddNewRecord;
    
    _textRecipient.delegate = self;
    _textTitle.delegate = self;
    
    //textview 边框
    [_textContent setDelegate:self];
    _textContent.layer.borderWidth = 1;
    _textContent.layer.borderColor = UIColor.grayColor.CGColor;
    
    _scrollView.contentMode=UIViewContentModeLeft;
    _scrollView.bounces=NO;
    _scrollView.contentSize=CGSizeMake(1000, 567);
    _scrollView.contentInset=UIEdgeInsetsZero;
    
    //获取人员列表
//    NSString * orgID = [[NSUserDefaults standardUserDefaults] objectForKey:ORGKEY];
	
	
	
	[self getAllUser];

}
-(void)getAllUser{
    //在表中读取到全部机构信息
    NSManagedObjectContext *context=[MYAPPDELEGATE managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"UserInfoSimpleModel" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (UserInfoSimpleModel * userInfo in fetchedObjects) {
        
        [self.employeeList addObject:userInfo];
    }
}
#pragma mark - UITextFieldDelegateMethod

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    self.currentTextView = textField;
    if ([self.currentTextView isEqual:self.textRecipient]){
        [self textRecipient:self.currentTextView];
        return NO;
    }
    return YES;
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    self.currentTextView = textView;
    return YES;
}

//软键盘隐藏，恢复左下scrollview位置
- (void)keyboardWillHide:(NSNotification *)aNotification{
    if (self.descState == kAddNewRecord) {
//        [self.scrollView setContentSize:self.scrollView.frame.size];
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0f, 0.0);
        self.scrollView.contentInset = contentInsets;
        self.scrollView.scrollIndicatorInsets = contentInsets;
    }
}

//软键盘出现，上移scrollview至左上，防止编辑界面被阻挡
- (void)keyboardWillShow:(NSNotification *)aNotification{
    if (self.descState == kAddNewRecord) {
        NSDictionary* info = [aNotification userInfo];
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.width, 0.0);
        self.scrollView.contentInset = contentInsets;
        self.scrollView.scrollIndicatorInsets = contentInsets;
        
        if ([self.currentTextView isMemberOfClass:[UITextView class]]){
            self.scrollView.contentOffset = CGPointMake(0, CGRectGetMaxY(self.textTitle.frame)+20.0f);
        }
    }
}

#pragma mark - IBActions

- (IBAction)btnSend:(UIButton *)sender {
    
    NSManagedObjectContext *context=[MYAPPDELEGATE managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"MessageModel" inManagedObjectContext:context];
    MessageModel * model = [[MessageModel alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
    model.reader = toUser.account;
    model.identifier=self.identifier;
    model.title = self.textTitle.text;
    model.content = self.textContent.text;
    
    model.has_file = @"0";
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    model.org_id = [userDefaults objectForKey:ORGKEY];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
	NSTimeZone *timezone = [[NSTimeZone alloc] initWithName:@"GMT"];
	[formatter setTimeZone:timezone];
	[formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];

    model.send_date = [formatter stringFromDate:[NSDate date]];
    
    model.sender_name = [userDefaults objectForKey:USERNAME];

//    model.sender_email = @"11236524478@gmail";
    
    model.sender_id = [userDefaults objectForKey:USERKEY];
    
//    model.type_code = @"type_code000000";
    
    model.is_readed = @"0";
    
    NSError *error;
    if(![context save:&error])
    {
        NSLog(@" MessageModel  不能保存：%@",[error localizedDescription]);
    }
    [[self.dataModelCenter webService] uploadSupervisionMessage:model withAsyncHanlder:^(BOOL flg, NSError *err) {
		dispatch_sync(dispatch_get_main_queue(), ^{
			NSLog(@"%hhd",flg);
			if (flg == 0) {
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发送失败！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil ];
				[alert show];
			}else{
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发送成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil ];
				[alert show];
			}
		});
    }];
}

- (IBAction)textRecipient:(UITextField *)sender
{
    if ((self.touchTextTag == sender.tag) && ([self.pickerPopover isPopoverVisible])) {
        [self.pickerPopover dismissPopoverAnimated:YES];
    } else {
        self.touchTextTag=sender.tag;
        _userPicker=[[UserPickerViewController alloc] init];
        _userPicker.delegate=self;
        _userPicker.userDataArray=self.employeeList;
        self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:_userPicker];
        [self.pickerPopover setPopoverContentSize:CGSizeMake(300, 200)];
        [self.pickerPopover presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        _userPicker.pickerPopover=self.pickerPopover;
    }
    [_textRecipient resignFirstResponder];
}

-(void)setUser:(UserInfoSimpleModel *)userInfo
{
    toUser = userInfo;
    self.textRecipient.text = toUser.username;
    self.identifier=toUser.identifier;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
