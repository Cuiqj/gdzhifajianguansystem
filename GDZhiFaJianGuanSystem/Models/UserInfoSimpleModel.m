//
//  UserInfoSimpleModel.m
//  GDZhiFaJianGuanSystem
//
//  Created by luna on 14-2-14.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import "UserInfoSimpleModel.h"
#import "TBXML.h"


@implementation UserInfoSimpleModel

@dynamic account;
@dynamic delFlag;
@dynamic groupID;
@dynamic identifier;
@dynamic isadmin;
@dynamic orgID;
@dynamic username;

+ (instancetype)newModelFromXML:(id)xml
{
    TBXMLElement *xmlElement = NULL;
    [(NSValue *)xml getValue:&xmlElement];
    __block UserInfoSimpleModel *user=nil;
    if (xmlElement) {
        // 解析xml
        
        TBXMLElement * accountElement = [TBXML childElementNamed:@"account" parentElement:xmlElement];
        
        NSString * accountStr = [TBXML textForElement:accountElement];
        
        TBXMLElement * delFlagElement = [TBXML childElementNamed:@"delFlag" parentElement:xmlElement];
        
        NSString * delFlagStr = [TBXML textForElement:delFlagElement];
        
        TBXMLElement * groupIDElement = [TBXML childElementNamed:@"groupID" parentElement:xmlElement];
        
        NSString * groupIDStr = [TBXML textForElement:groupIDElement];
        
        TBXMLElement * idElement = [TBXML childElementNamed:@"id" parentElement:xmlElement];
        
        NSString * idStr = [TBXML textForElement:idElement];
        
        TBXMLElement * isadminElement = [TBXML childElementNamed:@"isadmin" parentElement:xmlElement];
        
        NSString * isadminStr = [TBXML textForElement:isadminElement];
        
        TBXMLElement * orgIDElement = [TBXML childElementNamed:@"orgID" parentElement:xmlElement];
        
        NSString * orgIDStr = [TBXML textForElement:orgIDElement];
        
        TBXMLElement * usernameElement = [TBXML childElementNamed:@"username" parentElement:xmlElement];
        
        NSString * usernameStr = [TBXML textForElement:usernameElement];
        
		
		dispatch_sync(dispatch_get_main_queue(), ^{
			NSManagedObjectContext *context=[MYAPPDELEGATE managedObjectContext];
			NSEntityDescription *entity=[NSEntityDescription entityForName:@"UserInfoSimpleModel" inManagedObjectContext:context];
			user =[[UserInfoSimpleModel alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
			user.account=accountStr;
			user.delFlag=delFlagStr;
			user.groupID=groupIDStr;
			user.identifier=idStr;
			user.isadmin = isadminStr;
			user.orgID=orgIDStr;
			user.username=usernameStr;

			
			NSError *error;
			if(![context save:&error])
			{
				NSLog(@" UserInfoSimpleModel  不能保存：%@",[error localizedDescription]);
			}
        });
    }
	dispatch_sync(dispatch_get_main_queue(), ^{
		[MYAPPDELEGATE saveContext];
	});
    return user;

}
@end
