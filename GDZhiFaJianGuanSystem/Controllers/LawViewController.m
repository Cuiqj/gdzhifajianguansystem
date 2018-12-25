//
//  LawViewController.m
//  GDZhiFaJianGuanSystem
//
//  Created by quxiuyun on 14-2-17.
//  Copyright (c) 2014年 Top Touch. All rights reserved.
//

#import "LawViewController.h"
#import "RATreeView.h"
#import "RATreeView+TableViewDelegate.h"
#import "LawsDocsViewController.h"
#import "DataModelCenter.h"
#import "RoadEngrossPriceModel.h"//占利用标准
#import "RoadAssetPriceModel.h"//赔补偿标准
#import "MBProgressHUD.h"


#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

typedef enum _TreeNodeTag {
    TreeNodeTagSectionOneTitle = 1,
    TreeNodeTagSectionTwoTitle,
    TreeNodeTagLawsAndRules,
    TreeNodeTagStateLaws,
    TreeNodeTagMOTLaws,
    TreeNodeTagGZLaws,
    TreeNodeTagPayStandards,
    TreeNodeTagUsingStandards
} TreeNodeTag;

#pragma mark - PriceStandard
@implementation PriceStandard

+ (PriceStandard *)priceStandardFromCoreDataObject:(RoadAssetPriceModel *)cdObject
{
    PriceStandard *standard = [[PriceStandard alloc] init];
    if (standard) {
        standard.big_type = cdObject.big_type;
        standard.name = cdObject.name;
        standard.price = cdObject.price.stringValue;
        standard.spec = cdObject.spec;
        standard.unit_name = cdObject.unit_name;
        standard.remark = cdObject.remark;
    }
    return standard;
}
@end

#pragma mark - RADataObject

@interface RADataObject : NSObject

@property (nonatomic) int tag;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSArray *children;

- (id)initWithName:(NSString *)name children:(NSArray *)array tag:(TreeNodeTag)tag;
+ (id)dataObjectWithName:(NSString *)name children:(NSArray *)children tag:(TreeNodeTag)tag;

@end


@implementation RADataObject

- (id)initWithName:(NSString *)name children:(NSArray *)children tag:(TreeNodeTag)tag
{
    self = [super init];
    if (self) {
        self.children = children;
        self.name = name;
        self.tag = tag;
    }
    return self;
}

+ (id)dataObjectWithName:(NSString *)name children:(NSArray *)children tag:(TreeNodeTag)tag
{
    return [[self alloc] initWithName:name children:children tag:tag];
}

@end

#pragma mark - LawDocsViewController

@interface LawViewController ()<RATreeViewDataSource,RATreeViewDelegate>

@property (nonatomic, strong) NSArray *data1;
@property (nonatomic, strong) NSArray *data2;

@property (nonatomic, strong) NSArray *menuData;
@property (nonatomic, strong) NSArray *stateLawsData;
@property (nonatomic, strong) NSArray *motLawsData;
@property (nonatomic, strong) NSArray *gzLawsData;
@property (nonatomic, strong) NSMutableArray *payStandardsData;

@property (nonatomic, strong) RATreeView *treeViewTop;
@property (nonatomic, strong) id expandedNode;

@property (nonatomic, strong) LawsDocsViewController *rightViewController;
@property (nonatomic, strong) RATreeView *treeViewBottom;
@property (nonatomic, strong) DataModelCenter * dataModelCenter;
//@property (nonatomic, strong) NSMutableArray * priceArray;//赔补偿数组

- (void)updateSectionTwoWithTag:(TreeNodeTag)tag;


@end

@implementation LawViewController{
	MBProgressHUD *hud;
}

#pragma mark - Controller Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	[[[DataModelCenter defaultCenter] webService].queue cancelAllOperations];
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
        if ( IOS7_OR_LATER )
        {
            self.edgesForExtendedLayout = UIRectEdgeNone;
            self.extendedLayoutIncludesOpaqueBars = NO;
            self.modalPresentationCapturesStatusBarAppearance = NO;
        }
#endif // #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
#pragma mark - PriceStandard

