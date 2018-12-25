//
//  TaskAgentsLeaderViewController.m
//  GDZhiFaJianGuanSystem
//
//  Created by quxiuyun on 14-2-24.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import "TaskAgentsLeaderViewController.h"
#import "DataModelCenter.h"
#import "AppSignModel.h"
#import "DateSelectController.h"

@interface TaskAgentsLeaderViewController ()<UIPopoverControllerDelegate, DatetimePickerHandler>
{
    NSInteger pickerType;
}
@property (nonatomic, strong)DataModelCenter * dataModelCenter;
@property (nonatomic, retain) UIPopoverController * permitListPopover;
@property (nonatomic, retain) DateSelectController * popoverContent;
@property (nonatomic, assign) NSInteger touchTextTag;
@end

@implementation TaskAgentsLeaderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.dataModelCenter=[DataModelCenter defaultCenter];
    }
    return self;
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([self.permitListPopover isPopoverVisible]) {
        [self.permitListPopover dismissPopoverAnimated:NO];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _textLeader.userInteractionEnabled= NO;
    _textLeader.text = [[NSUserDefaults standardUserDefaults] objectForKey:USERNAME];
    
    [_textSigningTime setDelegate:self];
    _textSigningTime.inputView = [[UIView alloc] init];
    [_textPromoterOpinion setText:self.currentModel.yijian1];
    _textPromoterOpinion.userInteractionEnabled= NO;
    [_textPromoterOpinion setText:self.currentModel.yijian2];
    _textReviewerComments.userInteractionEnabled= NO;
    
    self.permitListPopover=[[UIPopoverController alloc] initWithContentViewController:[[UIViewController alloc] init]];
}
#pragma mark - UITextFieldDelegateMethod
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.textSigningTime = textField;
    [self.permitListPopover presentPopoverFromRect:textField.frame
                                            inView:self.view
                          permittedArrowDirections:UIPopoverArrowDirectionUp
                                          animated:YES];
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [self.textSigningTime resignFirstResponder];
}

- (void)setDate:(NSString *)date
{
    self.textSigningTime.text = date;
    [self.textSigningTime resignFirstResponder];
    [self.permitListPopover dismissPopoverAnimated:YES];
}

#pragma mark - IBActions

- (IBAction)taskTime:(UITextField *)sender {
    [sender resignFirstResponder];
    if ((self.touchTextTag == sender.tag) && ([self.permitListPopover isPopoverVisible])) {
        [self.permitListPopover dismissPopoverAnimated:YES];
    } else {
        self.touchTextTag=sender.tag;
        DateSelectController *datePicker=[[DateSelectController alloc] init];
        datePicker.delegate=self;
        datePicker.pickerType = pickerType;
        [self.permitListPopover setContentViewController:datePicker];
        [self.permitListPopover setPopoverContentSize:CGSizeMake(300, 260)];
        [self.permitListPopover presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        datePicker.dateselectPopover=self.permitListPopover;
    }
}

- (IBAction)submit:(UIButton *)sender
{
    NSManagedObjectContext *context=[MYAPPDELEGATE managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"AppSignModel" inManagedObjectContext:context];

    AppSignModel *appSign =[[AppSignModel alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
    
    appSign.signOption = KILL_NIL_STRING(_textLeaderOpinion.text );
    appSign.signName = KILL_NIL_STRING(_textLeader.text);
//    appSign.nextUser = KILL_NIL_STRING(_textResponsible.text );
    appSign.identifier =KILL_NIL_STRING(self.currentModel.identifier)  ;
    appSign.nextUser = @"zhangh";
    
    NSString* string = self.textSigningTime.text;
     NSMutableString * str1 = [NSMutableString stringWithString:[string stringByReplacingOccurrencesOfString:@"-" withString:@""]];
    [str1 appendString:@"080000"];
    
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [inputFormatter setDateFormat:@"yyyyMMddHHmmss"];
    appSign.signDate = [inputFormatter dateFromString:str1];

    
    NSError *error;
    if(![context save:&error])
    {
        NSLog(@" AppSignModel  不能保存：%@",[error localizedDescription]);
    }
    [MYAPPDELEGATE saveContext];
    [[self.dataModelCenter webService] uploadSupervisionSign:appSign withAsyncHanlder:^(BOOL flg, NSError *err) {
        NSLog(@"%hhd",flg);
    }];
}

- (IBAction)staging:(UIButton *)sender {
    NSManagedObjectContext *context=[MYAPPDELEGATE managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"AppSignModel" inManagedObjectContext:context];
    AppSignModel *appSign =[[AppSignModel alloc] initWithEntity:entity insertIntoManagedObjectContext:context];

    appSign.signOption = KILL_NIL_STRING(_textLeaderOpinion.text );
    appSign.signName = KILL_NIL_STRING(_textLeader.text);
    appSign.nextUser = KILL_NIL_STRING(_textResponsible.text );
    appSign.identifier =KILL_NIL_STRING(self.currentModel.identifier)  ;
    appSign.nextUser = @"zhangh";
    NSString* string = self.textSigningTime.text;
     //2. 去掉所有的 “-”
    NSMutableString * str1 = [NSMutableString stringWithString:[string stringByReplacingOccurrencesOfString:@"-" withString:@""]];
    // 3. 拼接成完整的日期  存在 8 个小时的时差，所以设置为 080000
    [str1 appendString:@"080000"];
      // 4. 处理日期
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [inputFormatter setDateFormat:@"yyyyMMddHHmmss"];
    appSign.signDate = [inputFormatter dateFromString:str1];

    
    NSError *error;
    if(![context save:&error])
    {
        NSLog(@" AppSignModel  不能保存：%@",[error localizedDescription]);
    }
    [MYAPPDELEGATE saveContext];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
