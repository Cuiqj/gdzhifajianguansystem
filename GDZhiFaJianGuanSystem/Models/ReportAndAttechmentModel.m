//
//  ReportAndAttechmentModel.m
//  GDZhiFaJianGuanSystem
//
//  Created by luna on 14-2-10.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import "ReportAndAttechmentModel.h"
#import "TBXML.h"


@implementation ReportAndAttechmentModel

@dynamic identifier;
@dynamic importent;
@dynamic name;
@dynamic project_id;
@dynamic title;
@dynamic type;
@dynamic url;


+ (instancetype)newModelFromXML:(id)xml
{
    // 解析xml
    __block ReportAndAttechmentModel *report = nil;
    TBXMLElement *xmlElement = NULL;
    [(NSValue *)xml getValue:&xmlElement];
    
    if (xmlElement) {
        // 解析xml
        
        TBXMLElement * idElement = [TBXML childElementNamed:@"id" parentElement:xmlElement];
        
        NSString * idStr = [TBXML textForElement:idElement];
        
        TBXMLElement * importentElement = [TBXML childElementNamed:@"importent" parentElement:xmlElement];
        
        NSString * importentStr = [TBXML textForElement:importentElement];
        
        TBXMLElement * nameElement = [TBXML childElementNamed:@"name" parentElement:xmlElement];
        
        NSString * nameStr = [TBXML textForElement:nameElement];
        
        TBXMLElement * project_idElement = [TBXML childElementNamed:@"project_id" parentElement:xmlElement];
        
        NSString * project_idStr = [TBXML textForElement:project_idElement];
        
        TBXMLElement * titleElement = [TBXML childElementNamed:@"title" parentElement:xmlElement];
        
        NSString * titleStr = [TBXML textForElement:titleElement];
        
        TBXMLElement * typeElement = [TBXML childElementNamed:@"type" parentElement:xmlElement];
        
        NSString * typeStr = [TBXML textForElement:typeElement];
        
        TBXMLElement * urlElement = [TBXML childElementNamed:@"url" parentElement:xmlElement];
        
        NSString * urlStr = [TBXML textForElement:urlElement];
        
		dispatch_sync(dispatch_get_main_queue(), ^{
			NSManagedObjectContext *context=[MYAPPDELEGATE managedObjectContext];
			NSEntityDescription *entity=[NSEntityDescription entityForName:@"ReportAndAttechmentModel" inManagedObjectContext:context];
			report =[[ReportAndAttechmentModel alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
			report.identifier=idStr;
			report.importent=importentStr;
			report.name=nameStr;
			report.project_id=project_idStr;
			report.title=titleStr;
			report.type=typeStr;
			report.url=urlStr;
			
			NSError *error;
			if(![context save:&error])
			{
				NSLog(@" ReportAndAttechmentModel  不能保存：%@",[error localizedDescription]);
			}
		});
    }
	dispatch_sync(dispatch_get_main_queue(), ^{
		[MYAPPDELEGATE saveContext];
	});
    return report;
}

@end
