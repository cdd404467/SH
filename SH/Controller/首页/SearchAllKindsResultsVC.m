//
//  SearchAllKindsResultsVC.m
//  SH
//
//  Created by i7colors on 2019/12/25.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "SearchAllKindsResultsVC.h"
#import "SearchView.h"
#import "NetTool.h"
#import "HomeSceneCVCell.h"
#import "MaterialCVCell.h"
#import "ShopCVCell.h"
#import "GoodsCVCell.h"
#import "DesignerCVCell.h"
#import "HomePageModel.h"
#import "MaterialModel.h"
#import "ShopModel.h"
#import <UIScrollView+EmptyDataSet.h>
#import "SearchModel.h"
#import "SearchResultSecHeader.h"
#import "SearchResultVC.h"
#import "GoodsDetailsVC.h"
#import "SceneDetailsVC.h"
#import "MaterialDetailsVC.h"

static NSString *sceneCVID = @"sceneCell";
static NSString *materialCVID = @"MaterialCVCell";
static NSString *shopCVID = @"ShopCVCell";
static NSString *goodsCVID = @"GoodsCVCell";
static NSString *designerCVID = @"designerCVCell";
static NSString *section_Header = @"SearchResultSecHeader";

@interface SearchAllKindsResultsVC ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, strong) SearchView *searchView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) SearchModel *dataSource;
@end

@implementation SearchAllKindsResultsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBar.title = @"搜索";
    [self setupUI];
    [self.view addSubview:self.collectionView];
    [self requestData];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.estimatedItemSize = CGSizeMake(SCREEN_WIDTH - 20, 215);
        CGRect rect = CGRectMake(0, self.searchView.bottom, SCREEN_WIDTH, SCREEN_HEIGHT - self.searchView.bottom);
        _collectionView = [[UICollectionView alloc]initWithFrame:rect collectionViewLayout:layout];
        _collectionView.backgroundColor = UIColor.whiteColor;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
//        _collectionView.emptyDataSetSource = self;
//        _collectionView.emptyDataSetDelegate = self;
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, Bottom_Height_Dif, 0);
        [_collectionView registerClass:[HomeSceneCVCell class] forCellWithReuseIdentifier:sceneCVID];
        [_collectionView registerClass:[MaterialCVCell class] forCellWithReuseIdentifier:materialCVID];
        [_collectionView registerClass:[ShopCVCell class] forCellWithReuseIdentifier:shopCVID];
        [_collectionView registerClass:[GoodsCVCell class] forCellWithReuseIdentifier:goodsCVID];
        [_collectionView registerClass:[DesignerCVCell class] forCellWithReuseIdentifier:designerCVID];
        [_collectionView registerClass:[SearchResultSecHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:section_Header];
    }
    return _collectionView;
}

- (void)setupUI {
    SearchView *searchView = [[SearchView alloc] init];
    searchView.top = NAV_HEIGHT;
    searchView.searchTF.enablesReturnKeyAutomatically = YES;
    searchView.searchTF.placeholder = self.title;
    searchView.searchTF.text = _keyWords;
    DDWeakSelf;
    searchView.searchBlock = ^{
        [weakself.searchView.searchTF resignFirstResponder];
//        [weakself requestData];
    };
    searchView.cancelBlock = ^{
        [weakself.navigationController popToRootViewControllerAnimated:NO];
    };
    [self.view addSubview:searchView];
    _searchView = searchView;
}

//搜索全部
- (void)requestData {
    NSString *keyWord = _searchView.searchTF.text;
//    NSString *keyWord = @"";
    NSString *urlString = [NSString stringWithFormat:URLGet_Index_SearchAllKinds,keyWord];
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [NetTool getRequest:urlString Params:nil Success:^(id _Nonnull json) {
//        NSLog(@"----   %@",json);
        self.dataSource = [SearchModel mj_objectWithKeyValues:json];
        self.dataSource.DESIGNER = [DesignerModel mj_objectArrayWithKeyValuesArray:self.dataSource.DESIGNER];
        self.dataSource.GOODS = [GoodsModel mj_objectArrayWithKeyValuesArray:self.dataSource.GOODS];
        self.dataSource.MATERIAL = [MaterialModel mj_objectArrayWithKeyValuesArray:self.dataSource.MATERIAL];
        for (MaterialModel *model in self.dataSource.MATERIAL) {
            model.labelInfoList = [LabelModel mj_objectArrayWithKeyValuesArray:model.labelInfoList];
        }
        self.dataSource.SCENE = [SceneModel mj_objectArrayWithKeyValuesArray:self.dataSource.SCENE];
        self.dataSource.SHOP = [ShopModel mj_objectArrayWithKeyValuesArray:self.dataSource.SHOP];
        [self.collectionView reloadData];
        [self.collectionView  scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    } Failure:^(NSError * _Nonnull error) {
        
    }];
}

//1 商品 2 场景 3 店铺 4 设计师 5 素材
#pragma mark - collectionView delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 5;
}

/** 每组几个cell*/
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return self.dataSource.GOODS.count;
    }
    else if (section == 1) {
        return self.dataSource.SCENE.count;
    }
    else if (section == 2) {
        return self.dataSource.SHOP.count;
    }
    else if (section == 3) {
        return self.dataSource.DESIGNER.count;
    }
    else if (section == 4) {
        return self.dataSource.MATERIAL.count;
    }
    return 0;
}

