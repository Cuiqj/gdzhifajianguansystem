//
//  CustomPersonButton.m
//  GDZhiFaJianGuanSystem
//
//  Created by quxiuyun on 14-3-5.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import "CustomPersonButton.h"
#import <objc/runtime.h>
@implementation UIButton(CustomPersonButton)
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void) setCanEdit:(BOOL) newCanEdit
{
    NSNumber *number = [NSNumber numberWithBool: newCanEdit];
    objc_setAssociatedObject(self, "canEdit", number , OBJC_ASSOCIATION_RETAIN);
}

- (BOOL) canEdit
{
    NSNumber *number = objc_getAssociatedObject(self, "canEdit");
    return [number boolValue];
}
@end