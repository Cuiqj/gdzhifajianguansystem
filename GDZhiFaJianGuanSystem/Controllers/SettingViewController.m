//
//  LoginViewController.m
//  GDZhiFaJianGuanSystem
//
//  Created by XU SHIWEN on 14-2-8.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import "SettingViewController.h"
#import "MainPageViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController


+ (instancetype)newInstance
{
    return [[[self alloc] initWithNibName:@"SettingView" bundle:nil] prepareForUse];
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

- (void)viewWillDisappear:(BOOL)animated
{
	
}

- (void)viewDidLoad
{
	self.textServer.text = [AppDelegate App].serverAddress;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}



- (IBAction)btnOK:(UIBarButtonItem *)sender
{
}

- (void)addMyTarget:(MainPageViewController*)target action:(SEL)action
{
    self.target = target;
    self.action = action;
}




- (IBAction)textFiledReturnEditing:(id)sender
{
     [sender resignFirstResponder];
}



- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnSave:(UIBarButtonItem *)sender{
	
	if(self.textServer.text == nil || [self.textServer.text isEqualToString:@""]){
		return;
	}
	NSString *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libraryDirectory = [paths objectAtIndex:0];
    NSString *plistFileName = @"Settings.plist";
    NSString *plistPath = [libraryDirectory stringByAppendingPathComponent:plistFileName];
    NSDictionary *serverSettingsDict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects: self.textServer.text, nil]
                                                                   forKeys:[NSArray arrayWithObjects: @"server address", nil]];
    NSPropertyListFormat format;
    NSString *errorDesc = nil;
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    NSMutableDictionary *plistDict = [[NSPropertyListSerialization
									   propertyListFromData:plistXML
									   mutabilityOption:NSPropertyListMutableContainersAndLeaves
									   format:&format
									   errorDescription:&errorDesc] mutableCopy];
    [plistDict setObject:serverSettingsDict forKey:@"Server Settings"];
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:plistDict
                                                                   format:NSPropertyListXMLFormat_v1_0
                                                         errorDescription:&error];
    
    if ([[NSFileManager defaultManager] isWritableFileAtPath:plistPath]) {
        if(plistData) {
            [plistData writeToFile:plistPath atomically:YES];
        }
    }
    [AppDelegate App].serverAddress=self.textServer.text;
	[(MainPageViewController*)self.target dismissSettingView];

}
@end
