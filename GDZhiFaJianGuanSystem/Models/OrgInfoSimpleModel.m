//
//  OrgInfoSimpleModel.m
//  GDZhiFaJianGuanSystem
//
//  Created by luna on 14-3-3.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import "OrgInfoSimpleModel.h"


@implementation OrgInfoSimpleModel

@dynamic belongtoOrgCode;
@dynamic orgName;
@dynamic orgShortName;
@dynamic org_tpye;
@dynamic lowerOrgId;
@dynamic identifier;
+ (instancetype)newModelFromXML:(id)xml
{
    // 解析xml
    __block OrgInfoSimpleModel *org = nil;
    
    TBXMLElement *xmlElement = NULL;
    [(NSValue *)xml getValue:&xmlElement];
    
    if (xmlElement) {
        // 解析xml
        
        TBXMLElement * belongtoOrgCodeElement = [TBXML childElementNamed:@"belongtoOrgCode" parentElement:xmlElement];
        
        NSString * belongtoOrgCodeStr = [TBXML textForElement:belongtoOrgCodeElement];
        

        
        TBXMLElement * idElement = [TBXML childElementNamed:@"id" parentElement:xmlElement];
        
        NSString * idStr = [TBXML textForElement:idElement];
        

        
        TBXMLElement * orgNameElement = [TBXML childElementNamed:@"orgName" parentElement:xmlElement];
        
        NSString * orgNameStr = [TBXML textForElement:orgNameElement];
        
        TBXMLElement * orgShortNameElement = [TBXML childElementNamed:@"orgShortName" parentElement:xmlElement];
        
        NSString * orgShortNameStr = [TBXML textForElement:orgShortNameElement];
        

        
        TBXMLElement * org_tpyeElement = [TBXML childElementNamed:@"org_tpye" parentElement:xmlElement];
        
        NSString * org_tpyeStr = [TBXML textForElement:org_tpyeElement];
        
        TBXMLElement * lowerOrgIdElement = [TBXML childElementNamed:@"lowerOrgId" parentElement:xmlElement];
        
        NSString * lowerOrgIdStr = [TBXML textForElement:lowerOrgIdElement];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
			NSManagedObjectContext *context=[MYAPPDELEGATE managedObjectContext];
			NSEntityDescription *entity=[NSEntityDescription entityForName:@"OrgInfoSimpleModel" inManagedObjectContext:context];
			org =[[OrgInfoSimpleModel alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
			org.belongtoOrgCode=belongtoOrgCodeStr;
			org.identifier=idStr;
			org.lowerOrgId=lowerOrgIdStr;
			org.orgName=orgNameStr;
			org.orgShortName=orgShortNameStr;
			org.org_tpye=org_tpyeStr;

			
			NSError *error;
			if(![context save:&error])
			{
				NSLog(@" OrgInfoSimpleModel  不能保存：%@",[error localizedDescription]);
			}
		});
    }
	dispatch_sync(dispatch_get_main_queue(), ^{
		[MYAPPDELEGATE saveContext];
    });
    return org;
}
@end
