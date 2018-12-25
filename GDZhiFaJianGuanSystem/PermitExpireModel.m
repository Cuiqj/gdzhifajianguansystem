//
//  PermitExpireModel.m
//  GDZhiFaJianGuanSystem
//
//  Created by yu hongwu on 14-9-18.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import "PermitExpireModel.h"


@implementation PermitExpireModel

@dynamic id;
@dynamic project_id;
@dynamic case_no;
@dynamic process_name;
@dynamic app_date;
@dynamic permission_address;
@dynamic date_step;
@dynamic applicant_name;
@dynamic date_end;
@dynamic date_diff;
@dynamic serialnumber;
@dynamic is_postponed;
@dynamic warningLevel;
+ (instancetype)newModelFromXML:(id)xml
{
    // 解析xml
    PermitExpireModel *permitExpireModel = nil;
    
    TBXMLElement *xmlElement = NULL;
    [(NSValue *)xml getValue:&xmlElement];	
	
    if (xmlElement) {
        // 解析xml
        
        TBXMLElement * idElement = [TBXML childElementNamed:@"id" parentElement:xmlElement];
        
        NSString * idStr = [TBXML textForElement:idElement];
        
        TBXMLElement * project_idElement = [TBXML childElementNamed:@"project_id" parentElement:xmlElement];
        
        NSString * project_idStr = [TBXML textForElement:project_idElement];
        
        TBXMLElement * case_noElement = [TBXML childElementNamed:@"case_no" parentElement:xmlElement];
        
        NSString * case_noStr = [TBXML textForElement:case_noElement];
        
        TBXMLElement * process_nameElement = [TBXML childElementNamed:@"process_name" parentElement:xmlElement];
        
        NSString * process_nameStr = [TBXML textForElement:process_nameElement];
        
        TBXMLElement * app_dateElement = [TBXML childElementNamed:@"app_date" parentElement:xmlElement];
        
        NSString * app_dateStr = [TBXML textForElement:app_dateElement];
        
		
        TBXMLElement * permission_addressElement = [TBXML childElementNamed:@"permission_address" parentElement:xmlElement];
        
        NSString * permission_addressStr = [TBXML textForElement:permission_addressElement];
		
		
        TBXMLElement * date_stepElement = [TBXML childElementNamed:@"date_step" parentElement:xmlElement];
        
        NSString * date_stepStr = [TBXML textForElement:date_stepElement];
		
		
		
        TBXMLElement * applicant_nameElement = [TBXML childElementNamed:@"applicant_name" parentElement:xmlElement];
        
        NSString * applicant_nameStr = [TBXML textForElement:applicant_nameElement];
        
		
        TBXMLElement * date_endElement = [TBXML childElementNamed:@"date_end" parentElement:xmlElement];
        
        NSString * date_endStr = [TBXML textForElement:date_endElement];
		
		
        TBXMLElement * date_diffElement = [TBXML childElementNamed:@"date_diff" parentElement:xmlElement];
        
        NSString * date_diffStr = [TBXML textForElement:date_diffElement];
		
		
		TBXMLElement * is_postponedElement = [TBXML childElementNamed:@"is_postponed" parentElement:xmlElement];
        
        NSString * is_postponedStr = [TBXML textForElement:is_postponedElement];
		
		
		
		TBXMLElement * warningLevelElement = [TBXML childElementNamed:@"warningLevel" parentElement:xmlElement];
        
        NSString * warningLevelStr = [TBXML textForElement:warningLevelElement];
		
		
		
        NSManagedObjectContext *context=[MYAPPDELEGATE managedObjectContext];
        NSEntityDescription *entity=[NSEntityDescription entityForName:@"PermitExpireModel" inManagedObjectContext:context];
        permitExpireModel =[[PermitExpireModel alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
        
		permitExpireModel.id= [NSNumber numberWithInt:[idStr longLongValue]];
        permitExpireModel.project_id = [NSNumber numberWithInt:[project_idStr longLongValue]];
		permitExpireModel.case_no = case_noStr;
		permitExpireModel.process_name = process_nameStr;
		
		NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
		[dateFormat setDateFormat:@"yyyy-MM-dd"];//设定时间格式,这里可以设置成自己需要的格式
		NSArray *array = [app_dateStr componentsSeparatedByString:@"T"];
		permitExpireModel.app_date = [dateFormat dateFromString:[array objectAtIndex:0]];
		permitExpireModel.permission_address = permission_addressStr;
		permitExpireModel.date_step = date_stepStr;
		permitExpireModel.applicant_name = applicant_nameStr;
		permitExpireModel.date_step = date_stepStr;
		permitExpireModel.date_diff = [NSNumber numberWithInt:[date_diffStr intValue]];
		permitExpireModel.date_end = [dateFormat dateFromString:date_endStr];;
        permitExpireModel.is_postponed = [NSNumber numberWithInt:[is_postponedStr intValue]];
		permitExpireModel.warningLevel = [NSNumber numberWithInt:[warningLevelStr intValue]];
        NSError *error;
        if(![context save:&error])
        {
            NSLog(@" PermitExpireModel  不能保存：%@",[error localizedDescription]);
        }
    }
    
    [MYAPPDELEGATE saveContext];
    return permitExpireModel;
}
+(instancetype)newModel{
	PermitExpireModel *permitExpireModel = nil;
	NSManagedObjectContext *context=[MYAPPDELEGATE managedObjectContext];
	NSEntityDescription *entity=[NSEntityDescription entityForName:@"PermitExpireModel" inManagedObjectContext:context];
	permitExpireModel =[[PermitExpireModel alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
	NSError *error;
	if(![context save:&error])
	{
		NSLog(@" PermitExpireModel  不能保存：%@",[error localizedDescription]);
	}
	[MYAPPDELEGATE saveContext];
    return permitExpireModel;
}

@end
