//
//  UserInfoModel.m
//  GDZhiFaJianGuanSystem
//
//  Created by XU SHIWEN on 14-2-8.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import "UserInfoModel.h"
#import "TBXML.h"

@implementation UserInfoModel

@dynamic account;
@dynamic address;
@dynamic birthday;
@dynamic delFlag;
@dynamic dept_id;
@dynamic duty;
@dynamic employee_id;
@dynamic groupID;
@dynamic identifier;
@dynamic isadmin;
@dynamic marriage;
@dynamic memo;
@dynamic orgID;
@dynamic password;
@dynamic sex;
@dynamic telephone;
@dynamic title;
@dynamic username;


+ (instancetype)newModelFromXML:(id)xml
{
    __block UserInfoModel *user=Nil;
    TBXMLElement *xmlElement = NULL;
    [(NSValue *)xml getValue:&xmlElement];
    
    if (xmlElement) {
        // 解析xml
        
        TBXMLElement * accountElement = [TBXML childElementNamed:@"account" parentElement:xmlElement];

        NSString * accountStr = [TBXML textForElement:accountElement];
        
        TBXMLElement * addressElement = [TBXML childElementNamed:@"address" parentElement:xmlElement];
        
        NSString * addressStr = [TBXML textForElement:addressElement];
        
        TBXMLElement * delFlagElement = [TBXML childElementNamed:@"delFlag" parentElement:xmlElement];
        
        NSString * delFlagStr = [TBXML textForElement:delFlagElement];
        
        TBXMLElement * dept_idElement = [TBXML childElementNamed:@"dept_id" parentElement:xmlElement];
        
        NSString * dept_idStr = [TBXML textForElement:dept_idElement];
        
        TBXMLElement * dutyElement = [TBXML childElementNamed:@"duty" parentElement:xmlElement];
        
        NSString * dutyStr = [TBXML textForElement:dutyElement];
        
        TBXMLElement * employee_idElement = [TBXML childElementNamed:@"employee_id" parentElement:xmlElement];
        
        NSString * employee_idStr = [TBXML textForElement:employee_idElement];
        
        TBXMLElement * groupIDElement = [TBXML childElementNamed:@"groupID" parentElement:xmlElement];
        
        NSString * groupIDStr = [TBXML textForElement:groupIDElement];
        
        TBXMLElement * idElement = [TBXML childElementNamed:@"id" parentElement:xmlElement];
        
        NSString * idStr = [TBXML textForElement:idElement];

        TBXMLElement * isadminElement = [TBXML childElementNamed:@"isadmin" parentElement:xmlElement];
        
        NSString * isadminStr = [TBXML textForElement:isadminElement];
        
        TBXMLElement * marriageElement = [TBXML childElementNamed:@"marriage" parentElement:xmlElement];
        
        NSString * marriageStr = [TBXML textForElement:marriageElement];
        
        TBXMLElement * memoElement = [TBXML childElementNamed:@"memo" parentElement:xmlElement];
        
        NSString * memoStr = [TBXML textForElement:memoElement];
        
        TBXMLElement * orgIDElement = [TBXML childElementNamed:@"orgID" parentElement:xmlElement];
        
        NSString * orgIDStr = [TBXML textForElement:orgIDElement];
        
        TBXMLElement * passwordElement = [TBXML childElementNamed:@"password" parentElement:xmlElement];
        
        NSString * passwordStr = [TBXML textForElement:passwordElement];
        
        TBXMLElement * sexElement = [TBXML childElementNamed:@"sex" parentElement:xmlElement];
        
        NSString * sexStr = [TBXML textForElement:sexElement];
        
        TBXMLElement * telephoneElement = [TBXML childElementNamed:@"telephone" parentElement:xmlElement];
        
        NSString * telephoneStr = [TBXML textForElement:telephoneElement];
        
        TBXMLElement * titleElement = [TBXML childElementNamed:@"title" parentElement:xmlElement];
        
        NSString * titleStr = [TBXML textForElement:titleElement];
        
        TBXMLElement * usernameElement = [TBXML childElementNamed:@"username" parentElement:xmlElement];
        
        NSString * usernameStr = [TBXML textForElement:usernameElement];
        dispatch_sync(dispatch_get_main_queue(), ^{
			NSManagedObjectContext *context=[MYAPPDELEGATE managedObjectContext];
			NSEntityDescription *entity=[NSEntityDescription entityForName:@"UserInfoModel" inManagedObjectContext:context];
			user =[[UserInfoModel alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
			user.account=accountStr;
			user.address=addressStr;
			user.delFlag=delFlagStr;
			user.dept_id=dept_idStr;
			user.duty=dutyStr;
			user.employee_id=employee_idStr;
			user.groupID=groupIDStr;
			user.identifier=idStr;
			user.isadmin = @(isadminStr.boolValue);
			user.marriage=marriageStr;
			user.memo=memoStr;
			user.orgID=orgIDStr;
			user.username=usernameStr;
			user.password=passwordStr;
			user.sex=sexStr;
			user.telephone=telephoneStr;
			user.title=titleStr;
			
			NSError *error;
			if(![context save:&error])
			{
				NSLog(@" UserInfoModel  不能保存：%@",[error localizedDescription]);
			}
		});
    }
    [MYAPPDELEGATE saveContext];
    return user;
}

+ (UserInfoModel *)userInfoForUserID:(NSString *)userID {
	__block NSArray *temp = nil;
	dispatch_sync(dispatch_get_main_queue(), ^{
		NSManagedObjectContext *context=[MYAPPDELEGATE managedObjectContext];
		NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
		NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
		[fetchRequest setEntity:entity];
		[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"identifier == %@",userID]];
		temp=[context executeFetchRequest:fetchRequest error:nil];
	});
    if (temp.count>0) {
        return [temp lastObject];
    } else {
        return nil;
    }
}

+ (NSArray *)allUserInfo{
	__block NSArray *temp;
	dispatch_sync(dispatch_get_main_queue(), ^{
		NSManagedObjectContext *context=[MYAPPDELEGATE managedObjectContext];
		NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
		NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
		[fetchRequest setEntity:entity];
		[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"isadmin == NO"]];
		temp = [context executeFetchRequest:fetchRequest error:nil];
	});
	return temp;
}


@end
