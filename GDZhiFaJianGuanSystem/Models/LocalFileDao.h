//
//  LocalFileDao.h
//  wulian
//
//  Created by coco on 13-5-29.
//  Copyright (c) 2013年 edaoyou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocalFileDao : NSObject

+ (LocalFileDao*)getInstance;

+ (id) getFileObjects:(NSString*)name fileType:(NSString*)type;

@property (nonatomic,retain) NSString* extendDir;

-(void)writeToBinFile:(NSString*)fileName fileData:(NSData*)content;
-(BOOL)writeToPlistFile:(NSString*)fileName fileData:(id)content;
-(id)readFromPlistFile:(NSString*)fileName;
-(id)readFromTxtFile:(NSString*)fileName;
-(void)tempWrite:(NSData*)content;

@end
