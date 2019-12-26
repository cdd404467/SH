//
//  DesignerMainPageVC.m
//  SH
//
//  Created by i7colors on 2019/11/28.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "DesignerMainPageVC.h"
#import <JXPagerView.h>
#import <JXCategoryView.h>
#import <JXCategoryTitleView.h>
#import "DesignerMainHeaderView.h"
#import "DesignerMaterialListView.h"
#import "DesignerFinishedProductListView.h"
#import "DesignerDynamicStateListView.h"
#import "NetTool.h"
#import "MaterialModel.h"
#import "DesignerModel.h"
#import "UIView+Border.h"


@interface DesignerMainPageVC ()<JXPagerViewDelegate,JXCategoryViewDelegate,JXPagerMainTableViewGestureDelegate>
@property (nonatomic, strong) JXPagerView *pagerView;
@property (nonatomic, strong, readonly) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) DesignerMainHeaderView *headerView;
@property (nonatomic, strong) NSMutableArray *sucaiDataSource;
@property (nonatomic, strong) NSMutableArray *productDataSource;
@property (nonatomic, strong) NSMutableArray *dynamicDataSource;
@property (nonatomic, strong) DesignerModel *infotDataSource;
@end

@implementation DesignerMainPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBar.title = @"设计师首页";
    [self requestMultiData];
}

- (DesignerMainHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[DesignerMainHeaderView alloc] init];
    }
    return _headerView;
}

- (NSMutableArray *)sucaiDataSource {
    if (!_sucaiDataSource) {
        _sucaiDataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _sucaiDataSource;
}

- (NSMutableArray *)productDataSource {
    if (!_productDataSource) {
        _productDataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _productDataSource;
}

- (NSMutableArray *)dynamicDataSource {
    if (!_dynamicDataSource) {
        _dynamicDataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _dynamicDataSource;
}



- (void)setupUI {
    _categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    self.categoryView.titles = @[@"素材",@"成品",@"动态"];
    self.categoryView.backgroundColor = [UIColor whiteColor];
    self.categoryView.delegate = self;
    self.categoryView.titleSelectedColor = HEXColor(@"#FF5100", 1);
    self.categoryView.titleColor = HEXColor(@"#9B9B9B", 1);
    self.categoryView.titleColorGradientEnabled = YES;
    self.categoryView.titleLabelZoomEnabled = YES;
//    self.categoryView.contentScrollViewClickTransitionAnimationEnabled = NO;
    [self.categoryView addBorder:HEXColor(@"#f6f6f6", 1) width:1 direction:BorderDirectionBottom];
//    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
//    lineView.indicatorColor = HEXColor(@"#FF5100", 1);
//    self.categoryView.indicators = @[lineView];

    _pagerView = [[JXPagerView alloc] initWithDelegate:self];
    _pagerView.frame = CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT);
    self.pagerView.mainTableView.gestureDelegate = self;
    [self.view addSubview:self.pagerView];
    self.categoryView.contentScrollView = self.pagerView.listContainerView.collectionView;
}

- (JXPagerView *)preferredPagingView {
    return [[JXPagerView alloc] initWithDelegate:self];
}

#pragma mark 请求数据
- (void)requestMainPage:(dispatch_group_t _Nullable)group {
    if (group)
            dispatch_group_enter(group);
        NSString *urlString = [NSString stringWithFormat:URLGet_DesignerMain_Info,@NO,_designerId];
        [NetTool getRequest:urlString Params:nil Success:^(id  _Nonnull json) {
//            NSLog(@"main ----   %@",json);
            self.infotDataSource = [DesignerModel mj_objectWithKeyValues:json];
            if (group)
                dispatch_group_leave(group);
        } Failure:^(NSError * _Nonnull error) {
            
        }];
}

- (void)requestSucai:(dispatch_group_t _Nullable)group {
    if (group)
        dispatch_group_enter(group);
    NSString *urlString = [NSString stringWithFormat:URLGet_DesignerMain_MaterialList,@NO,_designerId,PageCount,self.pageNumber];
    [NetTool getRequest:urlString Params:nil Success:^(id  _Nonnull json) {
//        NSLog(@"sucai ----   %@",json);
        NSArray *tempArr = json[@"list"];
        self.sucaiDataSource = [MaterialModel mj_objectArrayWithKeyValuesArray:tempArr];
        for (MaterialModel *model in self.sucaiDataSource) {
            model.labelInfoList = [LabelModel mj_objectArrayWithKeyValuesArray:model.labelInfoList];
        }
        if (group)
            dispatch_group_leave(group);
    } Failure:^(NSError * _Nonnull error) {
        
    }];
}

//设计师成品
- (void)requestFinishedProduct:(dispatch_group_t _Nullable)group {
    if (group)
        dispatch_group_enter(group);
    NSString *urlString = [NSString stringWithFormat:URLGet_DesignerMain_FinishedProductList,@NO,_designerId];
    [NetTool getRequest:urlString Params:nil Success:^(id  _Nonnull json) {
//        NSLog(@"cp----   %@",json);
        NSArray *tempArr = json[@"list"];
        self.productDataSource = [FinishedWorkModel mj_objectArrayWithKeyValuesArray:tempArr];
        for (FinishedWorkModel *model in self.productDataSource) {
            model.works = [model.works stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        }
        
        if (group)
            dispatch_group_leave(group);
    } Failure:^(NSError * _Nonnull error) {
        
    }];
}

//设计师动态
- (void)requestDynamicState:(dispatch_group_t _Nullable)group {
    if (group)
        dispatch_group_enter(group);
    NSString *urlString = [NSString stringWithFormat:URLGet_DesignerMain_DynamicState,@NO,_designerId,PageCount,self.pageNumber];
    [NetTool getRequest:urlString Params:nil Success:^(id  _Nonnull json) {
//        NSLog(@"dt----   %@",json);
        NSArray *tempArr = json[@"list"];
        self.dynamicDataSource = [DynamicStateModel mj_objectArrayWithKeyValuesArray:tempArr];
        for (DynamicStateModel *model in self.dynamicDataSource) {
            model.trendsList = [DynamicImgModel mj_objectArrayWithKeyValuesArray:model.trendsList];
            for (DynamicImgModel *md in model.trendsList) {
                md.logo = [md.logo stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            }
        }
        if (group)
            dispatch_group_leave(group);
    } Failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)requestMultiData {
    dispatch_group_t group = dispatch_group_create();
    [self requestMainPage:group];
    [self requestSucai:group];
    [self requestFinishedProduct:group];
    [self requestDynamicState:group];
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self setupUI];
        self.headerView.model = self.infotDataSource;
    });
}



#pragma mark - JXPagerViewDelegate
//headerView
- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView {

    return self.headerView;
}
//headerView高度
- (NSUInteger)tableHeaderViewHeightInPagerView:(JXPagerView *)pagerView {
    
    return KFit_W(330);
}

//滚动区域高度
- (NSUInteger)heightForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return 49;
}

- (UIView *)viewForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return self.categoryView;
}

