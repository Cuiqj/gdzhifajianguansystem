//
//  UserPickerViewController.m
//  GDZhiFaJianGuanSystem
//
//  Created by quxiuyun on 14-2-12.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import "UserPickerViewController.h"
#import "EmployeeInfoModel.h"
#import "UserInfoSimpleModel.h"

@interface UserPickerViewController ()

@end

@implementation UserPickerViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _userDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    id model = [_userDataArray objectAtIndex:indexPath.row];
    if ([model isKindOfClass:[EmployeeInfoModel class]]){
        cell.textLabel.text=[model valueForKey:@"name"];
    }
    else if([model isKindOfClass:[UserInfoSimpleModel class]]){
        cell.textLabel.text=[model valueForKey:@"username"];
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSString *userName;
//    NSString *userID;
//    userName = [[_userDataArray objectAtIndex:indexPath.row] valueForKey:@"name"];
//    userID = [[_userDataArray objectAtIndex:indexPath.row] valueForKey:@"identifier"];
    [self.delegate setUser:[_userDataArray objectAtIndex:indexPath.row]];
    [self.pickerPopover dismissPopoverAnimated:YES];
}

@end
