//
//  RoadAssetPriceModel.m
//  GDZhiFaJianGuanSystem
//
//  Created by luna on 14-3-3.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import "RoadAssetPriceModel.h"

NSString * const RoadAssetPriceStandardAllStandards = @"所有标准";
@implementation RoadAssetPriceModel

@dynamic identifier;
@dynamic name;
@dynamic type;
@dynamic spec;
@dynamic price;
@dynamic unit_name;
@dynamic remark;
@dynamic depart_num;
@dynamic standard;
@dynamic big_type;
@dynamic damage_type;

+ (instancetype)newModelFromXML:(id)xml
{
    // 解析xml
    RoadAssetPriceModel *roadModel = nil;
    
    TBXMLElement *xmlElement = NULL;
    [(NSValue *)xml getValue:&xmlElement];
    
    if (xmlElement) {
        // 解析xml
        
        TBXMLElement * big_typeElement = [TBXML childElementNamed:@"big_type" parentElement:xmlElement];
        
        NSString * big_typeStr = [TBXML textForElement:big_typeElement];
        
        TBXMLElement * damage_typeElement = [TBXML childElementNamed:@"damage_type" parentElement:xmlElement];
        
        NSString * damage_typeStr = [TBXML textForElement:damage_typeElement];
        
        TBXMLElement * depart_numElement = [TBXML childElementNamed:@"depart_num" parentElement:xmlElement];
        
        NSString * depart_numStr = [TBXML textForElement:depart_numElement];
        
        TBXMLElement * nameElement = [TBXML childElementNamed:@"name" parentElement:xmlElement];
        
        NSString * nameStr = [TBXML textForElement:nameElement];
        
        TBXMLElement * priceElement = [TBXML childElementNamed:@"price" parentElement:xmlElement];
        
        NSString * priceStr = [TBXML textForElement:priceElement];
        
        TBXMLElement * remarkElement = [TBXML childElementNamed:@"remark" parentElement:xmlElement];
        
        NSString * remarkStr = [TBXML textForElement:remarkElement];
        
        TBXMLElement * specElement = [TBXML childElementNamed:@"spec" parentElement:xmlElement];
        
        NSString * specStr = [TBXML textForElement:specElement];
        
        TBXMLElement * idElement = [TBXML childElementNamed:@"id" parentElement:xmlElement];
        
        NSString * idStr = [TBXML textForElement:idElement];
        
        TBXMLElement * standardElement = [TBXML childElementNamed:@"standard" parentElement:xmlElement];
        
        NSString * standardStr = [TBXML textForElement:standardElement];
        
        TBXMLElement * typeElement = [TBXML childElementNamed:@"type" parentElement:xmlElement];
        
        NSString * typeStr = [TBXML textForElement:typeElement];
        
        TBXMLElement * unit_nameElement = [TBXML childElementNamed:@"unit_name" parentElement:xmlElement];
        
        NSString * unit_nameStr = [TBXML textForElement:unit_nameElement];
        
        NSManagedObjectContext *context=[MYAPPDELEGATE managedObjectContext];
        NSEntityDescription *entity=[NSEntityDescription entityForName:@"RoadAssetPriceModel" inManagedObjectContext:context];
        roadModel =[[RoadAssetPriceModel alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
        roadModel.big_type=big_typeStr;
        roadModel.damage_type=damage_typeStr;
        roadModel.depart_num=depart_numStr;
        roadModel.name=nameStr;
        roadModel.price=[NSNumber numberWithDouble:priceStr.doubleValue];
        roadModel.remark=remarkStr;
        roadModel.spec=specStr;
        roadModel.identifier=idStr;
        roadModel.standard=standardStr;
        roadModel.type=typeStr;
        roadModel.unit_name=unit_nameStr;
        NSError *error;
        if(![context save:&error])
        {
            NSLog(@" RoadAssetPriceModel  不能保存：%@",[error localizedDescription]);
        }
    }
    [MYAPPDELEGATE saveContext];
    
    return roadModel;
}

+ (NSArray *)allDistinctPropertiesNamed:(NSString *)propertyName {
    NSManagedObjectContext *context=[MYAPPDELEGATE managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"RoadAssetPriceModel" inManagedObjectContext:context];
    NSFetchRequest *fecthRequest=[[NSFetchRequest alloc] init];
    [fecthRequest setEntity:entity];
    [fecthRequest setResultType:NSDictionaryResultType];
    [fecthRequest setReturnsDistinctResults:YES];
    [fecthRequest setPropertiesToFetch:[NSArray arrayWithObject:propertyName]];

    NSError *err=nil;
    NSArray *fetchResult = [context executeFetchRequest:fecthRequest error:&err];
    if (err == nil) {
        NSMutableArray *allDistinctProperties = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < fetchResult.count; i++) {
            id propertyValue = fetchResult[i][propertyName];
            if ([propertyValue respondsToSelector:@selector(isEmpty)] &&
                ![propertyValue isEmpty]) {
                [allDistinctProperties addObject:propertyValue];
            }
        }
        return [allDistinctProperties copy];
    } else {
        return nil;
    }
}

+ (NSArray *)roadAssetPricesForStandard:(NSString *)standardName {
    NSManagedObjectContext *context=[MYAPPDELEGATE managedObjectContext];

    NSEntityDescription *entity=[NSEntityDescription entityForName:@"RoadAssetPriceModel" inManagedObjectContext:context];
    NSPredicate *predicate = nil;
    if (![standardName isEqualToString:RoadAssetPriceStandardAllStandards]) {
        predicate = [NSPredicate predicateWithFormat:@"standard == %@", standardName];
    }
    NSFetchRequest *fecthRequest=[[NSFetchRequest alloc] init];
    [fecthRequest setEntity:entity];
    [fecthRequest setPredicate:predicate];
    
    NSError *err=nil;
    NSArray *fetchResult = [context executeFetchRequest:fecthRequest error:&err];
    if (err == nil) {
        return fetchResult;
    } else {
        return nil;
    }
}
@end
