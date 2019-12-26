//
//  HomePageVC.m
//  SH
//
//  Created by i7colors on 2019/9/3.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "HomePageVC.h"
#import "HomeSectionHeader.h"
#import "NetTool.h"
#import "HomePageModel.h"
#import "HomeSceneCVCell.h"
#import "HomeDesignerListCVCell.h"
#import "SceneIconCVCell.h"
#import "GoodsCVCell.h"
#import "ColorfulFlowLayout.h"
#import "AllClassifyVC.h"
#import "SearchAllKindsVC.h"
#import "GoodsDetailsVC.h"
#import "SceneDetailsVC.h"
#import "MoreFooterView.h"
#import "DesignerMainPageVC.h"
#import "HomePageBannerView.h"


static NSString *iconCVID = @"SceneIconCVCell";
static NSString *sceneCVID = @"sceneCell";
static NSString *designerCVID = @"HomeDesignerListCVCell";
static NSString *goodsCVID = @"HotGoodsCVCell";
static NSString *section_Header = @"section_Header";
static NSString *section_Header_banner = @"HomePageBannerView";
static NSString *section_Footer = @"MoreFooterView";
@interface HomePageVC ()<UICollectionViewDelegate, UICollectionViewDataSource, ColorfulDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
//数据源
@property (nonatomic, strong) HomePageModel *dataSource;
@end

@implementation HomePageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBar];
    [self.view addSubview:self.collectionView];
    [self requestData];
}

