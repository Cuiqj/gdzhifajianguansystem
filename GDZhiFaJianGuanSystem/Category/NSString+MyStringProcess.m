//
//  NSString+MyStringProcess.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-8-8.
//  Copyright (c) 2012年 中交宇科 . All rights reserved.
//

#import "NSString+MyStringProcess.h"




@implementation NSString (MyStringProcess)


//将数字日期转换成为中文汉字日期，仅转换单独数字。如果是2013-01-01等类型的日期，需分隔开之后再单独转换处理，参数决定是否按年份转换
- (NSString *)numberDateToChineseAndIsYearDate:(BOOL)isYearDate{
	NSString *result = @"";
	NSArray *strChinese = @[@"〇", @"一", @"二", @"三", @"四", @"五", @"六", @"七", @"八", @"九", @"十"];
	if (isYearDate) {
		NSString *numberStringFromSelf = [[NSString alloc] initWithFormat:@"%d",self.integerValue];
		for (int i = 0; i < numberStringFromSelf.length; i++) {
			NSString *sub = [numberStringFromSelf substringWithRange:NSMakeRange(i, 1)];
			result = [result stringByAppendingString:[strChinese objectAtIndex:sub.integerValue]];
		}
	} else {
		NSInteger dateNumber = self.integerValue%100;
		NSInteger date1 = dateNumber/10;
		NSInteger date2 = dateNumber%10;
		if (date1 > 1) {
			result = [result stringByAppendingString:[strChinese objectAtIndex:date1]];
		}
		if (date1 > 0) {
			result = [result stringByAppendingString:[strChinese objectAtIndex:10]];
		}
		if (date2 != 0) {
			result = [result stringByAppendingString:[strChinese objectAtIndex:date2]];
		}
	}
	return result;
}


//检查字符串是否为空
- (BOOL)isEmpty{
    if([self length] == 0) { 
        //string is empty or nil
        return YES;
    } else if([[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        //string is all whitespace
        return YES;
    }
    return NO;
}

-(NSString *)emptyString
{
    if ([self isEmpty]) {
        return @"";
    }
    return self;
}



//生成随机ID
+ (NSString *)randomID{
	NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
	[dateFormatter setLocale:[NSLocale currentLocale]];
	[dateFormatter setDateFormat:@"yyMMddHHmmssSSS"];
    NSString *IDString=[dateFormatter stringFromDate:[NSDate date]];
    return IDString;
}

- (NSString *)encryptedString{
    static char cvt[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    "abcdefghijklmnopqrstuvwxyz"
    "0123456789#@$";
    
	static char fillchar = '*';
    
    NSString *temp = [self lowercaseString];
    NSData *tempData = [temp dataUsingEncoding:NSUTF8StringEncoding];
    UInt8 *data = (UInt8 *)[tempData bytes];
    int c;
    int len = [tempData length];
    NSMutableString *ret = [NSMutableString stringWithCapacity:((len / 3) + 1) * 4];
    for (int i = 0; i < len; ++i) {
        c = (data[i] >> 2) & 0x3f;
        [ret appendFormat:@"%c",cvt[c]];
        c = (data[i] << 4) & 0x3f;
        if (++i < len) {
            c |= (data[i] >> 4) & 0x0f;
        }
        [ret appendFormat:@"%c",cvt[c]];
        if (i < len) {
            c = (data[i] << 2) & 0x3f;
            if (++i < len) {
                c |= (data[i] >> 6) & 0x03;
            }
            [ret appendFormat:@"%c",cvt[c]];
        } else {
            ++i;
            [ret appendFormat:@"%c",fillchar];

        }
        if (i < len) {
            c = data[i] & 0x3f;
            [ret appendFormat:@"%c",cvt[c]];
        } else {
            [ret appendFormat:@"%c",fillchar];
        }
    }
    return ret;
}


- (NSString *)serializedXMLElementStringWithElementName:(NSString *)elementName{
    NSString *serializedXML;
    if ([self isEmpty]) {
        serializedXML = [[NSString alloc] initWithFormat:@"<%@ xsi:nil=\"true\" />",elementName];
    } else {
        serializedXML = [[NSString alloc] initWithFormat:@"<%@>%@</%@>",elementName,self,elementName];
    }
    return serializedXML;
}
@end


@implementation NSString (TrimmingAdditions)

- (NSString *)stringByTrimmingLeadingCharactersInSet:(NSCharacterSet *)characterSet {
    NSUInteger location = 0;
    NSUInteger length = [self length];
    unichar charBuffer[length];    
    [self getCharacters:charBuffer];    
    for (location=0; location < length; location++) {
        if (![characterSet characterIsMember:charBuffer[location]]) {
            break;
        }
    }    
    return [self substringWithRange:NSMakeRange(location, length - location)];
}

- (NSString *)stringByTrimmingTrailingCharactersInSet:(NSCharacterSet *)characterSet {
    NSUInteger location = 0;
    NSUInteger length=[self length];
    unichar charBuffer[length];    
    [self getCharacters:charBuffer];    
    for (length=[self length]; length > 0; length--) {
        if (![characterSet characterIsMember:charBuffer[length - 1]]) {
            break;
        }
    }    
    return [self substringWithRange:NSMakeRange(location, length - location)];
}

@end

