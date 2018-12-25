//
//  RoadModel.m
//  GDZhiFaJianGuanSystem
//
//  Created by luna on 14-2-10.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import "RoadModel.h"
#import "TBXML.h"


@implementation RoadModel

@dynamic code;
@dynamic delflag;
@dynamic identifier;
@dynamic name;
@dynamic place_end;
@dynamic place_start;
@dynamic remark;
@dynamic station_end;
@dynamic station_start;


+ (instancetype)newModelFromXML:(id)xml
{
    // 解析xml
    __block RoadModel *road = nil;
    TBXMLElement *xmlElement = NULL;
    [(NSValue *)xml getValue:&xmlElement];
    
    if (xmlElement) {
        // 解析xml
        
        TBXMLElement * codeElement = [TBXML childElementNamed:@"code" parentElement:xmlElement];
        
        NSString * codeStr = [TBXML textForElement:codeElement];
        
        TBXMLElement * delFlagElement = [TBXML childElementNamed:@"delflag" parentElement:xmlElement];
        
        NSString * delFlagStr = [TBXML textForElement:delFlagElement];
        
        TBXMLElement * idElement = [TBXML childElementNamed:@"id" parentElement:xmlElement];
        
        NSString * idStr = [TBXML textForElement:idElement];
        
        TBXMLElement * nameElement = [TBXML childElementNamed:@"name" parentElement:xmlElement];
        
        NSString * nameStr = [TBXML textForElement:nameElement];
        
        TBXMLElement * place_endElement = [TBXML childElementNamed:@"place_end" parentElement:xmlElement];
        
        NSString * place_endStr = [TBXML textForElement:place_endElement];
        
        TBXMLElement * place_startElement = [TBXML childElementNamed:@"place_start" parentElement:xmlElement];
        
        NSString * place_startStr = [TBXML textForElement:place_startElement];
        
        TBXMLElement * remarkElement = [TBXML childElementNamed:@"remark" parentElement:xmlElement];
        
        NSString * remarkStr = [TBXML textForElement:remarkElement];
        
        TBXMLElement * station_endElement = [TBXML childElementNamed:@"station_end" parentElement:xmlElement];
        
        NSString * station_endStr = [TBXML textForElement:station_endElement];
        
        TBXMLElement * station_startElement = [TBXML childElementNamed:@"station_start" parentElement:xmlElement];
        
        NSString * station_startStr = [TBXML textForElement:station_startElement];
        dispatch_sync(dispatch_get_main_queue(), ^{ 
			NSManagedObjectContext *context=[MYAPPDELEGATE managedObjectContext];
			NSEntityDescription *entity=[NSEntityDescription entityForName:@"RoadModel" inManagedObjectContext:context];
			road =[[RoadModel alloc] initWithEntity:entity insertIntoManagedObjectContext:context];

			road.identifier=idStr;
			road.code=codeStr;
			road.delflag=delFlagStr;
			road.name=nameStr;
			road.place_end=place_endStr;
			road.place_start=place_startStr;
			road.remark=remarkStr;
			road.station_end=station_endStr;
			road.station_start=station_startStr;

			NSError *error;
			if(![context save:&error])
			{
				NSLog(@" roadmodel  不能保存：%@",[error localizedDescription]);
			}
		});
    }
	dispatch_sync(dispatch_get_main_queue(), ^{ 
		[MYAPPDELEGATE saveContext];
	});	
    return road;
}


@end
