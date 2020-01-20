//
//  SceneDetailsVC.m
//  SH
//
//  Created by i7colors on 2019/9/18.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "SceneDetailsVC.h"
#import "NetTool.h"
#import "SceneDetailHeaderView.h"
#import <JXPagerView.h>
#import <JXCategoryView.h>
#import <JXCategoryTitleView.h>
#import "GoodsModel.h"
#import "MaterialModel.h"
#import "SceneModel.h"
#import "SceneDetailListView.h"
#import "GoodsCVCell.h"
#import "MaterialCVCell.h"
#import "ScreenClassView.h"
#import "SuspendFlowLayout.h"
#import "GoodsDetailsVC.h"
#import "MaterialDetailsVC.h"

static NSString *goodsCVID = @"GoodsCVCell";
static NSString *materialCVID = @"MaterialCVCell";
static NSString *headerID = @"ScreenClassView";

@interface SceneDetailsVC () <JXPagerViewDelegate,JXCategoryViewDelegate,JXPagerMainTableViewGestureDelegate,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) JXPagerView *pagerView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong, readonly) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) SceneDetailHeaderView *headerView;
@property (nonatomic, strong) NSMutableArray *goodsDataSource;
@property (nonatomic, strong) NSMutableArray *sucaiDataSource;
@property (nonatomic, copy) NSString *imgUrl;
@property (nonatomic, strong) NSArray *iconArray;
@property (nonatomic, assign) int listType;
@property (nonatomic, assign) NSInteger headerHeight;
@end

@implementation SceneDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBar.title = @"场景详情";
    [self requestMultiData];
}

- (SceneDetailHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[SceneDetailHeaderView alloc] init];
        DDWeakSelf;
        _headerView.clickJumpBlock = ^(NSString * _Nonnull sceneID) {
            SceneDetailsVC *vc = [[SceneDetailsVC alloc] init];
            vc.sceneId = sceneID.intValue;
            [weakself.navigationController pushViewController:vc animated:YES];
        };
    }
    return _headerView;
}

- (NSMutableArray *)goodsDataSource {
    if (!_goodsDataSource) {
        _goodsDataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _goodsDataSource;
}

- (NSMutableArray *)sucaiDataSource {
    if (!_sucaiDataSource) {
        _sucaiDataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _sucaiDataSource;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        SuspendFlowLayout *layout = [[SuspendFlowLayout alloc] init];
        CGRect rect = CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT);
        _collectionView = [[UICollectionView alloc]initWithFrame:rect collectionViewLayout:layout];
        _collectionView.backgroundColor = HEXColor(@"#F6F6F6", 1);
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [_collectionView registerClass:[GoodsCVCell class] forCellWithReuseIdentifier:goodsCVID];
        [_collectionView registerClass:[MaterialCVCell class] forCellWithReuseIdentifier:materialCVID];
        [_collectionView registerClass:[ScreenClassView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerID];
    }
    return _collectionView;
}



- (void)setupUI {
    _categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    self.categoryView.titles = @[@"商品",@"素材"];
    self.categoryView.backgroundColor = [UIColor whiteColor];
    self.categoryView.delegate = self;
    self.categoryView.titleSelectedColor = HEXColor(@"#FF5100", 1);
    self.categoryView.titleColor = HEXColor(@"#9B9B9B", 1);
    self.categoryView.titleColorGradientEnabled = YES;
    self.categoryView.titleLabelZoomEnabled = YES;
//    self.categoryView.contentScrollViewClickTransitionAnimationEnabled = NO;

    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorColor = HEXColor(@"#FF5100", 1);
//    lineView.indicatorWidth = 60;
    self.categoryView.indicators = @[lineView];

    _pagerView = [[JXPagerView alloc] initWithDelegate:self];
    _pagerView.frame = CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT);
    self.pagerView.mainTableView.gestureDelegate = self;
    [self.view addSubview:self.pagerView];
    self.categoryView.contentScrollView = self.pagerView.listContainerView.collectionView;
}


#pragma mark 请求数据
//图片和下级场景
- (void)requestData:(dispatch_group_t _Nullable)group {
    if (group)
        dispatch_group_enter(group);
    NSString *urlString = [NSString stringWithFormat:URLGet_Scene_Detail,_sceneId];
    [NetTool getRequest:urlString Params:nil Success:^(id  _Nonnull json) {
//        NSLog(@"----   %@",json);
        if ([[json allKeys] containsObject:@"logo"]) {
            self.imgUrl = json[@"logo"];
        }
        if ([[json allKeys] containsObject:@"infoList"]) {
            self.iconArray = json[@"infoList"];
            self.iconArray = [SceneModel mj_objectArrayWithKeyValuesArray:self.iconArray];
        }
        if (group)
            dispatch_group_leave(group);
    } Failure:^(NSError * _Nonnull error) {
                    
    }];
}

