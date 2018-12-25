//
//  NSString+MyStringProcess.h
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-8-8.
//  Copyright (c) 2012年 中交宇科 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

static inline NSString *KILL_NIL_STRING(NSString *str) {
    if (!str) {
        str = @"";
    }
    return str;
}

@interface NSString (MyStringProcess)


                
//将数字日期转换成为中文汉字日期，仅转换单独数字。如果是2013-01-01等类型的日期，需分隔开之后再单独转换处理，参数决定是否按年份转换
- (NSString *)numberDateToChineseAndIsYearDate:(BOOL)isYearDate;

//检查字符串是否为空
- (BOOL)isEmpty;

//如果字符串为空  返回空的字符串，否则返回原字符串
-(NSString *)emptyString;

//生成随机ID
+ (NSString *)randomID;


//对字符串加密
- (NSString *)encryptedString;

//将字符串序列化为xml元素
- (NSString *)serializedXMLElementStringWithElementName:(NSString *)elementName;
@end

@interface NSString (TrimmingAdditions)
//移除字符串变量中的给定前导字符
- (NSString *)stringByTrimmingLeadingCharactersInSet:(NSCharacterSet *)characterSet;
//移除字符串变量中的给定尾随字符
- (NSString *)stringByTrimmingTrailingCharactersInSet:(NSCharacterSet *)characterSet;
@end