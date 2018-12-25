//
//  BaseDataModel.m
//  GDZhiFaJianGuanSystem
//
//  Created by XU SHIWEN on 14-2-8.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import "BaseDataModel.h"

@implementation BaseDataModel

+ (instancetype)newModelFromXML:(id)xml
{
    // 需由子类实现
    NSAssert(NO, @"no implemented, if you want to use this method, please implemented in your subclass!");
    return nil;
}

- (NSString *)xmlForWebService
{
    return [self xmlForWebServiceWithPrefix:@"per"];
}

- (NSString *)xmlForWebServiceWithPrefix:(NSString *)prefix
{
    int i;
    unsigned int propertyCount = 0;
    objc_property_t *propertyList = class_copyPropertyList([self class], &propertyCount);
    NSString *xmlString=@"";
    xmlString = [xmlString stringByAppendingFormat:@"<%@:%@> \n",prefix,NSStringFromClass([self class])];
    for ( i=0; i < propertyCount; i++ ) {
        objc_property_t *thisProperty = propertyList + i;
        const char* propertyName = property_getName(*thisProperty);
        NSString *propertyKey=[[NSString alloc] initWithUTF8String:propertyName];
        NSString *propertyValue = [self valueForKey:propertyKey]==nil ? @"":[self valueForKey:propertyKey];
        if ([propertyKey isEqualToString:@"identifier"]) {
            propertyKey = @"identifier";
        }
        if (![propertyValue isEmpty]) {
            xmlString = [xmlString stringByAppendingFormat:@"<%@:%@>%@</%@:%@> \n",prefix,propertyKey,propertyValue,prefix,propertyKey];
        }
    }
    xmlString = [xmlString stringByAppendingFormat:@"</%@:%@> \n",prefix,NSStringFromClass([self class])];
    return xmlString;

}

- (NSString *)XMLStringWithOutModelNameFromObjectWithPrefix:(NSString *)prefix{
//    int i;
//    unsigned int propertyCount = 0;
//    objc_property_t *propertyList = class_copyPropertyList([self class], &propertyCount);
//    NSString *xmlString=@"";
//    for ( i=0; i < propertyCount; i++ ) {
//        objc_property_t *thisProperty = propertyList + i;
//        const char* propertyName = property_getName(*thisProperty);
//        NSString *propertyKey=[[NSString alloc] initWithUTF8String:propertyName];
//        NSString *propertyValue = [self valueForKey:propertyKey] == nil ? @"" : [self valueForKey:propertyKey];
//        if ([propertyKey isEqualToString:@"id"]) {
//            propertyKey = @"id";
//        }
//        if (!KILL_NIL_STRING(propertyValue )) {
//            xmlString = [xmlString stringByAppendingFormat:@"<%@:%@>%@</%@:%@> \n",prefix,propertyKey,propertyValue,prefix,propertyKey];
//        }
//    }
//    return xmlString;
    int i;
    unsigned int propertyCount = 0;
    objc_property_t *propertyList = class_copyPropertyList([self class], &propertyCount);
    NSString *xmlString=@"";
    for ( i=0; i < propertyCount; i++ ) {
        objc_property_t *thisProperty = propertyList + i;
        const char* propertyName = property_getName(*thisProperty);
        NSString *propertyKey=[[NSString alloc] initWithUTF8String:propertyName];
        NSString *propertyValue = [self valueForKey:propertyKey] == nil ? @"" : [self valueForKey:propertyKey];
        if ([propertyKey isEqualToString:@"identifier"]) {
            propertyKey = @"id";
        }
        if (![propertyValue isEmpty]) {
            xmlString = [xmlString stringByAppendingFormat:@"<%@:%@>%@</%@:%@> \n",prefix,propertyKey,propertyValue,prefix,propertyKey];
        }
    }
    return xmlString;
}

@end
