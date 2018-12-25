//
//  Rpt_statisticsModel.m
//  GDZhiFaJianGuanSystem
//
//  Created by luna on 14-3-4.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import "Rpt_statisticsModel.h"


@implementation Rpt_statisticsModel

@dynamic amount;
@dynamic beginsum;
@dynamic dateTime;
@dynamic endsum;
@dynamic identifier;
@dynamic orgid;
@dynamic rate;
@dynamic remark;
@dynamic stattypes;
@dynamic status;
@dynamic typenames;

+ (instancetype)newModelFromXML:(id)xml
{
    // 解析xml
    __block Rpt_statisticsModel *rpt_statistics = nil;
    
    TBXMLElement *xmlElement = NULL;
    [(NSValue *)xml getValue:&xmlElement];
    
    if (xmlElement) {
        // 解析xml
        
        TBXMLElement * amountElement = [TBXML childElementNamed:@"amount" parentElement:xmlElement];
        
        NSString * amountStr = [TBXML textForElement:amountElement];
        
        TBXMLElement * beginsumElement = [TBXML childElementNamed:@"beginsum" parentElement:xmlElement];
        
        NSString * beginsumStr = [TBXML textForElement:beginsumElement];
        
        TBXMLElement * idElement = [TBXML childElementNamed:@"id" parentElement:xmlElement];
        
        NSString * idStr = [TBXML textForElement:idElement];
        
        TBXMLElement * endsumElement = [TBXML childElementNamed:@"endsum" parentElement:xmlElement];
        
        NSString * endsumStr = [TBXML textForElement:endsumElement];
        
        TBXMLElement * orgidElement = [TBXML childElementNamed:@"orgid" parentElement:xmlElement];
        
        NSString * orgidStr = [TBXML textForElement:orgidElement];
        
        TBXMLElement * rateElement = [TBXML childElementNamed:@"rate" parentElement:xmlElement];
        
        NSString * rateStr = [TBXML textForElement:rateElement];
        
        TBXMLElement * remarkElement = [TBXML childElementNamed:@"remark" parentElement:xmlElement];
        
        NSString * remarkStr = [TBXML textForElement:remarkElement];
        
        TBXMLElement * stattypesElement = [TBXML childElementNamed:@"stattypes" parentElement:xmlElement];
        
        NSString * stattypesStr = [TBXML textForElement:stattypesElement];
        
        TBXMLElement * statusElement = [TBXML childElementNamed:@"status" parentElement:xmlElement];
        
        NSString * statusStr = [TBXML textForElement:statusElement];
        
        TBXMLElement * typenameElement = [TBXML childElementNamed:@"typename" parentElement:xmlElement];
        
        NSString * typenameStr = [TBXML textForElement:typenameElement];
        
        TBXMLElement * dateElement = [TBXML childElementNamed:@"date" parentElement:xmlElement];
        
        NSString * dateStr = [TBXML textForElement:dateElement];
        
		dispatch_sync(dispatch_get_main_queue(), ^{
			NSManagedObjectContext *context=[MYAPPDELEGATE managedObjectContext];
			NSEntityDescription *entity=[NSEntityDescription entityForName:@"Rpt_statisticsModel" inManagedObjectContext:context];
			rpt_statistics =[[Rpt_statisticsModel alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
			
			rpt_statistics.identifier=idStr;
			rpt_statistics.amount=amountStr;
			rpt_statistics.beginsum=beginsumStr;
			rpt_statistics.endsum=endsumStr;
			rpt_statistics.orgid=orgidStr;
			rpt_statistics.rate=rateStr;
			rpt_statistics.remark=remarkStr;
			rpt_statistics.stattypes=stattypesStr;
			rpt_statistics.status=statusStr;
			rpt_statistics.typenames=typenameStr;
			
			if (dateStr!=nil) {
				rpt_statistics.dateTime=[[dateStr componentsSeparatedByString:@"T"]objectAtIndex:0];
			}
			
			NSError *error;
			if(![context save:&error])
			{
				NSLog(@" Rpt_statisticsModel  不能保存：%@",[error localizedDescription]);
			}
		});
    }
    dispatch_sync(dispatch_get_main_queue(), ^{
		[MYAPPDELEGATE saveContext];
	});
    return rpt_statistics;
}

@end
