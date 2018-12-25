//
//  OrgArticleModel.m
//  GDZhiFaJianGuanSystem
//
//  Created by luna on 14-2-25.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import "OrgArticleModel.h"


@implementation OrgArticleModel

@dynamic belowOrg;
@dynamic content;
@dynamic delFlag;
@dynamic identifier;
@dynamic keywords;
@dynamic org_id;
@dynamic orgIds;
@dynamic orgnames;
@dynamic picture_url;
@dynamic publicize_date;
@dynamic read_count;
@dynamic readedOrg;
@dynamic remark;
@dynamic senderPerson;
@dynamic senderAccount;
@dynamic side_title;
@dynamic title;
@dynamic type_code;
+ (instancetype)newModelFromXML:(id)xml
{
    // 解析xml
    __block OrgArticleModel *orgArticle = nil;
    
    TBXMLElement *xmlElement = NULL;
    [(NSValue *)xml getValue:&xmlElement];
    
    if (xmlElement) {
        // 解析xml
        
        TBXMLElement * belowOrgElement = [TBXML childElementNamed:@"belowOrg" parentElement:xmlElement];
        
        NSString * belowOrgStr = [TBXML textForElement:belowOrgElement];
        
        TBXMLElement * delFlagElement = [TBXML childElementNamed:@"delFlag" parentElement:xmlElement];
        
        NSString * delFlagStr = [TBXML textForElement:delFlagElement];
        
        TBXMLElement * idElement = [TBXML childElementNamed:@"id" parentElement:xmlElement];
        
        NSString * idStr = [TBXML textForElement:idElement];
        
        TBXMLElement * contentElement = [TBXML childElementNamed:@"content" parentElement:xmlElement];
        
        NSString * contentStr = [TBXML textForElement:contentElement];
        
        TBXMLElement * keywordsElement = [TBXML childElementNamed:@"keywords" parentElement:xmlElement];
        
        NSString * keywordsStr = [TBXML textForElement:keywordsElement];
        
        TBXMLElement * orgIdsElement = [TBXML childElementNamed:@"orgIds" parentElement:xmlElement];
        
        NSString * orgIdsStr = [TBXML textForElement:orgIdsElement];
        
        TBXMLElement * remarkElement = [TBXML childElementNamed:@"remark" parentElement:xmlElement];
        
        NSString * remarkStr = [TBXML textForElement:remarkElement];
        
        TBXMLElement * org_idElement = [TBXML childElementNamed:@"org_id" parentElement:xmlElement];
        
        NSString * org_idStr = [TBXML textForElement:org_idElement];
        
        TBXMLElement * orgnamesElement = [TBXML childElementNamed:@"orgnames" parentElement:xmlElement];
        
        NSString * orgnamesStr = [TBXML textForElement:orgnamesElement];
        
        TBXMLElement * picture_urlElement = [TBXML childElementNamed:@"picture_url" parentElement:xmlElement];
        
        NSString * picture_urlStr = [TBXML textForElement:picture_urlElement];
        
        TBXMLElement * publicize_dateElement = [TBXML childElementNamed:@"publicize_date" parentElement:xmlElement];
        
        NSString * publicize_dateStr = [TBXML textForElement:publicize_dateElement];
        
        TBXMLElement * read_countElement = [TBXML childElementNamed:@"read_count" parentElement:xmlElement];
        
        NSString * read_countStr = [TBXML textForElement:read_countElement];
        
        TBXMLElement * readedOrgElement = [TBXML childElementNamed:@"readedOrg" parentElement:xmlElement];
        
        NSString * readedOrgStr = [TBXML textForElement:readedOrgElement];
        
        TBXMLElement * senderElement = [TBXML childElementNamed:@"sender" parentElement:xmlElement];
        
        NSString * senderStr = [TBXML textForElement:senderElement];
        
        TBXMLElement * senderAccountElement = [TBXML childElementNamed:@"senderAccount" parentElement:xmlElement];
        
        NSString * senderAccountStr = [TBXML textForElement:senderAccountElement];
        
        TBXMLElement * side_titleElement = [TBXML childElementNamed:@"side_title" parentElement:xmlElement];
        
        NSString * side_titleStr = [TBXML textForElement:side_titleElement];
        
        TBXMLElement * titleElement = [TBXML childElementNamed:@"title" parentElement:xmlElement];
        
        NSString * titleStr = [TBXML textForElement:titleElement];
        
        TBXMLElement * type_codeElement = [TBXML childElementNamed:@"type_code" parentElement:xmlElement];
        
        NSString * type_codeStr = [TBXML textForElement:type_codeElement];
        
		dispatch_sync(dispatch_get_main_queue(), ^{
			NSManagedObjectContext *context=[MYAPPDELEGATE managedObjectContext];
			NSEntityDescription *entity=[NSEntityDescription entityForName:@"OrgArticleModel" inManagedObjectContext:context];
			orgArticle =[[OrgArticleModel alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
			
			orgArticle.identifier=idStr;
			orgArticle.belowOrg=belowOrgStr;
			orgArticle.delFlag=delFlagStr;
			orgArticle.content=contentStr;
			orgArticle.keywords=keywordsStr;
			orgArticle.orgIds=orgIdsStr;
			orgArticle.remark=remarkStr;
			orgArticle.org_id=org_idStr;
			orgArticle.orgnames=orgnamesStr;
			orgArticle.picture_url=picture_urlStr;
			orgArticle.read_count=read_countStr;
			orgArticle.readedOrg=readedOrgStr;
			orgArticle.senderPerson=senderStr;
			orgArticle.senderAccount=senderAccountStr;
			orgArticle.side_title=side_titleStr;
			orgArticle.title=titleStr;
			orgArticle.type_code=type_codeStr;
			
			if (publicize_dateStr!=nil) {
				orgArticle.publicize_date=[[publicize_dateStr componentsSeparatedByString:@"T"]objectAtIndex:0];
			}
			
			NSError *error;
			if(![context save:&error])
			{
				NSLog(@" OrgArticleModel  不能保存：%@",[error localizedDescription]);
			}
		});
    }
    dispatch_sync(dispatch_get_main_queue(), ^{
		[MYAPPDELEGATE saveContext];
	});
    return orgArticle;
}
@end