- (NSInteger)numberOfListsInPagerView:(JXPagerView *)pagerView {
    //和categoryView的item数量一致
    return self.categoryView.titles.count;
}

- (id<JXPagerViewListViewDelegate>)pagerView:(JXPagerView *)pagerView initListAtIndex:(NSInteger)index {
    if (index == 0) {
        DesignerMaterialListView *listView = [[DesignerMaterialListView alloc] init];
        listView.nav = self.navigationController;
        listView.dataSource = self.sucaiDataSource;
        return listView;
    } else if (index == 1){
        DesignerFinishedProductListView *listView = [[DesignerFinishedProductListView alloc] init];
        listView.dataSource = self.productDataSource;
        return listView;
    } else {
        DesignerDynamicStateListView *listView = [[DesignerDynamicStateListView alloc] init];
        listView.dataSource = self.dynamicDataSource;
//        listView.dataSource = @[@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3"@"1",@"2",@"3"@"1",@"2",@"3"].mutableCopy;
        listView.nav = self.navigationController;
        return listView;
    }
    
}

#pragma mark - JXCategoryViewDelegate

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    self.navigationController.interactivePopGestureRecognizer.enabled = (index == 0);
}

#pragma mark - JXPagerMainTableViewGestureDelegate

- (BOOL)mainTableViewGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    //禁止categoryView左右滑动的时候，上下和左右都可以滚动
    if (otherGestureRecognizer == self.categoryView.collectionView.panGestureRecognizer) {
        return NO;
    }
    return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}

@end