- (void)viewDidLoad
{
	[[[DataModelCenter defaultCenter] webService].queue cancelAllOperations];
    [super viewDidLoad];

    self.title = @"法律法规";
    UIBarButtonItem * backbutton =[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(backButton)];
    [self.navigationItem setLeftBarButtonItem:backbutton animated:YES];

    self.treeViewTop = [[RATreeView alloc] initWithFrame:self.leftTopView.bounds style:RATreeViewStylePlain];
    [self.treeViewTop setDataSource:self];
    [self.treeViewTop setDelegate:self];
    [self.treeViewTop setSeparatorStyle:RATreeViewCellSeparatorStyleSingleLine];
    [self.leftTopView addSubview:self.treeViewTop];
    
    self.treeViewBottom = [[RATreeView alloc] initWithFrame:self.leftBottomView.bounds style:RATreeViewStylePlain];
    [self.treeViewBottom setDataSource:self];
    [self.treeViewBottom setDelegate:self];
    [self.treeViewBottom setAllowsSelection:YES];
    [self.treeViewBottom setSeparatorStyle:RATreeViewCellSeparatorStyleSingleLine];
    [self.leftBottomView addSubview:self.treeViewBottom];

    self.rightViewController = [[LawsDocsViewController alloc] initWithNibName:@"LawsDocsViewController" bundle:nil];
    [self.rightView addSubview:self.rightViewController.view];
    
    RADataObject *stateLaws = [RADataObject dataObjectWithName:@"国家法律法规" children:nil tag:TreeNodeTagStateLaws];
    RADataObject *motLaws = [RADataObject dataObjectWithName:@"交通部法律法规" children:nil tag:TreeNodeTagMOTLaws];
    RADataObject *guizhouLaws = [RADataObject dataObjectWithName:@"贵州省规定" children:nil tag:TreeNodeTagGZLaws];
    RADataObject *lawsAndRules = [RADataObject dataObjectWithName:@"法律法规" children:[NSArray arrayWithObjects:stateLaws, motLaws, guizhouLaws, nil] tag:TreeNodeTagLawsAndRules];
    RADataObject *payStandards = [RADataObject dataObjectWithName:@"赔补偿标准" children:nil tag:TreeNodeTagPayStandards];
    RADataObject *usingStandards = [RADataObject dataObjectWithName:@"占利用标准" children:nil tag:TreeNodeTagUsingStandards];
    self.menuData = [NSArray arrayWithObjects: lawsAndRules, payStandards, usingStandards, nil];
    self.data1 = self.menuData;
    
    RADataObject *stateLaws1 = [RADataObject dataObjectWithName:@"中华人民共和国公路法" children:nil tag:TreeNodeTagStateLaws];
    RADataObject *stateLaws2 = [RADataObject dataObjectWithName:@"中华人民共和国道路交通安全法" children:nil tag:TreeNodeTagStateLaws];
    RADataObject *stateLaws3 = [RADataObject dataObjectWithName:@"公路安全保护条例" children:nil tag:TreeNodeTagStateLaws];
    self.stateLawsData = [NSArray arrayWithObjects: stateLaws1, stateLaws2, stateLaws3, nil];
    
    RADataObject *motLaws1 = [RADataObject dataObjectWithName:@"路政管理规定" children:nil tag:TreeNodeTagMOTLaws];
    RADataObject *motLaws2 = [RADataObject dataObjectWithName:@"超限运输车辆行驶公路管理规定" children:nil tag:TreeNodeTagMOTLaws];
    RADataObject *motLaws3 = [RADataObject dataObjectWithName:@"关于在全国开展车辆超限超载治理工作的实施方案" children:nil tag:TreeNodeTagMOTLaws];
    self.motLawsData = [NSArray arrayWithObjects: motLaws1, motLaws2, motLaws3, nil];
    
    RADataObject *gzLaws1 = [RADataObject dataObjectWithName:@"贵州省公路路政管理条例" children:nil tag:TreeNodeTagGZLaws];
    self.gzLawsData = [NSArray arrayWithObjects:gzLaws1, nil];
    
    NSArray *priceStandardsData = [RoadAssetPriceModel allDistinctPropertiesNamed:@"standard"];
    NSMutableArray *temp = [NSMutableArray array];
    for (NSString *priceStandard in priceStandardsData) {
        [temp addObject:[RADataObject dataObjectWithName:priceStandard children:nil tag:TreeNodeTagPayStandards]];
    }
    self.payStandardsData = temp;
	

}

#pragma mark - IBActions
- (void)backButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Manage Data

- (void)updateSectionTwoWithTag:(TreeNodeTag)tag
{
    switch (tag) {
        case TreeNodeTagStateLaws: {
            self.data2 = self.stateLawsData;
            [self.treeViewBottom reloadData];
        }
            break;
        case TreeNodeTagMOTLaws: {
            self.data2 = self.motLawsData;
            [self.treeViewBottom reloadData];
        }
            break;
        case TreeNodeTagGZLaws: {
            self.data2 = self.gzLawsData;
            [self.treeViewBottom reloadData];
        }
            break;
        case TreeNodeTagPayStandards: {
            self.data2 = self.payStandardsData;
            [self.treeViewBottom reloadData];
        }
            break;
        case TreeNodeTagUsingStandards: {
            
        }
        default:
            break;
    }
}


