//
//  TheProjectCell.m
//  The Projects
//
//  Created by Ahmed Karim on 1/11/13.
//  Copyright (c) 2013 Ahmed Karim. All rights reserved.
//

#import "CollapseCell.h"


@interface CollapseCell()

@property (nonatomic) BOOL isExpanded;

@end

@implementation CollapseCell

#pragma mark - Draw controls messages

- (void)drawRect:(CGRect)rect
{

	
	CGRect cellFrame = self.cellLabel.frame;
	int indentation = self.treeNode.nodeLevel * 25;
	if([self.treeNode.nodeChildren count] < 1){
		self.cellButton.hidden = YES;
		cellFrame.origin.x =  indentation + 5;
		self.cellLabel.frame = cellFrame;
	}else{
		self.cellButton.hidden = NO;
		CGRect buttonFrame = self.cellButton.frame;
		cellFrame.origin.x = buttonFrame.size.width + indentation + 5;
		buttonFrame.origin.x = 2 + indentation;
		self.cellLabel.frame = cellFrame;
		self.cellButton.frame = buttonFrame;
	}
}

- (void)setTheButtonBackgroundImage:(UIImage *)backgroundImage
{
    [self.cellButton setBackgroundImage:backgroundImage forState:UIControlStateNormal];
}

- (IBAction)expand:(id)sender
{
	if([self.treeNode.nodeChildren count] > 0 && self.treeNode.isExpanded == NO){
		self.treeNode.isExpanded = YES;
		
		
	}else{
		self.treeNode.isExpanded = NO;
	}
	[self setSelected:NO];
	[self.delegate expandCollapseNode];
}

@end
