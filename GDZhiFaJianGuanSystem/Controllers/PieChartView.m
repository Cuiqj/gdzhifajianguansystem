//
//  PieChartView.m
//  GDZhiFaJianGuanSystem
//
//  Created by luna on 14-2-24.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import "PieChartView.h"
#import "PCPieChart.h"

@implementation PieChartView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"dicData"];
    }
    return self;
}

-(UIView *)RptStatisticsHistory
{
    [self setBackgroundColor:[UIColor colorWithWhite:1 alpha:1]];
    
    int height = [self bounds].size.width/3.5*2; // 220;
    int width = [self bounds].size.width; //320;
    PCPieChart *pieChart = [[PCPieChart alloc] initWithFrame:CGRectMake(([self bounds].size.width-width)/2,([self bounds].size.height-height)/2,width,height)];
    [pieChart setShowArrow:NO];
    [pieChart setSameColorLabel:YES];
    [pieChart setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin];
    [pieChart setDiameter:width/2];
    [self addSubview:pieChart];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPad)
    {
        pieChart.titleFont = [UIFont systemFontOfSize:15];
        pieChart.percentageFont = [UIFont systemFontOfSize:15];
    }
//    NSDictionary * dicTest = @{@"orgId":@"237568002",@"date":@"2013-04-01"};
    NSMutableArray *components = [NSMutableArray array];
    
    [[[DataModelCenter defaultCenter]webService]getSupervisionRptStatisticsHistoryList:self.dic withAsyncHanlder:^(NSArray *statisticsList, NSError *err) {
        dispatch_sync(dispatch_get_main_queue(), ^{
			for (Rpt_statisticsModel *statistic in statisticsList) {
				
				if ([statistic.stattypes isEqualToString:@"anjian"]) {
					PCPieComponent *component = [PCPieComponent pieComponentWithTitle:statistic.typenames value:[statistic.beginsum floatValue]];
					
					[components addObject:component];
					
					if ([statistic.typenames isEqualToString:@"赔补偿案件"]) {
						[component setColour:PCColorYellow];
					}else if ([statistic.typenames isEqualToString:@"行政处罚案件"])
					{
						[component setColour:PCColorGreen];
					}else if ([statistic.typenames isEqualToString:@"强制措施案件"])
					{
						[component setColour:PCColorOrange];
					}
					else
					{
						[component setColour:PCColorBlue];
					}
				}

			}
			[pieChart setComponents:components];
			[pieChart setNeedsDisplay];
		});
    }];
    
    return self;
}

-(UIView *)RptStatisticsHistoryMonth
{
    [self setBackgroundColor:[UIColor colorWithWhite:1 alpha:1]];
    
    int height = [self bounds].size.width/3.5*2; // 220;
    int width = [self bounds].size.width; //320;
    PCPieChart *pieChart = [[PCPieChart alloc] initWithFrame:CGRectMake(([self bounds].size.width-width)/2,([self bounds].size.height-height)/2,width,height)];
    [pieChart setShowArrow:NO];
    [pieChart setSameColorLabel:YES];
    [pieChart setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin];
    [pieChart setDiameter:width/2];
    [self addSubview:pieChart];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPad)
    {
        pieChart.titleFont = [UIFont systemFontOfSize:15];
        pieChart.percentageFont = [UIFont systemFontOfSize:15];
    }
