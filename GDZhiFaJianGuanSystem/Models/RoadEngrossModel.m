//
//  RoadEngrossModel.m
//  GDZhiFaJianGuanSystem
//
//  Created by luna on 14-2-17.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import "RoadEngrossModel.h"
#import "TBXML.h"


@implementation RoadEngrossModel

@dynamic accessory_no;
@dynamic approve_code;
@dynamic build_structure;
@dynamic built_area;
@dynamic built_count;
@dynamic built_distance;
@dynamic built_length;
@dynamic case_no;
@dynamic code;
@dynamic date_end;
@dynamic date_start;
@dynamic deal_with;
@dynamic engross_built_info;
@dynamic engross_info;
@dynamic engross_space;
@dynamic engross_style;
@dynamic fix;
@dynamic grading;
@dynamic gutter_distance;
@dynamic height;
@dynamic identifier;
@dynamic inroad_info;
@dynamic item_type;
@dynamic linkman_name;
@dynamic linkman_phone;
@dynamic org_id;
@dynamic owner_name;
@dynamic remark;
@dynamic removeDate;
@dynamic roadSegment_id;
@dynamic serialno;
@dynamic station_end;
@dynamic station_start;
@dynamic support_type;
@dynamic tag_content;
@dynamic yearno;

+ (instancetype)newModelFromXML:(id)xml
{
    // 解析xml
    __block RoadEngrossModel *roadEngross = nil;
    TBXMLElement *xmlElement = NULL;
    [(NSValue *)xml getValue:&xmlElement];
    
    if (xmlElement) {
        // 解析xml
        
        TBXMLElement * accessory_noElement = [TBXML childElementNamed:@"accessory_no" parentElement:xmlElement];
        
        NSString * accessory_noStr = [TBXML textForElement:accessory_noElement];
        
        TBXMLElement * approve_codeElement = [TBXML childElementNamed:@"approve_code" parentElement:xmlElement];
        
        NSString * approve_codeStr = [TBXML textForElement:approve_codeElement];
        
        TBXMLElement * build_structureElement = [TBXML childElementNamed:@"build_structure" parentElement:xmlElement];
        
        NSString * build_structureStr = [TBXML textForElement:build_structureElement];
        
        TBXMLElement * built_areaElement = [TBXML childElementNamed:@"built_area" parentElement:xmlElement];
        
        NSString * built_areaStr = [TBXML textForElement:built_areaElement];
        
        TBXMLElement * built_countElement = [TBXML childElementNamed:@"built_count" parentElement:xmlElement];
        
        NSString * built_countStr = [TBXML textForElement:built_countElement];
        
        TBXMLElement * built_distanceElement = [TBXML childElementNamed:@"built_distance" parentElement:xmlElement];
        
        NSString * built_distanceStr = [TBXML textForElement:built_distanceElement];
        
        TBXMLElement * built_lengthElement = [TBXML childElementNamed:@"built_length" parentElement:xmlElement];
        
        NSString * built_lengthStr = [TBXML textForElement:built_lengthElement];
        
        TBXMLElement * idElement = [TBXML childElementNamed:@"id" parentElement:xmlElement];
        
        NSString * idStr = [TBXML textForElement:idElement];
        
        TBXMLElement * case_noElement = [TBXML childElementNamed:@"case_no" parentElement:xmlElement];
        
        NSString * case_noStr = [TBXML textForElement:case_noElement];
        
        TBXMLElement * codeElement = [TBXML childElementNamed:@"code" parentElement:xmlElement];
        
        NSString * codeStr = [TBXML textForElement:codeElement];
        
        TBXMLElement * date_endElement = [TBXML childElementNamed:@"date_end" parentElement:xmlElement];
        
        NSString * date_endStr = [TBXML textForElement:date_endElement];
        
        TBXMLElement * date_startElement = [TBXML childElementNamed:@"date_start" parentElement:xmlElement];
        
        NSString * date_startStr = [TBXML textForElement:date_startElement];
        
        TBXMLElement * deal_withElement = [TBXML childElementNamed:@"deal_with" parentElement:xmlElement];
        
        NSString * deal_withStr = [TBXML textForElement:deal_withElement];
        
        TBXMLElement * engross_built_infoElement = [TBXML childElementNamed:@"engross_built_info" parentElement:xmlElement];
        
        NSString * engross_built_infoStr = [TBXML textForElement:engross_built_infoElement];
        
        TBXMLElement * engross_infoElement = [TBXML childElementNamed:@"engross_info" parentElement:xmlElement];
        
        NSString * engross_infoStr = [TBXML textForElement:engross_infoElement];
        
        TBXMLElement * engross_spaceElement = [TBXML childElementNamed:@"engross_space" parentElement:xmlElement];
        
        NSString * engross_spaceStr = [TBXML textForElement:engross_spaceElement];
        
        TBXMLElement * engross_styleElement = [TBXML childElementNamed:@"engross_style" parentElement:xmlElement];
        
        NSString * engross_styleStr = [TBXML textForElement:engross_styleElement];
        
        TBXMLElement * fixElement = [TBXML childElementNamed:@"fix" parentElement:xmlElement];
        
        NSString * fixStr = [TBXML textForElement:fixElement];
        
        TBXMLElement * gradingElement = [TBXML childElementNamed:@"grading" parentElement:xmlElement];
        
        NSString * gradingStr = [TBXML textForElement:gradingElement];
        
        TBXMLElement * gutter_distanceElement = [TBXML childElementNamed:@"gutter_distance" parentElement:xmlElement];
        
        NSString * gutter_distanceStr = [TBXML textForElement:gutter_distanceElement];
        
        TBXMLElement * heightElement = [TBXML childElementNamed:@"height" parentElement:xmlElement];
        
        NSString * heightStr = [TBXML textForElement:heightElement];
        
        TBXMLElement * inroad_infoElement = [TBXML childElementNamed:@"inroad_info" parentElement:xmlElement];
        
        NSString * inroad_infoStr = [TBXML textForElement:inroad_infoElement];
        
        TBXMLElement * item_typeElement = [TBXML childElementNamed:@"item_type" parentElement:xmlElement];
        
        NSString * item_typeStr = [TBXML textForElement:item_typeElement];
        
        TBXMLElement * linkman_nameElement = [TBXML childElementNamed:@"linkman_name" parentElement:xmlElement];
        
        NSString * linkman_nameStr = [TBXML textForElement:linkman_nameElement];
        
        TBXMLElement * linkman_phoneElement = [TBXML childElementNamed:@"linkman_phone" parentElement:xmlElement];
        
        NSString * linkman_phoneStr = [TBXML textForElement:linkman_phoneElement];
        
        TBXMLElement * org_idElement = [TBXML childElementNamed:@"org_id" parentElement:xmlElement];
        
        NSString * org_idStr = [TBXML textForElement:org_idElement];
        
        TBXMLElement * owner_nameElement = [TBXML childElementNamed:@"owner_name" parentElement:xmlElement];
        
        NSString * owner_nameStr = [TBXML textForElement:owner_nameElement];
        
        TBXMLElement * remarkElement = [TBXML childElementNamed:@"remark" parentElement:xmlElement];
        
        NSString * remarkStr = [TBXML textForElement:remarkElement];
        
        TBXMLElement * roadSegment_idElement = [TBXML childElementNamed:@"roadSegment_id" parentElement:xmlElement];
        
        NSString * roadSegment_idStr = [TBXML textForElement:roadSegment_idElement];
        
        TBXMLElement * serialnoElement = [TBXML childElementNamed:@"serialno" parentElement:xmlElement];
        
        NSString * serialnoStr = [TBXML textForElement:serialnoElement];
        
        TBXMLElement * station_endElement = [TBXML childElementNamed:@"station_end" parentElement:xmlElement];
        
        NSString * station_endStr = [TBXML textForElement:station_endElement];
        
        TBXMLElement * station_startElement = [TBXML childElementNamed:@"station_start" parentElement:xmlElement];
        
        NSString * station_startStr = [TBXML textForElement:station_startElement];
        
        TBXMLElement * support_typeElement = [TBXML childElementNamed:@"support_type" parentElement:xmlElement];
        
        NSString * support_typeStr = [TBXML textForElement:support_typeElement];
        
        TBXMLElement * tag_contentElement = [TBXML childElementNamed:@"tag_content" parentElement:xmlElement];
        
        NSString * tag_contentStr = [TBXML textForElement:tag_contentElement];
        
        TBXMLElement * yearnoElement = [TBXML childElementNamed:@"yearno" parentElement:xmlElement];
        
        NSString * yearnoStr = [TBXML textForElement:yearnoElement];
        
		
		dispatch_sync(dispatch_get_main_queue(), ^{
			NSManagedObjectContext *context=[MYAPPDELEGATE managedObjectContext];
			NSEntityDescription *entity=[NSEntityDescription entityForName:@"RoadEngrossModel" inManagedObjectContext:context];
			roadEngross =[[RoadEngrossModel alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
			roadEngross.accessory_no=accessory_noStr;
			roadEngross.approve_code=approve_codeStr;
			roadEngross.build_structure=build_structureStr;
			roadEngross.built_area=built_areaStr;
			roadEngross.built_count=built_countStr;
			roadEngross.built_distance=built_distanceStr;
			roadEngross.built_length=built_lengthStr;
			roadEngross.identifier=idStr;
			roadEngross.case_no=case_noStr;
			roadEngross.code=codeStr;
			roadEngross.deal_with=deal_withStr;
			roadEngross.engross_built_info=engross_built_infoStr;
			roadEngross.engross_info=engross_infoStr;
			roadEngross.engross_space=engross_spaceStr;
			roadEngross.engross_style=engross_styleStr;
			roadEngross.fix=fixStr;
			roadEngross.grading=gradingStr;
			roadEngross.gutter_distance=gutter_distanceStr;
			roadEngross.height=heightStr;
			roadEngross.remark=remarkStr;
			roadEngross.inroad_info=inroad_infoStr;
			roadEngross.item_type=item_typeStr;
			roadEngross.linkman_name=linkman_nameStr;
			roadEngross.linkman_phone=linkman_phoneStr;
			roadEngross.org_id=org_idStr;
			roadEngross.owner_name=owner_nameStr;
			roadEngross.roadSegment_id=roadSegment_idStr;
			roadEngross.serialno=serialnoStr;
			roadEngross.station_end=station_endStr;
			roadEngross.station_start=station_startStr;
			roadEngross.support_type=support_typeStr;
			roadEngross.tag_content=tag_contentStr;
			roadEngross.yearno=yearnoStr;
			
			if (date_endStr!=nil) {
				NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
				[dateFormat setDateFormat:@"yyyy-MM-dd"];//设定时间格式,这里可以设置成自己需要的格式
				NSDate *date =[dateFormat dateFromString:date_endStr];
				roadEngross.date_end=date;
				
			}
			if (date_startStr!=nil) {
				NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
				[dateFormat setDateFormat:@"yyyy-MM-dd"];//设定时间格式,这里可以设置成自己需要的格式
				NSDate *date2 =[dateFormat dateFromString:date_startStr];
				roadEngross.date_start=date2;
			}
			
			NSError *error;
			if(![context save:&error])
			{
				NSLog(@" RoadEngrossModel  不能保存：%@",[error localizedDescription]);
			}
		});
    }
    dispatch_sync(dispatch_get_main_queue(), ^{
		[MYAPPDELEGATE saveContext];
	});
    return roadEngross;
}

@end
