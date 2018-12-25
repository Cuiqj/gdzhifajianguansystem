//
//  RoadEngrossPriceModel.m
//  GDZhiFaJianGuanSystem
//
//  Created by luna on 14-3-3.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import "RoadEngrossPriceModel.h"


@implementation RoadEngrossPriceModel

@dynamic identifier;
@dynamic name;
@dynamic type;
@dynamic spec;
@dynamic price;
@dynamic unit_name;
@dynamic remark;
+ (instancetype)newModelFromXML:(id)xml
{
    // 解析xml
    RoadEngrossPriceModel *roadModel = nil;
    
    TBXMLElement *xmlElement = NULL;
    [(NSValue *)xml getValue:&xmlElement];
    
    if (xmlElement) {
        // 解析xml
        
        TBXMLElement * nameElement = [TBXML childElementNamed:@"name" parentElement:xmlElement];
        
        NSString * nameStr = [TBXML textForElement:nameElement];
        
        TBXMLElement * priceElement = [TBXML childElementNamed:@"price" parentElement:xmlElement];
        
        NSString * priceStr = [TBXML textForElement:priceElement];
        
        TBXMLElement * remarkElement = [TBXML childElementNamed:@"remark" parentElement:xmlElement];
        
        NSString * remarkStr = [TBXML textForElement:remarkElement];
        
        TBXMLElement * specElement = [TBXML childElementNamed:@"spec" parentElement:xmlElement];
        
        NSString * specStr = [TBXML textForElement:specElement];
        
        TBXMLElement * idElement = [TBXML childElementNamed:@"id" parentElement:xmlElement];
        
        NSString * idStr = [TBXML textForElement:idElement];
        
        TBXMLElement * typeElement = [TBXML childElementNamed:@"type" parentElement:xmlElement];
        
        NSString * typeStr = [TBXML textForElement:typeElement];
        
        TBXMLElement * unit_nameElement = [TBXML childElementNamed:@"unit_name" parentElement:xmlElement];
        
        NSString * unit_nameStr = [TBXML textForElement:unit_nameElement];
		NSManagedObjectContext *context=[MYAPPDELEGATE managedObjectContext];
		NSEntityDescription *entity=[NSEntityDescription entityForName:@"RoadEngrossPriceModel" inManagedObjectContext:context];
		roadModel =[[RoadEngrossPriceModel alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
		roadModel.name=nameStr;
		roadModel.price=[NSNumber numberWithDouble:priceStr.doubleValue];
		roadModel.remark=remarkStr;
		roadModel.spec=specStr;
		roadModel.identifier=idStr;
		roadModel.type=typeStr;
		roadModel.unit_name=unit_nameStr;
		NSError *error;
		if(![context save:&error])
		{
			NSLog(@" RoadAssetPriceModel  不能保存：%@",[error localizedDescription]);
		}

    }
	dispatch_sync(dispatch_get_main_queue(), ^{
		[MYAPPDELEGATE saveContext];
	});
    
    return roadModel;
}



+ (NSArray *)allInstances
{
	__block NSArray *temp = nil;
	NSManagedObjectContext *context=[MYAPPDELEGATE managedObjectContext];
	NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
	NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
	[fetchRequest setEntity:entity];
	[fetchRequest setPredicate:nil];
	temp = [context executeFetchRequest:fetchRequest error:nil];
	return temp;
}
@end
