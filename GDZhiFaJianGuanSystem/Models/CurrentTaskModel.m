//
//  CurrentTaskModel.m
//  GDZhiFaJianGuanSystem
//
//  Created by luna on 14-2-21.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import "CurrentTaskModel.h"
#import "TBXML.h"

@implementation CurrentTaskModel

@dynamic app_no;
@dynamic applicant_name;
@dynamic current_status;
@dynamic currentUserAccount;
@dynamic currentUserName;
@dynamic end_time;
@dynamic identifier;
@dynamic importent;
@dynamic lastUserAccount;
@dynamic lastUserName;
@dynamic name1;
@dynamic name2;
@dynamic nodeId;
@dynamic nodeName;
@dynamic org_id;
@dynamic project_id;
@dynamic signDate;
@dynamic signName;
@dynamic signOption;
@dynamic start_time;
@dynamic timeout;
@dynamic title;
@dynamic yijian1;
@dynamic yijian2;
@dynamic date_cut;
+ (instancetype)newModelFromXML:(id)xml
{
    // 解析xml
    __block CurrentTaskModel *currentTask = nil;
    TBXMLElement *xmlElement = NULL;
    [(NSValue *)xml getValue:&xmlElement];
    
    if (xmlElement) {
        // 解析xml
        
        TBXMLElement * app_noElement = [TBXML childElementNamed:@"app_no" parentElement:xmlElement];
        
        NSString * app_noStr = [TBXML textForElement:app_noElement];
        
        TBXMLElement * applicant_nameElement = [TBXML childElementNamed:@"applicant_name" parentElement:xmlElement];
        
        NSString * applicant_nameStr = [TBXML textForElement:applicant_nameElement];
        
        TBXMLElement * currentUserAccountElement = [TBXML childElementNamed:@"currentUserAccount" parentElement:xmlElement];
        
        NSString * currentUserAccountStr = [TBXML textForElement:currentUserAccountElement];
        
        TBXMLElement * currentUserNameElement = [TBXML childElementNamed:@"currentUserName" parentElement:xmlElement];
        
        NSString * currentUserNameStr = [TBXML textForElement:currentUserNameElement];
        
        TBXMLElement * idElement = [TBXML childElementNamed:@"id" parentElement:xmlElement];
        
        NSString * idStr = [TBXML textForElement:idElement];
        
        TBXMLElement * current_statusElement = [TBXML childElementNamed:@"current_status" parentElement:xmlElement];
        
        NSString * current_statusStr = [TBXML textForElement:current_statusElement];
        
        TBXMLElement * importentElement = [TBXML childElementNamed:@"importent" parentElement:xmlElement];
        
        NSString * importentStr = [TBXML textForElement:importentElement];
        
        TBXMLElement * lastUserAccountElement = [TBXML childElementNamed:@"lastUserAccount" parentElement:xmlElement];
        
        NSString * lastUserAccountStr = [TBXML textForElement:lastUserAccountElement];
        
        TBXMLElement * lastUserNameElement = [TBXML childElementNamed:@"lastUserName" parentElement:xmlElement];
        
        NSString * lastUserNameStr = [TBXML textForElement:lastUserNameElement];
        
        TBXMLElement * name1Element = [TBXML childElementNamed:@"name1" parentElement:xmlElement];
        
        NSString * name1Str = [TBXML textForElement:name1Element];
        
        TBXMLElement * name2Element = [TBXML childElementNamed:@"name2" parentElement:xmlElement];
        
        NSString * name2Str = [TBXML textForElement:name2Element];
        
        TBXMLElement * nodeIdElement = [TBXML childElementNamed:@"nodeId" parentElement:xmlElement];
        
        NSString * nodeIdStr = [TBXML textForElement:nodeIdElement];
        
        TBXMLElement * nodeNameElement = [TBXML childElementNamed:@"nodeName" parentElement:xmlElement];
        
        NSString * nodeNameStr = [TBXML textForElement:nodeNameElement];
        
        TBXMLElement * org_idElement = [TBXML childElementNamed:@"org_id" parentElement:xmlElement];
        
        NSString * org_idStr = [TBXML textForElement:org_idElement];
        
        TBXMLElement * project_idElement = [TBXML childElementNamed:@"project_id" parentElement:xmlElement];
        
        NSString * project_idStr = [TBXML textForElement:project_idElement];
        
        TBXMLElement * yijian1Element = [TBXML childElementNamed:@"yijian1" parentElement:xmlElement];
        
        NSString * yijian1Str = [TBXML textForElement:yijian1Element];
        
        TBXMLElement * yijian2Element = [TBXML childElementNamed:@"yijian2" parentElement:xmlElement];
        
        NSString * yijian2Str = [TBXML textForElement:yijian2Element];
        
        TBXMLElement * start_timeElement = [TBXML childElementNamed:@"start_time" parentElement:xmlElement];
        
        NSString * start_timeStr = [TBXML textForElement:start_timeElement];
        
        TBXMLElement * timeoutElement = [TBXML childElementNamed:@"timeout" parentElement:xmlElement];
        
        NSString * timeoutStr = [TBXML textForElement:timeoutElement];
        
        TBXMLElement * titleElement = [TBXML childElementNamed:@"title" parentElement:xmlElement];
        
        NSString * titleStr = [TBXML textForElement:titleElement];
        
        TBXMLElement * date_cutElement = [TBXML childElementNamed:@"date_cut" parentElement:xmlElement];
        
        NSString * date_cutStr = [TBXML textForElement:date_cutElement];
        
		
		dispatch_sync(dispatch_get_main_queue(), ^{
			NSManagedObjectContext *context=[MYAPPDELEGATE managedObjectContext];
			NSEntityDescription *entity=[NSEntityDescription entityForName:@"CurrentTaskModel" inManagedObjectContext:context];
			currentTask =[[CurrentTaskModel alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
			currentTask.identifier=idStr;
			currentTask.currentUserAccount=currentUserAccountStr;
			currentTask.currentUserName=currentUserNameStr;
			currentTask.current_status=current_statusStr;
			currentTask.importent=importentStr;
			currentTask.lastUserAccount=lastUserAccountStr;
			currentTask.lastUserName=lastUserNameStr;
			currentTask.nodeId=nodeIdStr;
			currentTask.nodeName=nodeNameStr;
			currentTask.org_id=org_idStr;
			currentTask.project_id=project_idStr;
			currentTask.app_no=app_noStr;
			currentTask.timeout=timeoutStr;
			currentTask.title=titleStr;
			currentTask.applicant_name=applicant_nameStr;
			currentTask.name1=name1Str;
			currentTask.name2=name2Str;
			currentTask.yijian1=yijian1Str;
			currentTask.yijian2=yijian2Str;
			currentTask.start_time=start_timeStr;
			if (date_cutStr!=nil) {
				currentTask.date_cut=[[date_cutStr componentsSeparatedByString:@"T"]objectAtIndex:0];
			}
			
			NSError *error;
			if(![context save:&error])
			{
				NSLog(@" CurrentTaskModel  不能保存：%@",[error localizedDescription]);
			}
		});
    }
    dispatch_sync(dispatch_get_main_queue(), ^{
		[MYAPPDELEGATE saveContext];
	});
    return currentTask;
}
@end