//设置header尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    CGFloat gap = 48.f;
    if (section == 0) {
        if (self.dataSource.GOODS.count > 0) {
            return CGSizeMake(SCREEN_WIDTH, gap);
        }
        return CGSizeZero;
    } else if (section == 1) {
        if (self.dataSource.SCENE.count > 0) {
            return CGSizeMake(SCREEN_WIDTH, gap);
        }
        return CGSizeZero;
    } else if (section == 2) {
        if (self.dataSource.SHOP.count > 0) {
            return CGSizeMake(SCREEN_WIDTH, gap);
        }
        return CGSizeZero;
    } else if (section == 3) {
        if (self.dataSource.DESIGNER.count > 0) {
            return CGSizeMake(SCREEN_WIDTH, gap);
        }
        return CGSizeZero;
    } else if (section == 4) {
        if (self.dataSource.MATERIAL.count > 0) {
            return CGSizeMake(SCREEN_WIDTH, gap);
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
    NSArray *titleArr = @[@"商品",@"场景",@"店铺",@"设计师",@"素材"];
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        SearchResultSecHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:section_Header forIndexPath:indexPath];
        header.title = titleArr[indexPath.section];
        DDWeakSelf;
        SearchResultVC *vc = [[SearchResultVC alloc] init];
        vc.keyWords = self.searchView.searchTF.text;
        vc.type = indexPath.section + 1;
        header.moreBtnClick = ^{
            [weakself.navigationController pushViewController:vc animated:YES];
        };
        view = header;
    }
    return view;
}

//cell行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return 10;
    } else if (section == 2 || section == 3) {
        return 8;
    }
    return 0;
}

//cell列间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return 10;
    }
    return 0;
}

//section四周的边距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return UIEdgeInsetsMake(10, 15, 10, 15);
    } else if (section == 2 || section == 3) {
        UIEdgeInsetsMake(10, 10, 0, 10);
    }
    return UIEdgeInsetsZero;
}

//cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (self.dataSource.GOODS.count > 0) {
            CGFloat imageWidth = (SCREEN_WIDTH - 16 * 2 - 10) / 2;
            return CGSizeMake(imageWidth , imageWidth + 96);
        }
        return CGSizeZero;
    }
    else if (indexPath.section == 1) {
        if (self.dataSource.SCENE.count > 0) {
            return CGSizeMake(SCREEN_WIDTH , KFit_W(200) + 50);
        }
        return CGSizeZero;
    }
    else if (indexPath.section == 2) {
        if (self.dataSource.SHOP.count > 0) {
            return CGSizeMake(SCREEN_WIDTH - 20 , 130);
        }
        return CGSizeZero;
    }
    else if (indexPath.section == 3) {
        if (self.dataSource.DESIGNER.count > 0) {
            return CGSizeMake(SCREEN_WIDTH - 20 , 215);
        }
        return CGSizeZero;
    }
    else if (indexPath.section == 4) {
        if (self.dataSource.MATERIAL.count > 0) {
            return CGSizeMake(SCREEN_WIDTH , 130);
        }
        return CGSizeZero;
    }
    return CGSizeZero;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        GoodsDetailsVC *vc = [[GoodsDetailsVC alloc] init];
        GoodsModel *model = self.dataSource.GOODS[indexPath.row];
        vc.goodsID = model.goodsId;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.section == 1) {
        SceneDetailsVC *vc = [[SceneDetailsVC alloc] init];
        SceneModel *model = self.dataSource.SCENE[indexPath.row];
        vc.sceneId = model.sceneId.intValue;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.section == 2) {
        
    } else if (indexPath.section == 3) {
        
    } else if (indexPath.section == 4) {
        MaterialDetailsVC *vc = [[MaterialDetailsVC alloc] init];
        vc.materialId = [self.dataSource.MATERIAL[indexPath.row] materialId];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//数据源
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        GoodsCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:goodsCVID forIndexPath:indexPath];
        cell.model = self.dataSource.GOODS[indexPath.row];
        return cell;
    }
    else if (indexPath.section == 1) {
        HomeSceneCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:sceneCVID forIndexPath:indexPath];
        cell.model = self.dataSource.SCENE[indexPath.row];
        return cell;
    }
    else if (indexPath.section == 2) {
        ShopCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:shopCVID forIndexPath:indexPath];
        cell.model = self.dataSource.SHOP[indexPath.row];
        return cell;
    }
    else if (indexPath.section == 3) {
        DesignerCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:designerCVID forIndexPath:indexPath];
        cell.model = self.dataSource.DESIGNER[indexPath.row];
//        DDWeakSelf;
//        cell.clickBlock = ^{
//            DesignerMainPageVC *vc = [[DesignerMainPageVC alloc] init];
//            DesignerModel *model = self.dataSource[indexPath.row];
//            vc.designerId = model.designerId;
//            [weakself.navigationController pushViewController:vc animated:YES];
//        };
        return cell;
    }
    else if (indexPath.section == 4) {
        MaterialCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:materialCVID forIndexPath:indexPath];
        cell.model = self.dataSource.MATERIAL[indexPath.row];
        return cell;
    }
    return [[UICollectionViewCell alloc] init];
}

@end
