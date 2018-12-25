//
//  CasePermitPickerViewController.m
//  GDZhiFaJianGuanSystem
//
//  Created by quxiuyun on 14-2-27.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import "CasePermitPickerViewController.h"

@interface CasePermitPickerViewController ()
@property (retain,nonatomic) NSArray *titleData;
@property (retain,nonatomic) NSArray *titleIDData;
@end

@implementation CasePermitPickerViewController

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
//    UITableView * tabelListView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 240, 300) style:UITableViewStylePlain];
//    [tabelListView setDataSource:self];
//    [tabelListView setDelegate:self];
//    [self.view addSubview:tabelListView];
    switch (_pickerType) {
        case 0://案件
            self.titleData=@[@"处罚",@"赔补偿",@"强制措施"];
            self.titleIDData =@[@"120",@"130",@"140"];
            break;
        case 1://许可
            self.titleData=@[@"超限运输车辆行驶公路许可",@"在公路用地范围以内设置非公路标志许可",@"占用、挖掘公路许可",@"跨越、穿越公路设置构筑物及其他设施许可",@"在公路及其两侧建筑控制区内埋设管线设施许可",@"铁轮车、履带车等可能损害公路路面的机具行驶公路许可",@"增设平面交叉道口许可",@"建设工程需要使公路改线的许可",@"更新、砍伐或修剪公路树木许可",@"在公路两侧埋土提高原地面标高的许可"];
            self.titleIDData =@[@"101",@"102",@"103",@"104",@"105",@"106",@"107",@"108",@"109",@"110"];
            break;
		case 2://案件
            self.titleData=@[@"",@"本月新增",@"本月拆除"];
            self.titleIDData =@[@"",@"本月新增",@"本月拆除"];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text=[self.titleData objectAtIndex:indexPath.row];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * myCell=[tableView cellForRowAtIndexPath:indexPath];
    switch (self.pickerType) {
        case 0:{
            [self.delegate setCaseTypeDelegate:myCell.textLabel.text withNumber:self.titleIDData[indexPath.row]];
        }
            break;
        case 1:{
            [self.delegate setPermitTypeDelegate:myCell.textLabel.text withNumber:self.titleIDData[indexPath.row]];
        }
            break;
		case 2:{
			 [self.delegate setDealWithDelegate:myCell.textLabel.text withNumber:self.titleIDData[indexPath.row]];
		}
			break;
        default:
            break;
    }
    [self.pickerPopover dismissPopoverAnimated:YES];
}

@end