- (void)setNavBar {
    self.navBar.backgroundColor = HEXColor(@"#333434", 1);
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NavBarHeight)];
    titleView.backgroundColor = UIColor.clearColor;
    //搜索按钮
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(10, 0, SCREEN_WIDTH - 10 - 49, 30);
    searchBtn.centerY = titleView.centerY;
    searchBtn.layer.cornerRadius = searchBtn.height * 0.5;
    searchBtn.clipsToBounds = YES;
    searchBtn.adjustsImageWhenHighlighted = NO;
    searchBtn.backgroundColor = UIColor.blackColor;
    [searchBtn setImage:[UIImage imageNamed:@"search_icon"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(jumpToSearch) forControlEvents:UIControlEventTouchUpInside];
//    [searchBtn setTitle:@"搜索商品、场景、店铺、设计师、素材" forState:UIControlStateNormal];
    [searchBtn setTitle:@"搜索商品、场景、设计师、素材" forState:UIControlStateNormal];
    [searchBtn setTitleColor:HEXColor(@"#9B9B9B", 1) forState:UIControlStateNormal];
    searchBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [titleView addSubview:searchBtn];

    //分类button
    UIButton *classBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    classBtn.frame = CGRectMake(searchBtn.right + 14, 0, 20, 20);
    classBtn.centerY = searchBtn.centerY;
    classBtn.adjustsImageWhenHighlighted = NO;
    [classBtn setImage:[UIImage imageNamed:@"classify_btn"] forState:UIControlStateNormal];
    [classBtn addTarget:self action:@selector(jumpToAllClassify) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:classBtn];
    
//    self.navigationItem.titleView = titleView;
    self.navBar.navBarView = titleView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        ColorfulFlowLayout *layout = [[ColorfulFlowLayout alloc] init];
        CGRect rect = CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT);
        _collectionView = [[UICollectionView alloc]initWithFrame:rect collectionViewLayout:layout];
        _collectionView.backgroundColor = HEXColor(@"#F6F6F6", 1);
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, TABBAR_HEIGHT + 40, 0);
        [_collectionView registerClass:[SceneIconCVCell class] forCellWithReuseIdentifier:iconCVID];
        [_collectionView registerClass:[HomeSceneCVCell class] forCellWithReuseIdentifier:sceneCVID];
        [_collectionView registerClass:[HomeDesignerListCVCell class] forCellWithReuseIdentifier:designerCVID];
        [_collectionView registerClass:[GoodsCVCell class] forCellWithReuseIdentifier:goodsCVID];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"test"];
        [_collectionView registerClass:[HomeSectionHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:section_Header];
        [_collectionView registerClass:[HomePageBannerView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:section_Header_banner];
        [_collectionView registerClass:[MoreFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:section_Footer];
    }

    return _collectionView;
}

#pragma mark 请求数据
- (void)requestData {
    [NetTool getRequest:URLGet_Index_Data Params:nil Success:^(id  _Nonnull json) {
//        NSLog(@"----   %@",json);
        self.dataSource = [HomePageModel mj_objectWithKeyValues:json];
        self.dataSource.BANNER = [BannerModel mj_objectArrayWithKeyValuesArray:self.dataSource.BANNER];
        self.dataSource.FIRSTSCENE = [SceneModel mj_objectArrayWithKeyValuesArray:self.dataSource.FIRSTSCENE];
        self.dataSource.SCENE = [SceneModel mj_objectArrayWithKeyValuesArray:self.dataSource.SCENE];
//        self.dataSource.DESIGNER = [DesignerModel mj_objectArrayWithKeyValuesArray:self.dataSource.DESIGNER];
        self.dataSource.GOODS = [GoodsModel mj_objectArrayWithKeyValuesArray:self.dataSource.GOODS];
//        self.headerView.bannerArray = self.dataSource.BANNER;
        [self.collectionView reloadData];
    } Failure:^(NSError * _Nonnull error) {
                    
    }];
}

#pragma mark - 页面跳转
//所有分类
- (void)jumpToAllClassify {
    AllClassifyVC *vc = [[AllClassifyVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//搜索
- (void)jumpToSearch {
    SearchAllKindsVC *vc = [[SearchAllKindsVC alloc] init];
    [self.navigationController pushViewController:vc animated:NO];
}


#pragma mark - collectionView delegate
/** 总共多少组*/
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}

/** 每组几个cell*/
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        if (self.dataSource.FIRSTSCENE.count > 8) {
            if (self.dataSource.isPullDown) {
                return self.dataSource.FIRSTSCENE.count;
            } else {
                return 8;
            }
        } else {
            return self.dataSource.FIRSTSCENE.count;
        }
    }
    else if (section == 1) {
        return self.dataSource.SCENE.count;
    }
//    else if (section == 2) {
//        return 1;
//    }
    else if (section == 2) {
        return self.dataSource.GOODS.count;
    }
    else {
        return 2;
    }
}

//cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        CGFloat itemWidth = (SCREEN_WIDTH - 20 * 2 - 25 * 3) / 4;
        return CGSizeMake(itemWidth, KFit_W(44) + 25);
    } else if (indexPath.section == 1) {
        return CGSizeMake(SCREEN_WIDTH , KFit_W(200) + 50);
    }
//    else if (indexPath.section == 2) {
//        return CGSizeMake(SCREEN_WIDTH , 170);
//    }
    else if (indexPath.section == 2) {
        CGFloat imageWidth = (SCREEN_WIDTH - 16 * 2 - 10) / 2;
        return CGSizeMake(imageWidth , imageWidth + 96);
    }
    else {
        return CGSizeMake(60 , 60);
    }
}

//cell行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return 20;
    }
    else if (section == 2) {
        return 10;
    }
    return 0;
//    else {
//        return 0;
//    }
}

//cell列间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return 25;
    }
    else if (section == 2) {
        return 10;
    }
    return 0;
//    else {
//        return 0;
//    }
}

//section四周的边距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return UIEdgeInsetsMake(20, 20, 0, 20);
    } else if (section == 2) {
        return UIEdgeInsetsMake(0, 16, 10, 16);
    }
    return UIEdgeInsetsMake(0, 0, 10, 0);
//    else {
//        return UIEdgeInsetsMake(0, 0, 10, 0);
//    }
}

