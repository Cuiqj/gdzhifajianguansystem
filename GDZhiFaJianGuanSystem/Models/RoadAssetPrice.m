//
//  RoadAssetPrice.m
//  GDZhiFaJianGuanSystem
//
//  Created by luna on 14-3-3.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import "RoadAssetPrice.h"


@implementation RoadAssetPrice

@dynamic big_type;
@dynamic damage_type;
@dynamic depart_num;
@dynamic name;
@dynamic price;
@dynamic remark;
@dynamic roadasset_id;
@dynamic spec;
@dynamic standard;
@dynamic type;
@dynamic unit_name;

+ (instancetype)newModelFromXML:(id)xml
{
    // 解析xml
    RoadAssetPrice *roadModel = nil;
    
    TBXMLElement *xmlElement = NULL;
    [(NSValue *)xml getValue:&xmlElement];
    
    if (xmlElement) {
        // 解析xml
        
        TBXMLElement * anjuan_noElement = [TBXML childElementNamed:@"anjuan_no" parentElement:xmlElement];
        
        NSString * anjuan_noStr = [TBXML textForElement:anjuan_noElement];
        
        TBXMLElement * automobile_numberElement = [TBXML childElementNamed:@"automobile_number" parentElement:xmlElement];
        
        NSString * automobile_numberStr = [TBXML textForElement:automobile_numberElement];
        
        TBXMLElement * baomi_typeElement = [TBXML childElementNamed:@"baomi_type" parentElement:xmlElement];
        
        NSString * baomi_typeStr = [TBXML textForElement:baomi_typeElement];
        
        TBXMLElement * case_codeElement = [TBXML childElementNamed:@"case_code" parentElement:xmlElement];
        
        NSString * case_codeStr = [TBXML textForElement:case_codeElement];
        
        TBXMLElement * caseqingkuangElement = [TBXML childElementNamed:@"caseqingkuang" parentElement:xmlElement];
        
        NSString * caseqingkuangStr = [TBXML textForElement:caseqingkuangElement];
        
        TBXMLElement * casereasonAutoElement = [TBXML childElementNamed:@"casereasonAuto" parentElement:xmlElement];
        
        NSString * casereasonAutoStr = [TBXML textForElement:casereasonAutoElement];
        
        TBXMLElement * citizen_addressElement = [TBXML childElementNamed:@"citizen_address" parentElement:xmlElement];
        
        NSString * citizen_addressStr = [TBXML textForElement:citizen_addressElement];
        
        TBXMLElement * idElement = [TBXML childElementNamed:@"id" parentElement:xmlElement];
        
        NSString * idStr = [TBXML textForElement:idElement];
        
        TBXMLElement * citizen_nameElement = [TBXML childElementNamed:@"citizen_name" parentElement:xmlElement];
        
        NSString * citizen_nameStr = [TBXML textForElement:citizen_nameElement];
        
        TBXMLElement * citizen_telElement = [TBXML childElementNamed:@"citizen_tel" parentElement:xmlElement];
        
        NSString * citizen_telStr = [TBXML textForElement:citizen_telElement];
        
        TBXMLElement * danganshi_noElement = [TBXML childElementNamed:@"danganshi_no" parentElement:xmlElement];
        
        NSString * danganshi_noStr = [TBXML textForElement:danganshi_noElement];
        
        TBXMLElement * execute_circsElement = [TBXML childElementNamed:@"execute_circs" parentElement:xmlElement];
        
        NSString * execute_circsStr = [TBXML textForElement:execute_circsElement];
        
        TBXMLElement * fact_pay_sumElement = [TBXML childElementNamed:@"fact_pay_sum" parentElement:xmlElement];
        
        NSString * fact_pay_sumStr = [TBXML textForElement:fact_pay_sumElement];
        
        TBXMLElement * happen_dateElement = [TBXML childElementNamed:@"happen_date" parentElement:xmlElement];
        
        NSString * happen_dateStr = [TBXML textForElement:happen_dateElement];
        
        TBXMLElement * limitElement = [TBXML childElementNamed:@"limit" parentElement:xmlElement];
        
        NSString * limitStr = [TBXML textForElement:limitElement];
        
        TBXMLElement * org_idElement = [TBXML childElementNamed:@"org_id" parentElement:xmlElement];
        
        NSString * org_idStr = [TBXML textForElement:org_idElement];
        
        TBXMLElement * pay_sumElement = [TBXML childElementNamed:@"pay_sum" parentElement:xmlElement];
        
        NSString * pay_sumStr = [TBXML textForElement:pay_sumElement];
        
        TBXMLElement * process_idElement = [TBXML childElementNamed:@"process_id" parentElement:xmlElement];
        
        NSString * process_idStr = [TBXML textForElement:process_idElement];
        
        TBXMLElement * process_nameElement = [TBXML childElementNamed:@"process_name" parentElement:xmlElement];
        
        NSString * process_nameStr = [TBXML textForElement:process_nameElement];
        
        TBXMLElement * punish_sumElement = [TBXML childElementNamed:@"punish_sum" parentElement:xmlElement];
        
        NSString * punish_sumStr = [TBXML textForElement:punish_sumElement];
        
        TBXMLElement * quanzong_noElement = [TBXML childElementNamed:@"quanzong_no" parentElement:xmlElement];
        
        NSString * quanzong_noStr = [TBXML textForElement:quanzong_noElement];
        
        TBXMLElement * road_nameElement = [TBXML childElementNamed:@"road_name" parentElement:xmlElement];
        
        NSString * road_nameStr = [TBXML textForElement:road_nameElement];
        
        TBXMLElement * station_endElement = [TBXML childElementNamed:@"station_end" parentElement:xmlElement];
        
        NSString * station_endStr = [TBXML textForElement:station_endElement];
        
        TBXMLElement * station_end_displayElement = [TBXML childElementNamed:@"station_end_display" parentElement:xmlElement];
        
        NSString * station_end_displayStr = [TBXML textForElement:station_end_displayElement];
        
        TBXMLElement * station_startElement = [TBXML childElementNamed:@"station_start" parentElement:xmlElement];
        
        NSString * station_startStr = [TBXML textForElement:station_startElement];
        
        TBXMLElement * station_start_displayElement = [TBXML childElementNamed:@"station_start_display" parentElement:xmlElement];
        
        NSString * station_start_displayStr = [TBXML textForElement:station_start_displayElement];
        
        TBXMLElement * statusElement = [TBXML childElementNamed:@"status" parentElement:xmlElement];
        
        NSString * statusStr = [TBXML textForElement:statusElement];
        
        NSManagedObjectContext *context=[MYAPPDELEGATE managedObjectContext];
        NSEntityDescription *entity=[NSEntityDescription entityForName:@"RoadAssetPrice" inManagedObjectContext:context];
        roadModel =[[RoadAssetPrice alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
//        caseModel.anjuan_no=anjuan_noStr;
//        caseModel.automobile_number=automobile_numberStr;
//        caseModel.baomi_type=baomi_typeStr;
//        caseModel.case_code=case_codeStr;
//        caseModel.caseqingkuang=caseqingkuangStr;
//        caseModel.casereasonAuto=casereasonAutoStr;
//        caseModel.citizen_address=citizen_addressStr;
//        caseModel.identifier=idStr;
//        caseModel.citizen_name=citizen_nameStr;
//        caseModel.citizen_tel=citizen_telStr;
//        caseModel.danganshi_no=danganshi_noStr;
//        caseModel.execute_circs=execute_circsStr;
//        caseModel.fact_pay_sum=fact_pay_sumStr;
//        caseModel.limit=limitStr;
//        caseModel.org_id=org_idStr;
//        caseModel.pay_sum=pay_sumStr;
//        caseModel.process_id=process_idStr;
//        caseModel.process_name=process_nameStr;
//        caseModel.punish_sum=punish_sumStr;
//        caseModel.quanzong_no=quanzong_noStr;
//        caseModel.road_name=road_nameStr;
//        caseModel.station_end=station_endStr;
//        caseModel.station_end_display=station_end_displayStr;
//        caseModel.station_start=station_startStr;
//        caseModel.station_start_display=station_start_displayStr;
//        caseModel.status=statusStr;
//        
//        if (happen_dateStr!=nil) {
//            caseModel.happen_date=[[happen_dateStr componentsSeparatedByString:@"T"]objectAtIndex:0];
//        }
        NSError *error;
        if(![context save:&error])
        {
            NSLog(@" RoadAssetPrice  不能保存：%@",[error localizedDescription]);
        }
    }
    [MYAPPDELEGATE saveContext];
    
    return roadModel;
}

//+ (NSArray *)allDistinctPropertiesNamed:(NSString *)propertyName {
//    NSManagedObjectContext *context=[MYAPPDELEGATE managedObjectContext];
//    
//    NSEntityDescription *entity=[NSEntityDescription entityForName:@"RoadAssetPrice" inManagedObjectContext:context];
//    NSFetchRequest *fecthRequest=[[NSFetchRequest alloc] init];
//    [fecthRequest setEntity:entity];
//    [fecthRequest setResultType:NSDictionaryResultType];
//    [fecthRequest setReturnsDistinctResults:YES];
//    [fecthRequest setPropertiesToFetch:@[propertyName]];
//    
//    NSError *err=nil;
//    NSArray *fetchResult = [context executeFetchRequest:fecthRequest error:&err];
//    if (err == nil) {
//        NSMutableArray *allDistinctProperties = [[NSMutableArray alloc] init];
//        for (NSInteger i = 0; i < fetchResult.count; i++) {
//            id propertyValue = fetchResult[i][propertyName];
//            if ([propertyValue respondsToSelector:@selector(isEmpty)] &&
//                ![propertyValue isEmpty]) {
//                [allDistinctProperties addObject:propertyValue];
//            }
//        }
//        return [allDistinctProperties copy];
//    } else {
//        return nil;
//    }
//}
//
//+ (NSArray *)roadAssetPricesForStandard:(NSString *)standardName {
//    NSManagedObjectContext *context=[MYAPPDELEGATE managedObjectContext];
//    
//    NSEntityDescription *entity=[NSEntityDescription entityForName:@"RoadAssetPrice" inManagedObjectContext:context];
//    NSPredicate *predicate = nil;
//    if (![standardName isEqualToString:RoadAssetPriceStandardAllStandards]) {
//        predicate = [NSPredicate predicateWithFormat:@"standard == %@", standardName];
//    }
//    NSFetchRequest *fecthRequest=[[NSFetchRequest alloc] init];
//    [fecthRequest setEntity:entity];
//    [fecthRequest setPredicate:predicate];
//    
//    NSError *err=nil;
//    NSArray *fetchResult = [context executeFetchRequest:fecthRequest error:&err];
//    if (err == nil) {
//        return fetchResult;
//    } else {
//        return nil;
//    }
//}

@end
