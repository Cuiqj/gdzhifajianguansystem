//
//  DealSituationViewController.m
//  GDZhiFaJianGuanSystem
//
//  Created by quxiuyun on 14-2-25.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import "DealSituationViewController.h"
#import "DealSituationCell.h"
#import "TaskSimpleModel.h"

@interface DealSituationViewController ()

@end

@implementation DealSituationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - UITableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 37;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 37;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    DealSituationCell * view = [[DealSituationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    view.contentView.backgroundColor = [UIColor lightGrayColor];
    [view titleLabel];
    return view.contentView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"Cell";
    DealSituationCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[DealSituationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell configureCellWithTaskSimpleArray:[_dataArray objectAtIndex:indexPath.row]];
    cell.userInteractionEnabled = NO;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"3333");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