#pragma mark - RATreeViewDataSource

- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    cell.textLabel.text = ((RADataObject *)item).name;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (treeNodeInfo.treeDepthLevel == 0) {
        cell.detailTextLabel.textColor = [UIColor blackColor];
    }
    return cell;
}

- (NSInteger)treeView:(RATreeView *)treeView numberOfChildrenOfItem:(id)item
{
    if (item == nil) {
        if (treeView == self.treeViewTop) {
            return [self.data1 count];
        } else {
            return [self.data2 count];
        }
        
    }
    RADataObject *data = item;
    return [data.children count];
}

- (id)treeView:(RATreeView *)treeView child:(NSInteger)index ofItem:(id)item
{
    RADataObject *data = item;
    if (item == nil) {
        if (treeView == self.treeViewTop) {
            return [self.data1 objectAtIndex:index];
        } else {
            return [self.data2 objectAtIndex:index];
        }
    }
    return [data.children objectAtIndex:index];
}

#pragma mark - RATreeViewDelegate
- (CGFloat)treeView:(RATreeView *)treeView heightForRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    return 47;
}

- (NSInteger)treeView:(RATreeView *)treeView indentationLevelForRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    return 2 * treeNodeInfo.treeDepthLevel;
}

- (BOOL)treeView:(RATreeView *)treeView shouldExpandItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    return YES;
}

- (BOOL)treeView:(RATreeView *)treeView shouldItemBeExpandedAfterDataReload:(id)item treeDepthLevel:(NSInteger)treeDepthLevel
{
    if ([item isEqual:self.expandedNode]) {
        return YES;
    }
    return NO;
}

- (BOOL)treeView:(RATreeView *)treeView canEditRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    return NO;
}

- (void)treeView:(RATreeView *)treeView willDisplayCell:(UITableViewCell *)cell forItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    if (treeNodeInfo.treeDepthLevel == 0) {
        cell.backgroundColor = UIColorFromRGB(0xF7F7F7);
    } else if (treeNodeInfo.treeDepthLevel == 1) {
        cell.backgroundColor = UIColorFromRGB(0xD1EEFC);
    } else if (treeNodeInfo.treeDepthLevel == 2) {
        cell.backgroundColor = UIColorFromRGB(0xE0F8D8);
    }
}

- (void)treeView:(RATreeView *)treeView didDeselectRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    UITableViewCell *cell = [treeView cellForItem:item];
    if (treeNodeInfo.treeDepthLevel == 0) {
        cell.backgroundColor = UIColorFromRGB(0xF7F7F7);
    } else if (treeNodeInfo.treeDepthLevel == 1) {
        cell.backgroundColor = UIColorFromRGB(0xD1EEFC);
    } else if (treeNodeInfo.treeDepthLevel == 2) {
        cell.backgroundColor = UIColorFromRGB(0xE0F8D8);
    }
}

