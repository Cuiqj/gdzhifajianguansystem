//
//  TaskAgentsPromoterViewController.m
//  GDZhiFaJianGuanSystem
//
//  Created by quxiuyun on 14-2-24.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import "TaskAgentsPromoterViewController.h"
#import "DataModelCenter.h"
#import "DateSelectController.h"

@interface TaskAgentsPromoterViewController ()<UIPopoverControllerDelegate, DatetimePickerHandler>
{
    NSInteger pickerType;
}
@property (nonatomic, strong)DataModelCenter * dataModelCenter;
@property (nonatomic, retain) UIPopoverController * permitListPopover;//组织的
@property (nonatomic, retain) DateSelectController * popoverContent;
@property (nonatomic, assign) NSInteger touchTextTag;
@end

@implementation TaskAgentsPromoterViewController

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
    [_textPromoter setText:self.currentModel.name1];
    _textPromoter.userInteractionEnabled= NO;
    
    [_textSigningEvent setDelegate:self];
    _textSigningEvent.inputView = [[UIView alloc] init];
    self.permitListPopover=[[UIPopoverController alloc] initWithContentViewController:[[UIViewController alloc] init]];
}
#pragma mark - UITextFieldDelegateMethod
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.textSigningEvent = textField;
    [self.permitListPopover presentPopoverFromRect:textField.frame
                                            inView:self.view
                          permittedArrowDirections:UIPopoverArrowDirectionUp
                                          animated:YES];
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [self.textSigningEvent resignFirstResponder];
}

- (void)setDate:(NSString *)date
{
    self.textSigningEvent.text = date;
    [self.textSigningEvent resignFirstResponder];
    [self.permitListPopover dismissPopoverAnimated:YES];
}
#pragma mark - IBActions

- (IBAction)taskTime:(UITextField *)sender
{
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
    
    appSign.signOption = KILL_NIL_STRING(_textPromoterOpinion.text );
    appSign.signName = KILL_NIL_STRING(_textPromoter.text);
    appSign.nextUser = KILL_NIL_STRING(_textResponsible.text );
    appSign.identifier =KILL_NIL_STRING(self.currentModel.identifier);
    appSign.nextUser = @"zhangh";
    NSString* string = self.textSigningEvent.text;
    NSMutableString * str1 = [NSMutableString stringWithString:[string stringByReplacingOccurrencesOfString:@"-" withString:@""]];
    [str1 appendString:@"080000"];
    
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [inputFormatter setDateFormat:@"yyyyMMddHHmmss"];
    appSign.signDate = [inputFormatter dateFromString:str1];

    NSError *error;
    if(![context save:&error])//调用托管对象上下文的save方法将数据写入数据库
    {
        NSLog(@" AppSignModel  不能保存：%@",[error localizedDescription]);
    }else{
        [[self.dataModelCenter webService] uploadSupervisionSign:appSign withAsyncHanlder:^(BOOL flg, NSError *err) {
            NSLog(@"%hhd",flg);
        }];
    }
}

- (IBAction)staging:(UIButton *)sender
{
    NSManagedObjectContext *context=[MYAPPDELEGATE managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"AppSignModel" inManagedObjectContext:context];
    AppSignModel *appSign =[[AppSignModel alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
    
    appSign.signOption = KILL_NIL_STRING(_textPromoterOpinion.text );
    appSign.signName = KILL_NIL_STRING(_textPromoter.text);
    appSign.nextUser = KILL_NIL_STRING(_textResponsible.text );
    appSign.identifier =KILL_NIL_STRING(self.currentModel.identifier)  ;
    appSign.nextUser = @"zhangh";
    NSString* string = self.textSigningEvent.text;
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
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
