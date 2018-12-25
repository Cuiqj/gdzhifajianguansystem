//
//  InspectionModel.m
//  GDZhiFaJianGuanSystem
//
//  Created by luna on 14-2-22.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import "InspectionModel.h"
#import "TBXML.h"

@implementation InspectionModel

@dynamic carcode;
@dynamic classe;
@dynamic date_inspection;
@dynamic delivertext;
@dynamic description_inspection;
@dynamic duty_leader;
@dynamic identifier;
@dynamic inspection_area;
@dynamic inspection_desc;
@dynamic inspection_line;
@dynamic inspection_milimetres;
@dynamic inspection_place;
@dynamic inspectionor_name;
@dynamic isdeliver;
@dynamic isnew;
@dynamic lu_opinion;
@dynamic lu_opinion_date;
@dynamic luzhen_principal;
@dynamic organization_id;
@dynamic p_opinion;
@dynamic p_opinion_date;
@dynamic principal;
@dynamic recorder_name;
@dynamic remark;
@dynamic roadsegment_id;
@dynamic station_end;
@dynamic station_start;
@dynamic take_measure;
@dynamic time_end;
@dynamic time_start;
@dynamic weather;

+ (instancetype)newModelFromXML:(id)xml
{
    // 解析xml
    __block InspectionModel *inspection = nil;
    
    TBXMLElement *xmlElement = NULL;
    [(NSValue *)xml getValue:&xmlElement];
    
    if (xmlElement) {
        // 解析xml
        
        TBXMLElement * carcodeElement = [TBXML childElementNamed:@"carcode" parentElement:xmlElement];
        
        NSString * carcodeStr = [TBXML textForElement:carcodeElement];
        
        TBXMLElement * classeElement = [TBXML childElementNamed:@"classe" parentElement:xmlElement];
        
        NSString * classeStr = [TBXML textForElement:classeElement];
        
        TBXMLElement * date_inspectionElement = [TBXML childElementNamed:@"date_inspection" parentElement:xmlElement];
        
        NSString * date_inspectionStr = [TBXML textForElement:date_inspectionElement];
        
        TBXMLElement * delivertextElement = [TBXML childElementNamed:@"delivertext" parentElement:xmlElement];
        
        NSString * delivertextStr = [TBXML textForElement:delivertextElement];
        
        TBXMLElement * descriptionElement = [TBXML childElementNamed:@"description" parentElement:xmlElement];
        
        NSString * descriptionStr = [TBXML textForElement:descriptionElement];
        
        TBXMLElement * duty_leaderElement = [TBXML childElementNamed:@"duty_leader" parentElement:xmlElement];
        
        NSString * duty_leaderStr = [TBXML textForElement:duty_leaderElement];
        
        TBXMLElement * inspection_areaElement = [TBXML childElementNamed:@"inspection_area" parentElement:xmlElement];
        
        NSString * inspection_areaStr = [TBXML textForElement:inspection_areaElement];
        
        TBXMLElement * idElement = [TBXML childElementNamed:@"id" parentElement:xmlElement];
        
        NSString * idStr = [TBXML textForElement:idElement];
        
        TBXMLElement * inspection_lineElement = [TBXML childElementNamed:@"inspection_line" parentElement:xmlElement];
        
        NSString * inspection_lineStr = [TBXML textForElement:inspection_lineElement];
        
        TBXMLElement * inspection_milimetresElement = [TBXML childElementNamed:@"inspection_milimetres" parentElement:xmlElement];
        
        NSString * inspection_milimetresStr = [TBXML textForElement:inspection_milimetresElement];
        
        TBXMLElement * inspection_placeElement = [TBXML childElementNamed:@"inspection_place" parentElement:xmlElement];
        
        NSString * inspection_placeStr = [TBXML textForElement:inspection_placeElement];
        
        TBXMLElement * inspectionor_nameElement = [TBXML childElementNamed:@"inspectionor_name" parentElement:xmlElement];
        
        NSString * inspectionor_nameStr = [TBXML textForElement:inspectionor_nameElement];
        
        TBXMLElement * isdeliverElement = [TBXML childElementNamed:@"isdeliver" parentElement:xmlElement];
        
        NSString * isdeliverStr = [TBXML textForElement:isdeliverElement];
        
        TBXMLElement * isnewElement = [TBXML childElementNamed:@"isnew" parentElement:xmlElement];
        
        NSString * isnewStr = [TBXML textForElement:isnewElement];
        
        TBXMLElement * lu_opinionElement = [TBXML childElementNamed:@"lu_opinion" parentElement:xmlElement];
        
        NSString * lu_opinionStr = [TBXML textForElement:lu_opinionElement];
        
        TBXMLElement * luzhen_principalElement = [TBXML childElementNamed:@"luzhen_principal" parentElement:xmlElement];
        
        NSString * luzhen_principalStr = [TBXML textForElement:luzhen_principalElement];
        
        TBXMLElement * organization_idElement = [TBXML childElementNamed:@"organization_id" parentElement:xmlElement];
        
        NSString * organization_idStr = [TBXML textForElement:organization_idElement];
        
        TBXMLElement * p_opinionElement = [TBXML childElementNamed:@"p_opinion" parentElement:xmlElement];
        
        NSString * p_opinionStr = [TBXML textForElement:p_opinionElement];
        
        TBXMLElement * principalElement = [TBXML childElementNamed:@"principal" parentElement:xmlElement];
        
        NSString * principalStr = [TBXML textForElement:principalElement];
        
        TBXMLElement * recorder_nameElement = [TBXML childElementNamed:@"recorder_name" parentElement:xmlElement];
        
        NSString * recorder_nameStr = [TBXML textForElement:recorder_nameElement];
        
        TBXMLElement * roadsegment_idElement = [TBXML childElementNamed:@"roadsegment_id" parentElement:xmlElement];
        
        NSString * roadsegment_idStr = [TBXML textForElement:roadsegment_idElement];
        
        TBXMLElement * remarkElement = [TBXML childElementNamed:@"remark" parentElement:xmlElement];
        
        NSString * remarkStr = [TBXML textForElement:remarkElement];
        
        TBXMLElement * station_endElement = [TBXML childElementNamed:@"station_end" parentElement:xmlElement];
        
        NSString * station_endStr = [TBXML textForElement:station_endElement];
        
        TBXMLElement * station_startElement = [TBXML childElementNamed:@"station_start" parentElement:xmlElement];
        
        NSString * station_startStr = [TBXML textForElement:station_startElement];
        
        TBXMLElement * take_measureElement = [TBXML childElementNamed:@"take_measure" parentElement:xmlElement];
        
        NSString * take_measureStr = [TBXML textForElement:take_measureElement];
        
        TBXMLElement * weatherElement = [TBXML childElementNamed:@"weather" parentElement:xmlElement];
        
        NSString * weatherStr = [TBXML textForElement:weatherElement];
        
		dispatch_sync(dispatch_get_main_queue(), ^{
			NSManagedObjectContext *context=[MYAPPDELEGATE managedObjectContext];
			NSEntityDescription *entity=[NSEntityDescription entityForName:@"InspectionModel" inManagedObjectContext:context];
			inspection =[[InspectionModel alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
			inspection.carcode=carcodeStr;
			inspection.classe=classeStr;
			inspection.delivertext=delivertextStr;
			inspection.description_inspection=descriptionStr;
			inspection.duty_leader=duty_leaderStr;
			inspection.inspection_area=inspection_areaStr;
			inspection.identifier=idStr;
			inspection.inspection_line=inspection_lineStr;
			inspection.inspection_milimetres=inspection_milimetresStr;
			inspection.inspection_place=inspection_placeStr;
			inspection.inspectionor_name=inspectionor_nameStr;
			inspection.isdeliver=isdeliverStr;
			inspection.isnew=isnewStr;
			inspection.lu_opinion=lu_opinionStr;
			inspection.luzhen_principal=luzhen_principalStr;
			inspection.organization_id=organization_idStr;
			inspection.p_opinion=p_opinionStr;
			inspection.principal=principalStr;
			inspection.recorder_name=recorder_nameStr;
			inspection.roadsegment_id=roadsegment_idStr;
			inspection.remark=remarkStr;
			inspection.station_end=station_endStr;
			inspection.station_start=station_startStr;
			inspection.take_measure=take_measureStr;
			inspection.weather=weatherStr;
			
			if (date_inspectionStr!=nil) {
				inspection.date_inspection=[[date_inspectionStr componentsSeparatedByString:@"T"]objectAtIndex:0];
			}
			
			NSError *error;
			if(![context save:&error])
			{
				NSLog(@" InspectionModel  不能保存：%@",[error localizedDescription]);
			}
		});
    }
    dispatch_sync(dispatch_get_main_queue(), ^{
		[MYAPPDELEGATE saveContext];
	});
    return inspection;
}

@end
