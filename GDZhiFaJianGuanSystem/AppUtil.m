//
//  AppVariates.m
//  GDZhiFaJianGuanSystem
//
//  Created by yu hongwu on 14-10-11.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import "AppUtil.h"
#import "DataModelCenter.h"
@implementation AppUtil

+(void)getOrgList:(void (^)())asyncHanlder{
    //获取全部机构，在案件界面的所属机构中用到，还有巡查信息界面的管养单位用到
    [[[DataModelCenter defaultCenter] webService] getSupervisionLowerOrgList:@"" withAsyncHanlder:^(NSArray *orgList, NSError *err) {
		dispatch_sync(dispatch_get_main_queue(), ^{
			if (err == nil) {
				[self getTreeViewNode:orgList];
			}
		});
    }];
}
+(void)getTreeViewNode:(NSArray*)orgList{
	TreeViewNode* tree = [[TreeViewNode alloc]init];
	tree.nodeObject = [orgList objectAtIndex:0];
	tree.nodeLevel = 0;
	tree.isExpanded = NO;
	tree.nodeChildren= [[NSMutableArray alloc] init];
	NSMutableArray *orgMutableList = (NSMutableArray*)orgList;
	[orgMutableList removeObject:[orgList objectAtIndex:0]];
	[self findSubOrg:tree allOrgs:orgMutableList level:1];
	ORG_TREE = [NSMutableArray arrayWithObjects:tree, nil];
}
+(void) findSubOrg:(TreeViewNode*)tree allOrgs:(NSMutableArray*)orgList level:(NSInteger)level{
	OrgInfoSimpleModel *treeOrg = (OrgInfoSimpleModel*)tree.nodeObject;
	if(treeOrg.lowerOrgId && ![treeOrg.lowerOrgId isEmpty]){
		for (OrgInfoSimpleModel *org in orgList){
			if([org.belongtoOrgCode isEqualToString:((OrgInfoSimpleModel*)tree.nodeObject).identifier]){
				TreeViewNode *temp = [[TreeViewNode alloc]init];
				temp.nodeObject = org;
				temp.nodeLevel = level;
				temp.isExpanded = NO;
				temp.nodeChildren = [[NSMutableArray alloc] init];
				
				[tree.nodeChildren addObject:temp];
			}
		}
		for(TreeViewNode *t in tree.nodeChildren){
			[orgList removeObject:t.nodeObject];
			[self findSubOrg:t allOrgs:orgList level:level+1];
		}
		
	}
}
@end
