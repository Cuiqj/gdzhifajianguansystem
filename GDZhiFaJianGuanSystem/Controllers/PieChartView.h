//
//  PieChartView.h
//  GDZhiFaJianGuanSystem
//
//  Created by luna on 14-2-24.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCPieChart.h"
#import "DataModelCenter.h"

@interface PieChartView : UIView

@property (retain ,nonatomic) NSDictionary * dic;

-(UIView *)RptStatisticsHistory;
-(UIView *)RptStatisticsHistoryMonth;
-(UIView *)RptStatisticsXunChaHistory;
@end
