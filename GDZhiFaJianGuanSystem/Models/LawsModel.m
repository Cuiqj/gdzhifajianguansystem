//
//  LawsModel.m
//  GDZhiFaJianGuanSystem
//
//  Created by luna on 14-2-17.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import "LawsModel.h"
#import "TBXML.h"

@implementation LawsModel

@dynamic caption;
@dynamic dept;
@dynamic identifier;
@dynamic law_type;
@dynamic org_id;
@dynamic put_flag;
@dynamic remark;

+ (instancetype)newModelFromXML:(id)xml
{
    // 解析xml
    __block LawsModel *laws = nil;
    TBXMLElement *xmlElement = NULL;
    [(NSValue *)xml getValue:&xmlElement];
    
    if (xmlElement) {
        // 解析xml
        
        TBXMLElement * captionElement = [TBXML childElementNamed:@"caption" parentElement:xmlElement];
        
        NSString * captionStr = [TBXML textForElement:captionElement];
        
        TBXMLElement * deptElement = [TBXML childElementNamed:@"dept" parentElement:xmlElement];
        
        NSString * deptStr = [TBXML textForElement:deptElement];
        
        TBXMLElement * idElement = [TBXML childElementNamed:@"id" parentElement:xmlElement];
        
        NSString * idStr = [TBXML textForElement:idElement];
        
        TBXMLElement * law_typeElement = [TBXML childElementNamed:@"law_type" parentElement:xmlElement];
        
        NSString * law_typeStr = [TBXML textForElement:law_typeElement];
        
        TBXMLElement * org_idElement = [TBXML childElementNamed:@"org_id" parentElement:xmlElement];
        
        NSString * org_idStr = [TBXML textForElement:org_idElement];
        
        TBXMLElement * put_flagElement = [TBXML childElementNamed:@"put_flag" parentElement:xmlElement];
        
        NSString * put_flagStr = [TBXML textForElement:put_flagElement];
        
        TBXMLElement * remarkElement = [TBXML childElementNamed:@"remark" parentElement:xmlElement];
        
        NSString * remarkStr = [TBXML textForElement:remarkElement];
        dispatch_sync(dispatch_get_main_queue(), ^{
			NSManagedObjectContext *context=[MYAPPDELEGATE managedObjectContext];
			NSEntityDescription *entity=[NSEntityDescription entityForName:@"LawsModel" inManagedObjectContext:context];
			laws =[[LawsModel alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
			
			laws.identifier=idStr;
			laws.caption=captionStr;
			laws.dept=deptStr;
			laws.law_type=law_typeStr;
			laws.org_id=org_idStr;
			laws.put_flag=put_flagStr;
			laws.remark=remarkStr;
			
			NSError *error;
			if(![context save:&error])
			{
				NSLog(@" LawsModel  不能保存：%@",[error localizedDescription]);
			}
		});
    }
    dispatch_sync(dispatch_get_main_queue(), ^{
		[MYAPPDELEGATE saveContext];
	});
    return laws;
}

@end
