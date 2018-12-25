//
//  EmployeeInfoModel.m
//  GDZhiFaJianGuanSystem
//
//  Created by luna on 14-3-5.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import "EmployeeInfoModel.h"


@implementation EmployeeInfoModel

@dynamic academic;
@dynamic address;
@dynamic appearance;
@dynamic birthday;
@dynamic cardID;
@dynamic delFlag;
@dynamic depart_id;
@dynamic duty;
@dynamic email;
@dynamic employee_code;
@dynamic enforce_code;
@dynamic identifier;
@dynamic im_code;
@dynamic marriage;
@dynamic memo;
@dynamic mobile;
@dynamic name;
@dynamic nation;
@dynamic nativePlace;
@dynamic orderdesc;
@dynamic organization_id;
@dynamic photo;
@dynamic quality;
@dynamic resume;
@dynamic rewards_punishments;
@dynamic roadwork_time;
@dynamic sex;
@dynamic speciality;
@dynamic telephone;
@dynamic title;
@dynamic work_start_date;
+ (instancetype)newModelFromXML:(id)xml
{
    // 解析xml
    __block EmployeeInfoModel *employee = nil;
    
    TBXMLElement *xmlElement = NULL;
    [(NSValue *)xml getValue:&xmlElement];
    
    if (xmlElement) {
        // 解析xml
        
        TBXMLElement * academicElement = [TBXML childElementNamed:@"academic" parentElement:xmlElement];
        
        NSString * academicStr = [TBXML textForElement:academicElement];
        
        TBXMLElement * addressElement = [TBXML childElementNamed:@"address" parentElement:xmlElement];
        
        NSString * addressStr = [TBXML textForElement:addressElement];
        
        TBXMLElement * appearanceElement = [TBXML childElementNamed:@"appearance" parentElement:xmlElement];
        
        NSString * appearanceStr = [TBXML textForElement:appearanceElement];
        
        TBXMLElement * cardIDElement = [TBXML childElementNamed:@"cardID" parentElement:xmlElement];
        
        NSString * cardIDStr = [TBXML textForElement:cardIDElement];
        
        TBXMLElement * delFlagElement = [TBXML childElementNamed:@"delFlag" parentElement:xmlElement];
        
        NSString * delFlagStr = [TBXML textForElement:delFlagElement];
        
        TBXMLElement * depart_idElement = [TBXML childElementNamed:@"depart_id" parentElement:xmlElement];
        
        NSString * depart_idStr = [TBXML textForElement:depart_idElement];
        
        TBXMLElement * dutyElement = [TBXML childElementNamed:@"duty" parentElement:xmlElement];
        
        NSString * dutyStr = [TBXML textForElement:dutyElement];
        
        TBXMLElement * idElement = [TBXML childElementNamed:@"id" parentElement:xmlElement];
        
        NSString * idStr = [TBXML textForElement:idElement];
        
        TBXMLElement * emailElement = [TBXML childElementNamed:@"email" parentElement:xmlElement];
        
        NSString * emailStr = [TBXML textForElement:emailElement];
        
        TBXMLElement * employee_codeElement = [TBXML childElementNamed:@"employee_code" parentElement:xmlElement];
        
        NSString * employee_codeStr = [TBXML textForElement:employee_codeElement];
        
        TBXMLElement * enforce_codeElement = [TBXML childElementNamed:@"enforce_code" parentElement:xmlElement];
        
        NSString * enforce_codeStr = [TBXML textForElement:enforce_codeElement];
        
        TBXMLElement * im_codeElement = [TBXML childElementNamed:@"im_code" parentElement:xmlElement];
        
        NSString * im_codeStr = [TBXML textForElement:im_codeElement];
        
        TBXMLElement * marriageElement = [TBXML childElementNamed:@"marriage" parentElement:xmlElement];
        
        NSString * marriageStr = [TBXML textForElement:marriageElement];
        
        TBXMLElement * memoElement = [TBXML childElementNamed:@"memo" parentElement:xmlElement];
        
        NSString * memoStr = [TBXML textForElement:memoElement];
        
        TBXMLElement * mobileElement = [TBXML childElementNamed:@"mobile" parentElement:xmlElement];
        
        NSString * mobileStr = [TBXML textForElement:mobileElement];
        
        TBXMLElement * nameElement = [TBXML childElementNamed:@"name" parentElement:xmlElement];
        
        NSString * nameStr = [TBXML textForElement:nameElement];
        
        TBXMLElement * nationElement = [TBXML childElementNamed:@"nation" parentElement:xmlElement];
        
        NSString * nationStr = [TBXML textForElement:nationElement];
        
        TBXMLElement * nativePlaceElement = [TBXML childElementNamed:@"nativePlace" parentElement:xmlElement];
        
        NSString * nativePlaceStr = [TBXML textForElement:nativePlaceElement];
        
        TBXMLElement * orderdescElement = [TBXML childElementNamed:@"orderdesc" parentElement:xmlElement];
        
        NSString * orderdescStr = [TBXML textForElement:orderdescElement];
        
        TBXMLElement * organization_idElement = [TBXML childElementNamed:@"organization_id" parentElement:xmlElement];
        
        NSString * organization_idStr = [TBXML textForElement:organization_idElement];
        
        TBXMLElement * photoElement = [TBXML childElementNamed:@"photo" parentElement:xmlElement];
        
        NSString * photoStr = [TBXML textForElement:photoElement];
        
        TBXMLElement * qualityElement = [TBXML childElementNamed:@"quality" parentElement:xmlElement];
        
        NSString * qualityStr = [TBXML textForElement:qualityElement];
        
        TBXMLElement * resumeElement = [TBXML childElementNamed:@"resume" parentElement:xmlElement];
        
        NSString * resumeStr = [TBXML textForElement:resumeElement];
        
        TBXMLElement * rewards_punishmentsElement = [TBXML childElementNamed:@"rewards_punishments" parentElement:xmlElement];
        
        NSString * rewards_punishmentsStr = [TBXML textForElement:rewards_punishmentsElement];
        
        TBXMLElement * roadwork_timeElement = [TBXML childElementNamed:@"roadwork_time" parentElement:xmlElement];
        
        NSString * roadwork_timeStr = [TBXML textForElement:roadwork_timeElement];
        
        TBXMLElement * sexElement = [TBXML childElementNamed:@"sex" parentElement:xmlElement];
        
        NSString * sexStr = [TBXML textForElement:sexElement];
        
        TBXMLElement * specialityElement = [TBXML childElementNamed:@"speciality" parentElement:xmlElement];
        
        NSString * specialityStr = [TBXML textForElement:specialityElement];
        
        TBXMLElement * telephoneElement = [TBXML childElementNamed:@"telephone" parentElement:xmlElement];
        
        NSString * telephoneStr = [TBXML textForElement:telephoneElement];
        
        TBXMLElement * titleElement = [TBXML childElementNamed:@"title" parentElement:xmlElement];
        
        NSString * titleStr = [TBXML textForElement:titleElement];
        
        TBXMLElement * birthdayElement = [TBXML childElementNamed:@"birthday" parentElement:xmlElement];
        
        NSString * birthdayStr = [TBXML textForElement:birthdayElement];
        
		dispatch_sync(dispatch_get_main_queue(), ^{
			NSManagedObjectContext *context=[MYAPPDELEGATE managedObjectContext];
			NSEntityDescription *entity=[NSEntityDescription entityForName:@"EmployeeInfoModel" inManagedObjectContext:context];
			employee =[[EmployeeInfoModel alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
			employee.academic=academicStr;
			employee.address=addressStr;
			employee.appearance=appearanceStr;
			employee.cardID=cardIDStr;
			employee.delFlag=delFlagStr;
			employee.depart_id=depart_idStr;
			employee.duty=dutyStr;
			employee.identifier=idStr;
			employee.email=emailStr;
			employee.employee_code=employee_codeStr;
			employee.enforce_code=enforce_codeStr;
			employee.im_code=im_codeStr;
			employee.marriage=marriageStr;
			employee.memo=memoStr;
			employee.mobile=mobileStr;
			employee.name=nameStr;
			employee.nation=nationStr;
			employee.nativePlace=nativePlaceStr;
			employee.orderdesc=orderdescStr;
			employee.organization_id=organization_idStr;
			employee.photo=photoStr;
			employee.quality=qualityStr;
			employee.resume=resumeStr;
			employee.rewards_punishments=rewards_punishmentsStr;
			employee.roadwork_time=roadwork_timeStr;
			employee.sex=sexStr;
			employee.speciality=specialityStr;
			employee.telephone=telephoneStr;
			employee.title=titleStr;
			
			if (birthdayStr!=nil) {
				employee.birthday=[[birthdayStr componentsSeparatedByString:@"T"]objectAtIndex:0];
			}
			
			NSError *error;
			if(![context save:&error])
			{
				NSLog(@" EmployeeInfoModel  不能保存：%@",[error localizedDescription]);
			}
		});
    }
	dispatch_sync(dispatch_get_main_queue(), ^{
		[MYAPPDELEGATE saveContext];
    });
    return employee;
}

@end