//    NSDictionary * dicTest = @{@"orgId":@"237568002",@"date":@"2013-04-01"};
    NSMutableArray *components = [NSMutableArray array];
    
    [[[DataModelCenter defaultCenter]webService]getSupervisionRptStatisticsList:[self.dic objectForKey:@"orgId"]  withAsyncHanlder:^(NSArray *statisticsList, NSError *err) {
		dispatch_sync(dispatch_get_main_queue(), ^{
			for (Rpt_statisticsModel *statistic in statisticsList) {
				
				if ([statistic.stattypes isEqualToString:@"xuke"]) {
					PCPieComponent *component = [PCPieComponent pieComponentWithTitle:statistic.typenames value:[statistic.beginsum floatValue]];
					
					[components addObject:component];
					if ([statistic.typenames isEqualToString:@"超限运输许可审批"]) {
						[component setColour:PCColorYellow];
					}else if ([statistic.typenames isEqualToString:@"非公路标志许可审批"])
					{
						[component setColour:PCColorGreen];
					}else if ([statistic.typenames isEqualToString:@"占用、挖掘公路的许可审批"])
					{
						[component setColour:PCColorOrange];
						
					}else if ([statistic.typenames isEqualToString:@"跨越、穿越公路的许可审批"])
					{
						[component setColour:PCColorRed];
					}else if ([statistic.typenames isEqualToString:@"埋架管线、电缆的许可审批"])
					{
						[component setColour:PCColorBlue];
						
					}else if ([statistic.typenames isEqualToString:@"有害机车上公路的许可审批"])
					{
						[component setColour:PCColorPinke];
						
					}else if ([statistic.typenames isEqualToString:@"设置交叉道口的许可审批"])
					{
						[component setColour:PCColorLiteGreen];
					}
					else if ([statistic.typenames isEqualToString:@"建设工程需要使公路改线的许可"])
					{
						[component setColour:PCColorPurple];
						
					}else if ([statistic.typenames isEqualToString:@"砍伐修剪树木的许可审批"])
					{
						[component setColour:PCColorOcher];
						
					}else if ([statistic.typenames isEqualToString:@"在公路两侧埋土提高原地面标高的许可"])
					{
						[component setColour:PCColorLiteBlue];
					}
					else
					{
						[component setColour:PCColorDefault];
					}

				}
			}
			[pieChart setComponents:components];
			[pieChart setNeedsDisplay];
		});
    }];
    
    return self;
}

-(UIView *)RptStatisticsXunChaHistory
{
    [self setBackgroundColor:[UIColor colorWithWhite:1 alpha:1]];
    
    int height = [self bounds].size.width/3.5*2; // 220;
    int width = [self bounds].size.width; //320;
    PCPieChart *pieChart = [[PCPieChart alloc] initWithFrame:CGRectMake(([self bounds].size.width-width)/2,([self bounds].size.height-height)/2,width,height)];
    [pieChart setShowArrow:NO];
    [pieChart setSameColorLabel:YES];
    [pieChart setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin];
    [pieChart setDiameter:width/2];
    [self addSubview:pieChart];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPad)
    {
        pieChart.titleFont = [UIFont systemFontOfSize:15];
        pieChart.percentageFont = [UIFont systemFontOfSize:15];
    }
    NSDictionary * dicTest = @{@"orgId":@"13860865",@"date":@"2013-04-01"};
    NSMutableArray *components = [NSMutableArray array];
    
    [[[DataModelCenter defaultCenter]webService]getSupervisionRptStatisticsList:[dicTest objectForKey:@"orgId"]  withAsyncHanlder:^(NSArray *statisticsList, NSError *err) {
		dispatch_sync(dispatch_get_main_queue(), ^{
			for (Rpt_statisticsModel *statistic in statisticsList) {
				
				if ([statistic.stattypes isEqualToString:@"xuncha"]) {
					PCPieComponent *component = [PCPieComponent pieComponentWithTitle:statistic.typenames value:[statistic.beginsum floatValue]];
					
					[components addObject:component];
					if ([statistic.typenames isEqualToString:@"雪凝冰灾天气巡查"]) {
						[component setColour:PCColorYellow];
					}else if ([statistic.typenames isEqualToString:@"污染公路"])
					{
						[component setColour:PCColorPinke];
					}else if ([statistic.typenames isEqualToString:@"侵占公路路产"])
					{
						[component setColour:PCColorOrange];
						
					}else if ([statistic.typenames isEqualToString:@"排水沟堵塞"])
					{
						[component setColour:PCColorRed];
					}else if ([statistic.typenames isEqualToString:@"拆除违法广告"])
					{
						[component setColour:PCColorBlue];
						
					}else if ([statistic.typenames isEqualToString:@"日常巡查"])
					{
						[component setColour:PCColorGreen];
						
					}else if ([statistic.typenames isEqualToString:@"稽查超限车辆"])
					{
						[component setColour:PCColorLiteGreen];
					}
					else if ([statistic.typenames isEqualToString:@"占道堆料"])
					{
						[component setColour:PCColorPurple];
						
					}else if ([statistic.typenames isEqualToString:@"勘验"])
					{
						[component setColour:PCColorOcher];
						
					}else if ([statistic.typenames isEqualToString:@"发生交通事故(有路产损坏)"])
					{
						[component setColour:PCColorLiteBlue];
					}
					else
					{
						[component setColour:PCColorDefault];
					}
					
				}
			}
			[pieChart setComponents:components];
			[pieChart setNeedsDisplay];
		});
    }];
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
