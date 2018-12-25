//
//  LawItemsModel.m
//  GDZhiFaJianGuanSystem
//
//  Created by luna on 14-2-17.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import "LawItemsModel.h"
#import "TBXML.h"


@implementation LawItemsModel

@dynamic identifier;
@dynamic law_id;
@dynamic lawitem_desc;
@dynamic lawitem_no;
@dynamic remark;

+ (instancetype)newModelFromXML:(id)xml
{
    // 解析xml
    __block LawItemsModel *lawItem = nil;
    
    TBXMLElement *xmlElement = NULL;
    [(NSValue *)xml getValue:&xmlElement];
    
    if (xmlElement) {
        // 解析xml
        
        TBXMLElement * law_idElement = [TBXML childElementNamed:@"law_id" parentElement:xmlElement];
        
        NSString * law_idStr = [TBXML textForElement:law_idElement];
        
        TBXMLElement * lawitem_descElement = [TBXML childElementNamed:@"lawitem_desc" parentElement:xmlElement];
        
        NSString * lawitem_descStr = [TBXML textForElement:lawitem_descElement];
        
        TBXMLElement * lawitem_noElement = [TBXML childElementNamed:@"lawitem_no" parentElement:xmlElement];
        
        NSString * lawitem_noStr = [TBXML textForElement:lawitem_noElement];
        
        TBXMLElement * idElement = [TBXML childElementNamed:@"id" parentElement:xmlElement];
        
        NSString * idStr = [TBXML textForElement:idElement];
        
        TBXMLElement * remarkElement = [TBXML childElementNamed:@"remark" parentElement:xmlElement];
        
        NSString * remarkStr = [TBXML textForElement:remarkElement];
        
		
		dispatch_sync(dispatch_get_main_queue(), ^{
			NSManagedObjectContext *context=[MYAPPDELEGATE managedObjectContext];
			NSEntityDescription *entity=[NSEntityDescription entityForName:@"LawItemsModel" inManagedObjectContext:context];
			lawItem =[[LawItemsModel alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
			lawItem.identifier=idStr;
			lawItem.remark=remarkStr;
			lawItem.law_id=law_idStr;
			lawItem.lawitem_desc=lawitem_descStr;
			lawItem.lawitem_no=lawitem_noStr;
			
			NSError *error;
			if(![context save:&error])
			{
				NSLog(@" LawItemsModel  不能保存：%@",[error localizedDescription]);
			}
		});
    }
    dispatch_sync(dispatch_get_main_queue(), ^{
		[MYAPPDELEGATE saveContext];
	});
    return lawItem;
}

@end
