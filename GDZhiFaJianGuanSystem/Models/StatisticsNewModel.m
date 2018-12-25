//
//  StatisticsNewModel.m
//  GDZhiFaJianGuanSystem
//
//  Created by yu hongwu on 14-9-15.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import "StatisticsNewModel.h"


@implementation StatisticsNewModel

@dynamic names;
@dynamic num_begin;
@dynamic num_end;
@dynamic num_notend;
@dynamic types;
@dynamic money_fact;
@dynamic money_count;
+ (instancetype)newModelFromXML:(id)xml
{
    // 解析xml
    __block StatisticsNewModel *statisticsNewModel = nil;
    
    TBXMLElement *xmlElement = NULL;
    [(NSValue *)xml getValue:&xmlElement];
    
    if (xmlElement) {
        // 解析xml
        
        TBXMLElement * namesElement = [TBXML childElementNamed:@"names" parentElement:xmlElement];
        
        NSString * namesStr = [TBXML textForElement:namesElement];
        
        TBXMLElement * num_beginElement = [TBXML childElementNamed:@"num_begin" parentElement:xmlElement];
        
        NSString * num_beginStr = [TBXML textForElement:num_beginElement];
        
        TBXMLElement * num_endElement = [TBXML childElementNamed:@"num_end" parentElement:xmlElement];
        
        NSString * num_endStr = [TBXML textForElement:num_endElement];
        
        TBXMLElement * num_notendElement = [TBXML childElementNamed:@"num_notend" parentElement:xmlElement];
        
        NSString * num_notendStr = [TBXML textForElement:num_notendElement];
        
        TBXMLElement * typesElement = [TBXML childElementNamed:@"types" parentElement:xmlElement];
        
        NSString * typesStr = [TBXML textForElement:typesElement];
        
		TBXMLElement * money_countElement = [TBXML childElementNamed:@"money_count" parentElement:xmlElement];
        
        NSString * money_countStr = [TBXML textForElement:money_countElement];
		
		TBXMLElement * money_factElement = [TBXML childElementNamed:@"money_fact" parentElement:xmlElement];
        
        NSString * money_factStr = [TBXML textForElement:money_factElement];
        
	
        
        
        
        dispatch_sync(dispatch_get_main_queue(), ^{
			NSManagedObjectContext *context=[MYAPPDELEGATE managedObjectContext];
			NSEntityDescription *entity=[NSEntityDescription entityForName:@"StatisticsNewModel" inManagedObjectContext:context];
			statisticsNewModel =[[StatisticsNewModel alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
			
			statisticsNewModel.names=namesStr;
			statisticsNewModel.num_begin= [NSNumber numberWithInt:[num_beginStr intValue]];
			statisticsNewModel.num_end=[NSNumber numberWithInt:[num_endStr intValue]];
			statisticsNewModel.num_notend=[NSNumber numberWithInt:[num_notendStr intValue]];
			statisticsNewModel.money_count=[NSNumber numberWithInt:[money_countStr doubleValue]];
			statisticsNewModel.money_fact=[NSNumber numberWithInt:[money_factStr doubleValue]];;
			statisticsNewModel.types=typesStr;
			
			
			NSError *error;
			if(![context save:&error])
			{
				NSLog(@" StatisticsNewModel  不能保存：%@",[error localizedDescription]);
			}
		});
    }
	dispatch_sync(dispatch_get_main_queue(), ^{
		[MYAPPDELEGATE saveContext];
	});
    return statisticsNewModel;
}
+(instancetype)newModel{
	StatisticsNewModel *statisticsNewModel = nil;
	NSManagedObjectContext *context=[MYAPPDELEGATE managedObjectContext];
	NSEntityDescription *entity=[NSEntityDescription entityForName:@"StatisticsNewModel" inManagedObjectContext:context];
	statisticsNewModel =[[StatisticsNewModel alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
	NSError *error;
	if(![context save:&error])
	{
		NSLog(@" StatisticsNewModel  不能保存：%@",[error localizedDescription]);
	}
	[MYAPPDELEGATE saveContext];

	return statisticsNewModel;
}
@end
