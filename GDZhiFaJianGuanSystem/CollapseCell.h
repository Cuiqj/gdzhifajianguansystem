//
//  TheProjectCell.h
//  The Projects
//
//  Created by Ahmed Karim on 1/11/13.
//  Copyright (c) 2013 Ahmed Karim. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TreeViewNode.h"
@protocol CollapseCellDelegate;
@interface CollapseCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *cellLabel;
@property (retain, nonatomic) IBOutlet UIButton *cellButton;
@property (retain, strong) TreeViewNode *treeNode;
@property (retain, strong) id<CollapseCellDelegate> delegate;
- (IBAction)expand:(id)sender;
- (void)setTheButtonBackgroundImage:(UIImage *)backgroundImage;

@end
@protocol CollapseCellDelegate <NSObject>

- (void)expandCollapseNode;

@end