- (void)treeView:(RATreeView *)treeView didSelectRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    UITableViewCell *cell = [treeView cellForItem:item];
    [cell setBackgroundColor:UIColorFromRGB(0xE0F8D8)];
    
    RADataObject *data = item;
    if (treeView == self.treeViewTop) {
        NSLog(@"%d, %d", treeNodeInfo.treeDepthLevel, treeNodeInfo.positionInSiblings);
        switch (data.tag) {
            case TreeNodeTagStateLaws:
            case TreeNodeTagMOTLaws:
            case TreeNodeTagGZLaws:
                [self updateSectionTwoWithTag:data.tag];
                break;
            case TreeNodeTagPayStandards: {
                [self updateSectionTwoWithTag:data.tag];
                [self.rightViewController showTableView:YES];
                [self.rightViewController showWebView:NO];
                NSArray *allPrices = [RoadAssetPriceModel roadAssetPricesForStandard:RoadAssetPriceStandardAllStandards];
				if(allPrices == nil || [allPrices count] < 1){
					// Should be initialized with the windows frame so the HUD disables all user input by covering the entire screen
					hud = [[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
					
					// Add HUD to screen
					[self.view.window addSubview:hud];
					
					// Register for HUD callbacks so we can remove it from the window at the right time
					hud.delegate = self;
					
					hud.labelText = NSLocalizedString(@"正在下载数据", nil);
					hud.detailsLabelText = NSLocalizedString(@"请稍等...", nil);

					// Show the HUD while the provided method executes in a new thread
					[hud showWhileExecuting:@selector(downRoadassetPriceData) onTarget:self withObject:nil animated:YES];
					return;
				}
                NSMutableArray *data = [NSMutableArray array];
                for (RoadAssetPriceModel *price in allPrices) {
                    NSArray *row = @[price.big_type, price.name, price.price.stringValue, price.spec, price.unit_name, price.remark];
                    [data addObject:row];
                    //                    [data addObject:[PriceStandard priceStandardFromCoreDataObject:price]];
                }
                [self.rightViewController loadTableData:data];
            }
                break;
            case TreeNodeTagUsingStandards: {
                [self.rightViewController showTableView:YES];
                [self.rightViewController showWebView:NO];
                self.data2 = @[];
                [self.treeViewBottom reloadData];
                NSArray *allPrices = [RoadEngrossPriceModel allInstances];
				if(allPrices == nil || [allPrices count] < 1){
					// Should be initialized with the windows frame so the HUD disables all user input by covering the entire screen
					hud = [[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
					
					// Add HUD to screen
					[self.view.window addSubview:hud];
					
					// Register for HUD callbacks so we can remove it from the window at the right time
					hud.delegate = self;
					
					hud.labelText = NSLocalizedString(@"正在下载数据", nil);
					hud.detailsLabelText = NSLocalizedString(@"请稍等...", nil);
					
					// Show the HUD while the provided method executes in a new thread
					[hud showWhileExecuting:@selector(downRoadEngrossPriceData) onTarget:self withObject:nil animated:YES];
					return;
				}
                NSMutableArray *data = [NSMutableArray array];
                for (RoadEngrossPriceModel *price in  allPrices) {
                    NSArray *row = @[price.type, price.name, price.price.stringValue, price.spec, price.unit_name, price.remark];
                    [data addObject:row];
                }
                [self.rightViewController loadTableData:data];
            }
                break;
            default:
                break;
        }
    } else {
        switch (data.tag) {
            case TreeNodeTagStateLaws:
            case TreeNodeTagMOTLaws:
            case TreeNodeTagGZLaws:
            {
                [self.rightViewController showTableView:NO];
                [self.rightViewController showWebView:YES];
                NSURL *pdfURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:data.name ofType:@"pdf"]];
                [self.rightViewController loadWebData:pdfURL];
            }
                break;
            case TreeNodeTagPayStandards: {
                [self.rightViewController showTableView:YES];
                [self.rightViewController showWebView:NO];
                NSArray *allPrices = [RoadAssetPriceModel roadAssetPricesForStandard:data.name];
                NSMutableArray *data = [NSMutableArray array];
                for (RoadAssetPriceModel *price in allPrices) {
                    NSArray *row = @[price.big_type, price.name, price.price.stringValue, price.spec, price.unit_name, price.remark];
                    [data addObject:row];
                    //                    [data addObject:[PriceStandard priceStandardFromCoreDataObject:price]];
                }
                [self.rightViewController loadTableData:data];
            }
                break;
            default:
                break;
        }
    }
}

- (void)downRoadassetPriceData{
    [[DataModelCenter defaultCenter].webService getSupervisionRoadassetPriceBySynchronous:^(NSArray *roadasset, NSError *err) {
    }];
	NSArray *allPrices = [RoadAssetPriceModel roadAssetPricesForStandard:RoadAssetPriceStandardAllStandards];
	NSMutableArray *data = [NSMutableArray array];
	for (RoadAssetPriceModel *price in allPrices) {
		NSArray *row = @[price.big_type, price.name, price.price.stringValue, price.spec, price.unit_name, price.remark];
		[data addObject:row];
	}
	[self.rightViewController loadTableData:data];
	NSArray *priceStandardsData = [RoadAssetPriceModel allDistinctPropertiesNamed:@"standard"];
    NSMutableArray *temp = [NSMutableArray array];
    for (NSString *priceStandard in priceStandardsData) {
        [temp addObject:[RADataObject dataObjectWithName:priceStandard children:nil tag:TreeNodeTagPayStandards]];
    }
	self.payStandardsData = temp;
	self.data2 = self.payStandardsData;
	[self.treeViewBottom reloadData];
	
}
- (void)downRoadEngrossPriceData{
	[[DataModelCenter defaultCenter].webService getSupervisionRoadEngrossPriceBySynchronous:^(NSArray *roadEngross, NSError *err){}];
	NSArray *allPrices = [RoadEngrossPriceModel allInstances];
	NSMutableArray *data = [NSMutableArray array];
	for (RoadEngrossPriceModel *price in  allPrices) {
		NSArray *row = @[price.type, price.name, price.price.stringValue, price.spec, price.unit_name, price.remark];
		[data addObject:row];
	}
	[self.rightViewController loadTableData:data];
}
- (void)hudWasHidden {
    // Remove HUD from screen
    [hud removeFromSuperview];
	
    // add here the code you may need
	
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
