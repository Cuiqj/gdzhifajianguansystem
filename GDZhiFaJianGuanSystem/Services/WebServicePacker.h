//
//  WebServicePacker.h
//  GDZhiFaJianGuanSystem
//
//  Created by XU SHIWEN on 14-2-8.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebServicePacker : NSObject

+ (instancetype)packerWithServerURL:(NSURL *)serverURL userName:(NSString *)userName andPassword:(NSString *)password;

- (NSString *)messageForService:(NSString *)serviceName andParams:(NSDictionary *)params;

@property (nonatomic, copy) NSString *(^formXMLElementForObj)(id obj, NSString *objPrefix, NSInteger webSequenceNum);

@end
