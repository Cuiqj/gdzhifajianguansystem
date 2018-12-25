//
//  TaskSimpleModel.m
//  GDZhiFaJianGuanSystem
//
//  Created by luna on 14-2-25.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import "TaskSimpleModel.h"


@implementation TaskSimpleModel

@dynamic current_status;
@dynamic end_time;
@dynamic handle_orgid;
@dynamic handle_orgname;
@dynamic handle_username;
@dynamic identifier;
@dynamic next_task_id;
@dynamic node_id;
@dynamic node_name;
@dynamic previous_task_id;
@dynamic process_type;
@dynamic project_id;
@dynamic return_reson;
@dynamic start_time;
@dynamic timeout;
@dynamic user_account;

+ (instancetype)newModelFromXML:(id)xml
{
    // 解析xml
    __block TaskSimpleModel *task = nil;
    TBXMLElement *xmlElement = NULL;
    [(NSValue *)xml getValue:&xmlElement];
    
    if (xmlElement) {
        // 解析xml
        
        TBXMLElement * current_statusElement = [TBXML childElementNamed:@"current_status" parentElement:xmlElement];
        
        NSString * current_statusStr = [TBXML textForElement:current_statusElement];
        
        TBXMLElement * end_timeElement = [TBXML childElementNamed:@"end_time" parentElement:xmlElement];
        
        if (end_timeElement==NULL) {
            end_timeElement = nil;
        }
        
        NSString * end_timeStr = [TBXML textForElement:end_timeElement];
        
        TBXMLElement * handle_orgidElement = [TBXML childElementNamed:@"handle_orgid" parentElement:xmlElement];
        
        NSString * handle_orgidStr = [TBXML textForElement:handle_orgidElement];
        
        TBXMLElement * handle_orgnameElement = [TBXML childElementNamed:@"handle_orgname" parentElement:xmlElement];
        
        NSString * handle_orgnameStr = [TBXML textForElement:handle_orgnameElement];
        
        TBXMLElement * idElement = [TBXML childElementNamed:@"id" parentElement:xmlElement];
        
        NSString * idStr = [TBXML textForElement:idElement];
        
        TBXMLElement * handle_usernameElement = [TBXML childElementNamed:@"handle_username" parentElement:xmlElement];
        
        NSString * handle_usernameStr = [TBXML textForElement:handle_usernameElement];
        
        TBXMLElement * next_task_idElement = [TBXML childElementNamed:@"next_task_id" parentElement:xmlElement];
        
        NSString * next_task_idStr = [TBXML textForElement:next_task_idElement];
        
        TBXMLElement * node_idElement = [TBXML childElementNamed:@"node_id" parentElement:xmlElement];
        
        NSString * node_idStr = [TBXML textForElement:node_idElement];
        
        TBXMLElement * node_nameElement = [TBXML childElementNamed:@"node_name" parentElement:xmlElement];
        
        NSString * node_nameStr = [TBXML textForElement:node_nameElement];
        
        TBXMLElement * previous_task_idElement = [TBXML childElementNamed:@"previous_task_id" parentElement:xmlElement];
        
        NSString * previous_task_idStr = [TBXML textForElement:previous_task_idElement];
        
        TBXMLElement * process_typeElement = [TBXML childElementNamed:@"process_type" parentElement:xmlElement];
        
        NSString * process_typeStr = [TBXML textForElement:process_typeElement];
        
        TBXMLElement * project_idElement = [TBXML childElementNamed:@"project_id" parentElement:xmlElement];
        
        NSString * project_idStr = [TBXML textForElement:project_idElement];
        
        TBXMLElement * return_resonElement = [TBXML childElementNamed:@"return_reson" parentElement:xmlElement];
        
        NSString * return_resonStr = [TBXML textForElement:return_resonElement];
        
        TBXMLElement * start_timeElement = [TBXML childElementNamed:@"start_time" parentElement:xmlElement];
        
        NSString * start_timeStr = [TBXML textForElement:start_timeElement];
        
        TBXMLElement * timeoutElement = [TBXML childElementNamed:@"timeout" parentElement:xmlElement];
        
        NSString * timeoutStr = [TBXML textForElement:timeoutElement];
        
        TBXMLElement * user_accountElement = [TBXML childElementNamed:@"user_account" parentElement:xmlElement];
        
        NSString * user_accountStr = [TBXML textForElement:user_accountElement];
        
		dispatch_sync(dispatch_get_main_queue(), ^{
			NSManagedObjectContext *context=[MYAPPDELEGATE managedObjectContext];
			NSEntityDescription *entity=[NSEntityDescription entityForName:@"TaskSimpleModel" inManagedObjectContext:context];
			task =[[TaskSimpleModel alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
			task.identifier=idStr;
			task.handle_orgid=handle_orgidStr;
			task.handle_orgname=handle_orgnameStr;
			task.current_status=current_statusStr;
			task.handle_username=handle_usernameStr;
			task.next_task_id=next_task_idStr;
			task.node_name=node_nameStr;
			task.node_id=node_idStr;
			task.previous_task_id=previous_task_idStr;
			task.process_type=process_typeStr;
			task.project_id=project_idStr;
			task.return_reson=return_resonStr;
			task.timeout=timeoutStr;
			task.user_account=user_accountStr;
			
			if (start_timeStr!=nil) {
				task.start_time=[[start_timeStr componentsSeparatedByString:@"T"]objectAtIndex:0];
			}
			if (end_timeStr!=nil) {
				task.end_time=[[end_timeStr componentsSeparatedByString:@"T"]objectAtIndex:0];
			}
			
			NSError *error;
			if(![context save:&error])
			{
				NSLog(@" TaskSimpleModel  不能保存：%@",[error localizedDescription]);
			}
		});
    }
    dispatch_sync(dispatch_get_main_queue(), ^{
		[MYAPPDELEGATE saveContext];
	});
    return task;
}

@end
