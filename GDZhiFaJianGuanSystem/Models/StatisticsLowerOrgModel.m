//
//  StatisticsLowerOrgModel.m
//  GDZhiFaJianGuanSystem
//
//  Created by yu hongwu on 14-9-16.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import "StatisticsLowerOrgModel.h"


@implementation StatisticsLowerOrgModel

@dynamic orgShortName;
@dynamic num;
@dynamic id;
@dynamic serialnumber;
+ (instancetype)newModelFromXML:(id)xml
{
    // 解析xml
    __block StatisticsLowerOrgModel *statisticsLowerOrgModel = nil;
    
    TBXMLElement *xmlElement = NULL;
    [(NSValue *)xml getValue:&xmlElement];
    
    if (xmlElement) {
        // 解析xml
        
        TBXMLElement * orgShortNameElement = [TBXML childElementNamed:@"orgShortName" parentElement:xmlElement];
        
        NSString * orgShortNameStr = [TBXML textForElement:orgShortNameElement];
        
        TBXMLElement * numElement = [TBXML childElementNamed:@"num" parentElement:xmlElement];
        
        NSString * numStr = [TBXML textForElement:numElement];
		
		TBXMLElement * idElement = [TBXML childElementNamed:@"id" parentElement:xmlElement];
        
        NSString * idStr = [TBXML textForElement:idElement];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
			NSManagedObjectContext *context=[MYAPPDELEGATE managedObjectContext];
			NSEntityDescription *entity=[NSEntityDescription entityForName:@"StatisticsLowerOrgModel" inManagedObjectContext:context];
			statisticsLowerOrgModel =[[StatisticsLowerOrgModel alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
			
			statisticsLowerOrgModel.orgShortName=orgShortNameStr;
			statisticsLowerOrgModel.num= [NSNumber numberWithInt:[numStr intValue]];
			statisticsLowerOrgModel.id = [[NSNumber alloc]initWithLong:[idStr longLongValue]];
			
			NSError *error;
			if(![context save:&error])
			{
				NSLog(@" StatisticsLowerOrgModel  不能保存：%@",[error localizedDescription]);
			}
		});
    }
    dispatch_sync(dispatch_get_main_queue(), ^{
		[MYAPPDELEGATE saveContext];
	});
    return statisticsLowerOrgModel;
}
+(instancetype)newModel{
	StatisticsLowerOrgModel *statisticsLowerOrgModel = nil;
	NSManagedObjectContext *context=[MYAPPDELEGATE managedObjectContext];
	NSEntityDescription *entity=[NSEntityDescription entityForName:@"StatisticsLowerOrgModel" inManagedObjectContext:context];
	statisticsLowerOrgModel =[[StatisticsLowerOrgModel alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
	NSError *error;
	if(![context save:&error])
	{
		NSLog(@" StatisticsLowerOrgModel  不能保存：%@",[error localizedDescription]);
	}
	[MYAPPDELEGATE saveContext];
    return statisticsLowerOrgModel;
}
@end
