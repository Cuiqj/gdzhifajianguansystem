//
//  CasePermitPickerViewController.m
//  GDZhiFaJianGuanSystem
//
//  Created by quxiuyun on 14-2-27.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import "RoadPickerViewController.h"
#import "DataModelCenter.h"

@interface RoadPickerViewController ()
@end

@implementation RoadPickerViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
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
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if(roadList != nil)
		return roadList.count;
	else
		return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
	id tmp = [roadList objectAtIndex:indexPath.row];
	if([tmp isKindOfClass:[RoadModel class]]){
		cell.textLabel.text=((RoadModel*)([roadList objectAtIndex:indexPath.row])).name;
	}else{
		cell.textLabel.text = @"";
	}
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * myCell=[tableView cellForRowAtIndexPath:indexPath];
	if(indexPath.row == 0){
		[self.delegate setRoadIdDelegate:@"" withNumber:@""];
	}else{
		[self.delegate setRoadIdDelegate:myCell.textLabel.text withNumber:((RoadModel*)roadList[indexPath.row]).identifier];
	}
    [self.pickerPopover dismissPopoverAnimated:YES];
}

@end
