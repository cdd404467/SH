//
//  ArtistShopHomePageVC.m
//  SH
//
//  Created by i7colors on 2020/1/15.
//  Copyright © 2020 surhoo. All rights reserved.
//

#import "ArtistShopHomePageVC.h"
#import "NetTool.h"
#import <JXPagerView.h>
#import <JXCategoryView.h>
#import "ShopHeaderView.h"
#import "ShopModel.h"
#import "CddHud.h"
#import "GoodsListViewVC.h"
#import "ArtistIntroductionChildVC.h"
#import "UIView+Border.h"
#import "ShopNestGoodsChildVC.h"
#import "ShopNestWorksChildVC.h"

#define HeaderViewHeight KFit_W(260)

@interface ArtistShopHomePageVC ()<JXCategoryViewDelegate, JXPagerViewDelegate, JXPagerMainTableViewGestureDelegate>
@property (nonatomic, strong) JXPagerView *pagerView;
@property (nonatomic, strong) ShopHeaderView *shopHeaderView;
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) NSMutableArray *titlesArray;
@property (nonatomic, strong) ShopHomePageModel *dataSource;
@property (nonatomic, strong) NSMutableArray *infoListArr;
@end

@implementation ArtistShopHomePageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBar.title = @"店铺主页";
    self.navBar.backgroundColor = HEXColor(@"#333434", 1);
    self.navBar.backBtnTintColor = UIColor.whiteColor;
    self.navBar.titleLabel.textColor = UIColor.whiteColor;
    [self requestShopDetails];
}

- (NSMutableArray *)titlesArray {
    if (!_titlesArray) {
        _titlesArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _titlesArray;
}

- (NSMutableArray *)infoListArr {
    if (!_infoListArr) {
        _infoListArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _infoListArr;
}


- (ShopHeaderView *)shopHeaderView {
    if (!_shopHeaderView) {
        _shopHeaderView = [[ShopHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HeaderViewHeight)];
        _shopHeaderView.bannerArray = self.dataSource.bannerList;
        [_shopHeaderView.shopLogo sd_setImageWithURL:ImgUrl_SD_OSS(self.dataSource.shopLogo, 52) placeholderImage:PlaceHolder_Header];
        _shopHeaderView.shopNameLab.text = self.dataSource.name;
    }
    return _shopHeaderView;
}

- (void)setupUI {
    _categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    self.categoryView.titles = self.titlesArray;
    self.categoryView.backgroundColor = UIColor.whiteColor;
    self.categoryView.delegate = self;
    self.categoryView.titleSelectedColor = HEXColor(@"#FF5100", 1);
    self.categoryView.titleColor = HEXColor(@"#9B9B9B", 1);
    self.categoryView.titleColorGradientEnabled = YES;
    [self.categoryView addBorder:Line_Color width:0.8 direction:BorderDirectionBottom];
//    self.categoryView.titleLabelZoomEnabled = YES;
    
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorColor = HEXColor(@"#FF5100", 1);
//    lineView.indicatorWidth = 60;
    self.categoryView.indicators = @[lineView];

    _pagerView = [[JXPagerView alloc] initWithDelegate:self];
    _pagerView.mainTableView.bounces = NO;
    _pagerView.frame = CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT);
    self.pagerView.mainTableView.gestureDelegate = self;
    [self.view addSubview:self.pagerView];
    self.categoryView.contentScrollView = self.pagerView.listContainerView.collectionView;
//    self.categoryView.listContainer = (id<JXCategoryViewListContainer>)self.pagerView.listContainerView;
}

- (void)requestShopDetails {
    [CddHud show:self.view];
    NSString *urlString = [NSString stringWithFormat:URLGet_Shop_HomePage,@NO,_shopID];
    [NetTool getRequest:urlString Params:nil Success:^(id _Nonnull json) {
        [CddHud hideHUD:self.view];
//        NSLog(@"----   %@",json);
        self.dataSource = [ShopHomePageModel mj_objectWithKeyValues:json];
        self.dataSource.classifyList = [ClassifyListModel mj_objectArrayWithKeyValuesArray:self.dataSource.classifyList];
        if (self.dataSource.isSynopsis == 1) {
            [self.titlesArray addObject:@"艺术家"];
            [self.infoListArr addObject:@"isSynopsis"];
        }
        if (self.dataSource.isOriginal == 1) {
            [self.titlesArray addObject:@"作品"];
            [self.infoListArr addObject:@"isOriginal"];
        }
        if (self.dataSource.isGoods == 1) {
            [self.titlesArray addObject:@"衍生品"];
            [self.infoListArr addObject:@"isGoods"];
        }
        [self setupUI];
    } Failure:^(NSError * _Nonnull error) {
        
    }];
}

#pragma mark - JXPagerViewDelegate
//headerView
- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView {

    return self.shopHeaderView;
}
//headerView高度
- (NSUInteger)tableHeaderViewHeightInPagerView:(JXPagerView *)pagerView {
    
    return HeaderViewHeight;
}

//滚动区域高度
- (NSUInteger)heightForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return 50;
}

- (UIView *)viewForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return self.categoryView;
}

- (NSInteger)numberOfListsInPagerView:(JXPagerView *)pagerView {
    //和categoryView的item数量一致
    return self.categoryView.titles.count;
}

- (id<JXPagerViewListViewDelegate>)pagerView:(JXPagerView *)pagerView initListAtIndex:(NSInteger)index {
    NSString *type = self.infoListArr[index];
    if ([type isEqualToString:@"isSynopsis"]) {
        ArtistIntroductionChildVC *vc = [[ArtistIntroductionChildVC alloc] init];
        vc.synopsisID = self.dataSource.synopsisId;
        return vc;
    } else if ([type isEqualToString:@"isOriginal"]) {
        ShopNestWorksChildVC *vc = [[ShopNestWorksChildVC alloc] init];
        vc.nav = self.navigationController;
        vc.shopID = _shopID;
        return vc;
    } else {
        ShopNestGoodsChildVC *vc = [[ShopNestGoodsChildVC alloc] init];
        vc.classifyArray = self.dataSource.classifyList;
        vc.nav = self.navigationController;
        return vc;
    }
}


#pragma mark - JXCategoryViewDelegate

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
//    self.navigationController.interactivePopGestureRecognizer.enabled = (index == 0);
}

#pragma mark - JXPagerMainTableViewGestureDelegate

- (BOOL)mainTableViewGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    //禁止categoryView左右滑动的时候，上下和左右都可以滚动
    if (otherGestureRecognizer == self.categoryView.collectionView.panGestureRecognizer) {
        return NO;
    }
    return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}

- (BOOL)checkIsNestContentScrollView:(UIScrollView *)scrollView {
    for (ShopNestGoodsChildVC *list in self.pagerView.validListDict.allValues) {
        if (list.contentScrollView == scrollView) {
            return YES;
        }
    }
    return NO;
}

//修改statesBar 颜色
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;  //白色，默认的值是黑色的
}
@end
