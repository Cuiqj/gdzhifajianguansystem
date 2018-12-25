//
//  LocalFileDao.m
//  MyIOSTest
//
//  Created by coco on 13-5-29.
//  Copyright (c) 2013年 edaoyou. All rights reserved.
//

#import "LocalFileDao.h"

@interface LocalFileDao()
-(NSString*)getFullFileName:(NSString*)fileName forType:(NSString*)extension;
-(NSString*)getTmpFullFileName;
@end

@implementation LocalFileDao

static LocalFileDao *myInstance = nil;

+ (LocalFileDao*)getInstance
{
    if(!myInstance){
        myInstance = [[LocalFileDao alloc] init];
        myInstance.extendDir = nil;
    }
    return myInstance;
}

+ (id) getFileObjects:(NSString*)name fileType:(NSString*)type;
{
    NSDictionary* fileTypeMap = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[NSNumber numberWithInt:0],[NSNumber numberWithInt:1],[NSNumber numberWithInt:2],[NSNumber numberWithInt:3], nil] forKeys:[NSArray arrayWithObjects:@"png",@"plist",@"txt",@"dat", nil]];
    NSString* path = [[NSBundle bundleForClass:[self class]] pathForResource:name ofType:type];
    NSError* error;
    switch ([[fileTypeMap objectForKey:type] intValue]) {
        case 0:
            return [UIImage imageWithContentsOfFile:path];
            break;
        case 1:
            return [NSDictionary dictionaryWithContentsOfFile:path];
            break;
        case 2:
            //return [NSString stringWithContentsOfFile:path usedEncoding:enc error:&error];
            return [NSString stringWithContentsOfFile:path encoding:NSISOLatin2StringEncoding error:&error];
            break;
        case 3:
        default:
            return [[[NSFileManager alloc] init] contentsAtPath:path];
            break;
    }
}

-(NSString*)getFullFileName:(NSString*)fileName forType:(NSString*)extension
{
    NSString *Path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fullFileName;
    if (self.extendDir) {
        NSError* error;
        NSString* extendPath = [NSString stringWithFormat:@"%@/%@",Path,self.extendDir];
        if (![[NSFileManager defaultManager] fileExistsAtPath:extendPath]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:extendPath withIntermediateDirectories:YES attributes:nil error:&error];
        }
        fullFileName = [[extendPath stringByAppendingPathComponent:fileName] stringByAppendingString:extension];
    }else{
        fullFileName = [[Path stringByAppendingPathComponent:fileName] stringByAppendingString:extension];
    }
    return fullFileName;
}

-(NSString*)getTmpFullFileName
{
    NSString *tmpPath = NSTemporaryDirectory();
    NSString* tmpFileName = [tmpPath stringByAppendingPathComponent:@"tmp_file_2013"];
    return tmpFileName;
}

-(void)writeToBinFile:(NSString*)fileName fileData:(NSData*)content
{
    NSString* fullFileName = [self getFullFileName:fileName forType:@".dat"];
    [content writeToFile:fullFileName atomically:YES];
}

-(BOOL)writeToPlistFile:(NSString*)fileName fileData:(id)content
{
    NSString* fullFileName = [self getFullFileName:fileName forType:@".plist"];
    BOOL writeOK = [(NSDictionary*)content writeToFile:fullFileName atomically:YES];

    return writeOK;
}

-(id)readFromTxtFile:(NSString*)fileName
{
    NSData* content;
    NSString* appFile = [self getFullFileName:fileName forType:@"txt"];
    if([[NSFileManager defaultManager] fileExistsAtPath:appFile])
    {
        content = [[NSFileManager defaultManager] contentsAtPath:appFile];
    }else{
        content = [[NSFileManager defaultManager] contentsAtPath:[[NSBundle mainBundle] pathForResource:fileName ofType:@"txt"]];
    }
    return  content;
}

-(id)readFromPlistFile:(NSString*)fileName
{
    NSString* appFile = [self getFullFileName:fileName forType:@".plist"];
    if([[NSFileManager defaultManager] fileExistsAtPath:appFile])
        return [NSDictionary dictionaryWithContentsOfFile:appFile];
    else
        return [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"]];
}

-(void)tempWrite:(NSData*)content
{
    NSString* fullFileName = [self getTmpFullFileName];
    [content writeToFile:fullFileName atomically:YES];
}

@end