//设置header尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeMake(SCREEN_WIDTH, KFit_W(220));
    }
    return CGSizeMake(SCREEN_WIDTH, 65);
}

//设置footer尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section == 0) {
        if (self.dataSource.FIRSTSCENE.count > 8) {
            return CGSizeMake(SCREEN_WIDTH, 40);
        }
        return CGSizeZero;
    }
    return CGSizeZero;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    //解决滚动条遮挡问题
    view.layer.zPosition = 0.0;
}


//设置头部
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *view = [UICollectionReusableView new];
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        if (indexPath.section == 0) {
            HomePageBannerView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:section_Header_banner forIndexPath:indexPath];
            header.bannerArray = self.dataSource.BANNER;
            view = header;
        } else {
//            NSArray *titleArr = @[@"热门场景",@"设计师榜",@"砍价活动",@"热门商品"];
              NSArray *titleArr = @[@"热门场景",@"热门商品"];
              HomeSectionHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:section_Header forIndexPath:indexPath];
              header.title = titleArr[indexPath.section - 1];
              header.showMoreBtn = NO;
              view = header;
        }
    } else if ([kind isEqualToString:UICollectionElementKindSectionFooter] && indexPath.section == 0) {
        MoreFooterView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:section_Footer forIndexPath:indexPath];
        footer.model = self.dataSource;
        DDWeakSelf;
        footer.pullBlock = ^{
//            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
//            [UIView performWithoutAnimation:^{
//            [weakself.collectionView reloadSections:indexSet];
//              }];
            [weakself.collectionView reloadData];
        };
        view = footer;
    }
    return view;
}

//点击cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        SceneDetailsVC *vc= [[SceneDetailsVC alloc] init];
        SceneModel *model = self.dataSource.FIRSTSCENE[indexPath.row];
        vc.sceneId = [model.sceneId intValue];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.section == 1) {
        SceneDetailsVC *vc= [[SceneDetailsVC alloc] init];
        SceneModel *model = self.dataSource.SCENE[indexPath.row];
        vc.sceneId = [model.sceneId intValue];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.section == 2) {
        GoodsDetailsVC *vc= [[GoodsDetailsVC alloc] init];
        GoodsModel *model = self.dataSource.GOODS[indexPath.row];
        vc.goodsID = model.goodsId;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//数据源
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        SceneIconCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:iconCVID forIndexPath:indexPath];
        cell.model = self.dataSource.FIRSTSCENE[indexPath.row];
        return cell;
    }
    else if (indexPath.section == 1) {
        HomeSceneCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:sceneCVID forIndexPath:indexPath];
        cell.model = self.dataSource.SCENE[indexPath.row];
        return cell;
    }
//    else if (indexPath.section == 2) {
//        HomeDesignerListCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:designerCVID forIndexPath:indexPath];
//        DDWeakSelf;
//        cell.clickBlock = ^(NSString * _Nonnull designerId) {
//            DesignerMainPageVC *vc = [[DesignerMainPageVC alloc] init];
//            vc.designerId = designerId;
//            [weakself.navigationController pushViewController:vc animated:YES];
//        };
//        cell.designerArr = self.dataSource.DESIGNER;
//        return cell;
//    }
    else if (indexPath.section == 2) {
        GoodsCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:goodsCVID forIndexPath:indexPath];
        cell.model = self.dataSource.GOODS[indexPath.row];
        return cell;
    }
    else {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"test" forIndexPath:indexPath];
        return cell;
    }
    return nil;
}

//设置分区不同的背景色
- (UIColor *)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout backgroundColorForSection:(NSInteger)section
{
    return [@[UIColor.whiteColor,
              _collectionView.backgroundColor,
//              _collectionView.backgroundColor,
//              _collectionView.backgroundColor,
              UIColor.whiteColor
              ] objectAtIndex:section];
}

//修改statesBar 颜色
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;  //白色，默认的值是黑色的
}
@end
