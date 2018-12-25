//
//  AllPermitModel.m
//  GDZhiFaJianGuanSystem
//
//  Created by luna on 14-2-10.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import "AllPermitModel.h"
#import "TBXML.h"


@implementation AllPermitModel

@dynamic admissible_date;
@dynamic anjuan_no;
@dynamic app_date;
@dynamic app_name;
@dynamic app_no;
@dynamic app_type;
@dynamic applicant_address;
@dynamic applicant_flag;
@dynamic applicant_name;
@dynamic baomi_type;
@dynamic countychbname1;
@dynamic countychbtime1;
@dynamic countychbyijian1;
@dynamic countyjigname2;
@dynamic countyjigtime2;
@dynamic countyjigyijian2;
@dynamic countyledname3;
@dynamic countyledtime3;
@dynamic countyledyijian3;
@dynamic danganshi_no;
@dynamic date_step;
@dynamic identifier;
@dynamic importent;
@dynamic legal_spokesman;
@dynamic limit;
@dynamic org_id;
@dynamic paysum;
@dynamic permission_address;
@dynamic quanzong_no;
@dynamic reason;
@dynamic reason_detail;
@dynamic status;
@dynamic title;


+ (instancetype)newModelFromXML:(id)xml
{
    // 解析xml
    __block AllPermitModel *allPermit = nil;
    TBXMLElement *xmlElement = NULL;
    [(NSValue *)xml getValue:&xmlElement];
    
    if (xmlElement) {
        // 解析xml
        
        TBXMLElement * admissible_dateElement = [TBXML childElementNamed:@"admissible_date" parentElement:xmlElement];
        
        NSString * admissible_dateStr = [TBXML textForElement:admissible_dateElement];
        
        TBXMLElement * anjuan_noElement = [TBXML childElementNamed:@"anjuan_no" parentElement:xmlElement];
        
        NSString * anjuan_noStr = [TBXML textForElement:anjuan_noElement];
        
        TBXMLElement * app_dateElement = [TBXML childElementNamed:@"app_date" parentElement:xmlElement];
        
        NSString * app_dateStr = [TBXML textForElement:app_dateElement];
        
        TBXMLElement * app_nameElement = [TBXML childElementNamed:@"app_name" parentElement:xmlElement];
        
        NSString * app_nameStr = [TBXML textForElement:app_nameElement];
        
        TBXMLElement * app_noElement = [TBXML childElementNamed:@"app_no" parentElement:xmlElement];
        
        NSString * app_noStr = [TBXML textForElement:app_noElement];
        
        TBXMLElement * app_typeElement = [TBXML childElementNamed:@"app_type" parentElement:xmlElement];
        
        NSString * app_typeStr = [TBXML textForElement:app_typeElement];
        
        TBXMLElement * applicant_addressElement = [TBXML childElementNamed:@"applicant_address" parentElement:xmlElement];
        
        NSString * applicant_addressStr = [TBXML textForElement:applicant_addressElement];
        
        TBXMLElement * idElement = [TBXML childElementNamed:@"id" parentElement:xmlElement];
        
        NSString * idStr = [TBXML textForElement:idElement];
        
        TBXMLElement * applicant_flagElement = [TBXML childElementNamed:@"applicant_flag" parentElement:xmlElement];
        
        NSString * applicant_flagStr = [TBXML textForElement:applicant_flagElement];
        
        TBXMLElement * applicant_nameElement = [TBXML childElementNamed:@"applicant_name" parentElement:xmlElement];
        
        NSString * applicant_nameStr = [TBXML textForElement:applicant_nameElement];
        
        TBXMLElement * baomi_typeElement = [TBXML childElementNamed:@"baomi_type" parentElement:xmlElement];
        
        NSString * baomi_typeStr = [TBXML textForElement:baomi_typeElement];
        
        TBXMLElement * countychbname1Element = [TBXML childElementNamed:@"countychbname1" parentElement:xmlElement];
        
        NSString * countychbname1Str = [TBXML textForElement:countychbname1Element];
        
//        TBXMLElement * countychbtime1Element = [TBXML childElementNamed:@"countychbtime1" parentElement:xmlElement];
//        
//        NSString * countychbtime1Str = [TBXML textForElement:countychbtime1Element];
        
        TBXMLElement * countychbyijian1Element = [TBXML childElementNamed:@"countychbyijian1" parentElement:xmlElement];
        
        NSString * countychbyijian1Str = [TBXML textForElement:countychbyijian1Element];
        
        TBXMLElement * countyjigname2Element = [TBXML childElementNamed:@"countyjigname2" parentElement:xmlElement];
        
        NSString * countyjigname2Str = [TBXML textForElement:countyjigname2Element];
        
//        TBXMLElement * countyjigtime2Element = [TBXML childElementNamed:@"countyjigtime2" parentElement:xmlElement];
//        
//        NSString * countyjigtime2Str = [TBXML textForElement:countyjigtime2Element];
        
        TBXMLElement * countyjigyijian2Element = [TBXML childElementNamed:@"countyjigyijian2" parentElement:xmlElement];
        
        NSString * countyjigyijian2Str = [TBXML textForElement:countyjigyijian2Element];
        
        TBXMLElement * countyledname3Element = [TBXML childElementNamed:@"countyledname3" parentElement:xmlElement];
        
        NSString * countyledname3Str = [TBXML textForElement:countyledname3Element];
        
        TBXMLElement * countyledyijian3Element = [TBXML childElementNamed:@"countyledyijian3" parentElement:xmlElement];
        
        NSString * countyledyijian3Str = [TBXML textForElement:countyledyijian3Element];
        
        TBXMLElement * danganshi_noElement = [TBXML childElementNamed:@"danganshi_no" parentElement:xmlElement];
        
        NSString * danganshi_noStr = [TBXML textForElement:danganshi_noElement];
        
        TBXMLElement * date_stepElement = [TBXML childElementNamed:@"date_step" parentElement:xmlElement];
        
        NSString * date_stepStr = [TBXML textForElement:date_stepElement];
        
        TBXMLElement * importentElement = [TBXML childElementNamed:@"importent" parentElement:xmlElement];
        
        NSString * importentStr = [TBXML textForElement:importentElement];
        
        TBXMLElement * legal_spokesmanElement = [TBXML childElementNamed:@"legal_spokesman" parentElement:xmlElement];
        
        NSString * legal_spokesmanStr = [TBXML textForElement:legal_spokesmanElement];
        
        TBXMLElement * limitElement = [TBXML childElementNamed:@"limit" parentElement:xmlElement];
        
        NSString * limitStr = [TBXML textForElement:limitElement];
        
        TBXMLElement * org_idElement = [TBXML childElementNamed:@"org_id" parentElement:xmlElement];
        
        NSString * org_idStr = [TBXML textForElement:org_idElement];
        
        TBXMLElement * paysumElement = [TBXML childElementNamed:@"paysum" parentElement:xmlElement];
        
        NSString * paysumStr = [TBXML textForElement:paysumElement];
        
        TBXMLElement * permission_addressElement = [TBXML childElementNamed:@"permission_address" parentElement:xmlElement];
        
        NSString * permission_addressStr = [TBXML textForElement:permission_addressElement];
        
        TBXMLElement * quanzong_noElement = [TBXML childElementNamed:@"quanzong_no" parentElement:xmlElement];
        
        NSString * quanzong_noStr = [TBXML textForElement:quanzong_noElement];
        
        TBXMLElement * reasonElement = [TBXML childElementNamed:@"reason" parentElement:xmlElement];
        
        NSString * reasonStr = [TBXML textForElement:reasonElement];
        
        TBXMLElement * reason_detailElement = [TBXML childElementNamed:@"reason_detail" parentElement:xmlElement];
        
        NSString * reason_detailStr = [TBXML textForElement:reason_detailElement];
        
        TBXMLElement * statusElement = [TBXML childElementNamed:@"status" parentElement:xmlElement];
        
        NSString * statusStr = [TBXML textForElement:statusElement];
        
        TBXMLElement * titleElement = [TBXML childElementNamed:@"title" parentElement:xmlElement];
        
        NSString * titleStr = [TBXML textForElement:titleElement];
        
		
		dispatch_sync(dispatch_get_main_queue(), ^{
			NSManagedObjectContext *context=[MYAPPDELEGATE managedObjectContext];
			NSEntityDescription *entity=[NSEntityDescription entityForName:@"AllPermitModel" inManagedObjectContext:context];
			allPermit =[[AllPermitModel alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
			allPermit.admissible_date=admissible_dateStr;
			allPermit.anjuan_no=anjuan_noStr;
			allPermit.app_date=app_dateStr;
			allPermit.app_name=app_nameStr;
			allPermit.app_no=app_noStr;
			allPermit.app_type=app_typeStr;
			allPermit.applicant_address=applicant_addressStr;
			allPermit.identifier=idStr;
			allPermit.applicant_flag=applicant_flagStr;
			allPermit.applicant_name=applicant_nameStr;
			allPermit.baomi_type=baomi_typeStr;
			allPermit.countychbname1=countychbname1Str;
			allPermit.countychbyijian1=countychbyijian1Str;
	//        if (countychbtime1Str!=nil) {
	//            NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
	//            [dateFormat setDateFormat:@"yyyy-MM-dd"];//设定时间格式,这里可以设置成自己需要的格式
	//            NSDate *date1 =[dateFormat dateFromString:countychbtime1Str];
	//            allPermit.countychbtime1=date1;
	//        }
	//        if (countyjigtime2Str!=nil) {
	//            NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
	//            [dateFormat setDateFormat:@"yyyy-MM-dd"];//设定时间格式,这里可以设置成自己需要的格式
	//            NSDate *date2 =[dateFormat dateFromString:countyjigtime2Str];
	//            allPermit.countyjigtime2=date2;
	//        }
		 
			allPermit.countyjigname2=countyjigname2Str;
			allPermit.countyjigyijian2=countyjigyijian2Str;
			allPermit.countyledname3=countyledname3Str;
			allPermit.countyledyijian3=countyledyijian3Str;
			allPermit.danganshi_no=danganshi_noStr;
			allPermit.date_step=date_stepStr;
			allPermit.importent=importentStr;
			allPermit.legal_spokesman=legal_spokesmanStr;
			allPermit.limit=limitStr;
			allPermit.org_id=org_idStr;
			allPermit.paysum=paysumStr;
			allPermit.permission_address=permission_addressStr;
			allPermit.quanzong_no=quanzong_noStr;
			allPermit.reason=reasonStr;
			allPermit.reason_detail=reason_detailStr;
			allPermit.status=statusStr;
			allPermit.title=titleStr;
			
			NSError *error;
			if(![context save:&error])
			{
				NSLog(@" AllPermitModel  不能保存：%@",[error localizedDescription]);
			}
		});
    }
	dispatch_sync(dispatch_get_main_queue(), ^{
		[MYAPPDELEGATE saveContext];
	});
    return allPermit;
}

@end
