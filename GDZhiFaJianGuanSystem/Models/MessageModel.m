//
//  MessageModel.m
//  GDZhiFaJianGuanSystem
//
//  Created by luna on 14-3-18.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import "MessageModel.h"


@implementation MessageModel

@dynamic content;
@dynamic has_file;
@dynamic identifier;
@dynamic is_readed;
@dynamic org_id;
@dynamic reader;
@dynamic send_date;
@dynamic sender_email;
@dynamic sender_id;
@dynamic sender_name;
@dynamic title;
@dynamic type_code;

+ (instancetype)newModelFromXML:(id)xml
{
    // 解析xml
    __block MessageModel *message = nil;
    TBXMLElement *xmlElement = NULL;
    [(NSValue *)xml getValue:&xmlElement];
    
    if (xmlElement) {
        // 解析xml
        
        TBXMLElement * contentElement = [TBXML childElementNamed:@"content" parentElement:xmlElement];
        
        NSString * contentStr = [TBXML textForElement:contentElement];
        
        TBXMLElement * has_fileElement = [TBXML childElementNamed:@"has_file" parentElement:xmlElement];
        
        NSString * has_fileStr = [TBXML textForElement:has_fileElement];
        
        TBXMLElement * idElement = [TBXML childElementNamed:@"id" parentElement:xmlElement];
        
        NSString * idStr = [TBXML textForElement:idElement];
        
        TBXMLElement * is_readedElement = [TBXML childElementNamed:@"is_readed" parentElement:xmlElement];
        
        NSString * is_readedStr = [TBXML textForElement:is_readedElement];
        
        TBXMLElement * org_idElement = [TBXML childElementNamed:@"org_id" parentElement:xmlElement];
        
        NSString * org_idStr = [TBXML textForElement:org_idElement];
        
        TBXMLElement * readerElement = [TBXML childElementNamed:@"reader" parentElement:xmlElement];
        
        NSString * readerStr = [TBXML textForElement:readerElement];
        
        TBXMLElement * send_dateElement = [TBXML childElementNamed:@"send_date" parentElement:xmlElement];
        
        NSString * send_dateStr = [TBXML textForElement:send_dateElement];
        
        TBXMLElement * senderElement = [TBXML childElementNamed:@"sender" parentElement:xmlElement];
        
        NSString * senderStr = [TBXML textForElement:senderElement];
        
        TBXMLElement * sender_emailElement = [TBXML childElementNamed:@"sender_email" parentElement:xmlElement];
        
        NSString * sender_emailStr = [TBXML textForElement:sender_emailElement];
        
        TBXMLElement * sender_idElement = [TBXML childElementNamed:@"sender_id" parentElement:xmlElement];
        
        NSString * sender_idStr = [TBXML textForElement:sender_idElement];
        
        TBXMLElement * titleElement = [TBXML childElementNamed:@"title" parentElement:xmlElement];
        
        NSString * titleStr = [TBXML textForElement:titleElement];
        
        TBXMLElement * type_codeElement = [TBXML childElementNamed:@"type_code" parentElement:xmlElement];
        
        NSString * type_codeStr = [TBXML textForElement:type_codeElement];
        
		dispatch_sync(dispatch_get_main_queue(), ^{
			NSManagedObjectContext *context=[MYAPPDELEGATE managedObjectContext];
			NSEntityDescription *entity=[NSEntityDescription entityForName:@"MessageModel" inManagedObjectContext:context];
			message =[[MessageModel alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
			message.identifier=idStr;
			message.content=contentStr;
			message.has_file=has_fileStr;
			message.is_readed=is_readedStr;
			message.reader=readerStr;
			message.sender_name=senderStr;
			message.sender_email=sender_emailStr;
			message.sender_id=sender_idStr;
			message.org_id=org_idStr;
			message.type_code=type_codeStr;
			message.title=titleStr;
			
			if (send_dateStr!=nil) {
				message.send_date=[[send_dateStr componentsSeparatedByString:@"T"]objectAtIndex:0];
			}
			
			NSError *error;
			if(![context save:&error])
			{
				NSLog(@" MessageModel  不能保存：%@",[error localizedDescription]);
			}
		});
    }
    
    [MYAPPDELEGATE saveContext];
    return message;
}

@end