//商品和素材列表
- (void)requestListWithGoodsType:(int)type sortType:(int)sortType group:(dispatch_group_t _Nullable)group {
    if (group) {
        dispatch_group_enter(group);
    }
    NSString *urlString = [NSString stringWithFormat:URLGet_Scene_Detail_List,_sceneId,type,sortType,PageCount,1];
    [NetTool getRequest:urlString Params:nil Success:^(id  _Nonnull json) {
//            NSLog(@"----   %@",json);
        if ([[json allKeys] containsObject:@"list"]) {
            NSArray *tempArr = json[@"list"];
            if (type == 1 && tempArr.count > 0) {
                tempArr = [GoodsModel mj_objectArrayWithKeyValuesArray:tempArr];
                [self.goodsDataSource removeAllObjects];
                [self.goodsDataSource addObjectsFromArray:tempArr];
            } else if (type == 2 && tempArr.count > 0) {
                tempArr = [MaterialModel mj_objectArrayWithKeyValuesArray:tempArr];
                [self.sucaiDataSource removeAllObjects];
                [self.sucaiDataSource addObjectsFromArray:tempArr];
                for (MaterialModel *model in self.sucaiDataSource) {
                    model.labelInfoList = [LabelModel mj_objectArrayWithKeyValuesArray:model.labelInfoList];
                }
            }
        }
        if (group) {
            dispatch_group_leave(group);
        } else {
            [self.collectionView reloadData];
        }
    } Failure:^(NSError * _Nonnull error) {
                    
    }];
}

- (void)requestMultiData {
    dispatch_group_t group = dispatch_group_create();
    
    [self requestData:group];
    for (int i = 1; i < 3; i++) {
        [self requestListWithGoodsType:i sortType:1 group:group];
    }
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if (self.iconArray.count > 0) {
            self.headerHeight = KFit_W(225) + 120;
        } else {
            self.headerHeight = KFit_W(225);
        }
        
        if (self.goodsDataSource.count > 0 && self.sucaiDataSource.count > 0) {
            [self setupUI];
        }
        //不是两个都有的情况
        else {
            if (self.goodsDataSource.count != 0) {
                self.listType = 1;
            } else if (self.sucaiDataSource.count !=0) {
                self.listType = 2;
            }
            [self.view addSubview:self.collectionView];
            self.headerView.frame = CGRectMake(0, -self.headerHeight, SCREEN_WIDTH, self.headerHeight);
            [self.collectionView addSubview:self.headerView];
            self.collectionView.contentInset = UIEdgeInsetsMake(self.headerHeight, 0, Bottom_Height_Dif, 0);
        }
        self.headerView.bannerURL = self.imgUrl;
        self.headerView.iconArray = self.iconArray;
    });
}

#pragma mark - collectionView delegate
/** 每组几个cell*/
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_listType == 1) {
        return self.goodsDataSource.count;
    }
    return self.sucaiDataSource.count;
}

//cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_listType == 1) {
        CGFloat imageWidth = (SCREEN_WIDTH - 16 * 2 - 10) / 2;
        return CGSizeMake(imageWidth , imageWidth + 96);
    }
    return CGSizeMake(SCREEN_WIDTH , 130);
}

//cell行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (_listType == 1) {
        return 10;
    }
    return 0;
}

//cell列间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (_listType == 1) {
        return 10;
    }
    return 0;
}

//section四周的边距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (_listType == 1) {
        return UIEdgeInsetsMake(0, 16, 10, 16);
    }
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

//设置header尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(SCREEN_WIDTH, 49);
}

- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    //解决滚动条遮挡问题
    view.layer.zPosition = 0.0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_listType == 1) {
        GoodsDetailsVC *vc = [[GoodsDetailsVC alloc] init];
        GoodsModel *model = self.goodsDataSource[indexPath.row];
        vc.goodsID = model.goodsId;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (_listType == 2) {
        MaterialDetailsVC *vc = [[MaterialDetailsVC alloc] init];
        MaterialModel *model = self.sucaiDataSource[indexPath.row];
        vc.materialId = model.materialId;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//设置头部
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *view = [UICollectionReusableView new];
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        ScreenClassView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerID forIndexPath:indexPath];
        DDWeakSelf;
        header.btnClickBlock = ^(NSInteger type) {
            [weakself requestListWithGoodsType:self.listType sortType:(int)type group:nil];
        };
        view = header;
    }
    return view;
}

//数据源
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_listType == 1) {
        GoodsCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:goodsCVID forIndexPath:indexPath];
        cell.model = self.goodsDataSource[indexPath.row];
        return cell;
    } else {
        MaterialCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:materialCVID forIndexPath:indexPath];
        cell.model = self.sucaiDataSource[indexPath.row];
        return cell;
    }
}


#pragma mark - JXPagerViewDelegate
//headerView
- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView {

    return self.headerView;
}
//headerView高度
- (NSUInteger)tableHeaderViewHeightInPagerView:(JXPagerView *)pagerView {
    
    return self.headerHeight;
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
    SceneDetailListView *listView = [[SceneDetailListView alloc] init];
    listView.sceneId = _sceneId;
    listView.listType = index + 1;
    if (index == 0) {
        listView.dataSource = self.goodsDataSource;
    } else {
        listView.dataSource = self.sucaiDataSource;
    }
    listView.nav = self.navigationController;
    return listView;
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


