//
//  AGAlertViewWithProgressbar.h
//  GDZhiFaJianGuanSystem
//
//  Created by quxiuyun on 14-2-12.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AGAlertViewWithProgressbar : NSObject<UIAlertViewDelegate>
{
    NSUInteger progress;
    NSString *title;
    NSString *message;
    NSString *cancelButtonTitle;
    NSArray *otherButtonTitles;
}

@property (nonatomic, assign) NSUInteger progress;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *message;
@property (nonatomic, retain) NSString *cancelButtonTitle;
@property (nonatomic, retain) NSArray *otherButtonTitles;
@property (nonatomic, assign) id<UIAlertViewDelegate> delegate;
@property (nonatomic, readonly, getter=isVisible) BOOL visible;

- (id)initWithTitle:(NSString *)theTitle message:(NSString *)theMessage andDelegate:(id<UIAlertViewDelegate>)theDelegate;
- (id)initWithTitle:(NSString *)theTitle message:(NSString *)theMessage delegate:(id)theDelegate cancelButtonTitle:(NSString *)titleForTheCancelButton otherButtonTitles:(NSString *)titleForTheFirstButton, ... NS_REQUIRES_NIL_TERMINATION;

- (void)show;
- (void)hide;
@end
