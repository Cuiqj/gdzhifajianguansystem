//
//  AnnouncementsViewController.h
//  GDZhiFaJianGuanSystem
//
//  Created by quxiuyun on 14-2-25.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrgArticleModel.h"

@interface AnnouncementsViewController : UIViewController

@property (strong, nonatomic) OrgArticleModel * orgArticleModel;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UITextView *textContent;

@end
