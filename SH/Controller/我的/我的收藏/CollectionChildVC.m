//
//  CollectionChildVC.m
//  SH
//
//  Created by i7colors on 2019/12/29.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "CollectionChildVC.h"
#import "MaterialCVCell.h"
#import "ShopCVCell.h"
#import "GoodsCVCell.h"
#import "DesignerCVCell.h"
#import <UIScrollView+EmptyDataSet.h>
#import "HomePageModel.h"
#import "ShopModel.h"
#import "MaterialModel.h"
#import "NetTool.h"
#import "GoodsDetailsVC.h"
#import "MaterialDetailsVC.h"

static NSString *materialCVID = @"MaterialCVCell";
static NSString *shopCVID = @"ShopCVCell";
static NSString *goodsCVID = @"GoodsCVCell";
static NSString *designerCVID = @"designerCVCell";

@interface CollectionChildVC ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation CollectionChildVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBar.leftBtn.hidden = YES;
    self.view.height = SCREEN_HEIGHT - NAV_HEIGHT - 40;
    [self.view addSubview:self.collectionView];
    [self requestData];
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSource;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        if (_type == 3) {
            layout.estimatedItemSize = CGSizeMake(SCREEN_WIDTH - 20, 215);
        }
        CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - 40);
        _collectionView = [[UICollectionView alloc]initWithFrame:rect collectionViewLayout:layout];
        _collectionView.backgroundColor = HEXColor(@"#F6F6F6", 1);
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.emptyDataSetSource = self;
        _collectionView.emptyDataSetDelegate = self;
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, Bottom_Height_Dif + 30, 0);
        [_collectionView registerClass:[MaterialCVCell class] forCellWithReuseIdentifier:materialCVID];
        [_collectionView registerClass:[ShopCVCell class] forCellWithReuseIdentifier:shopCVID];
        [_collectionView registerClass:[GoodsCVCell class] forCellWithReuseIdentifier:goodsCVID];
        [_collectionView registerClass:[DesignerCVCell class] forCellWithReuseIdentifier:designerCVID];
    }
    
    return _collectionView;
}

- (void)requestData {
    NSString *urlString = [NSString stringWithFormat:URLGet_User_CollectList,@(_type).stringValue,PageCount,self.pageNumber];
    [NetTool getRequest:urlString Params:nil Success:^(id  _Nonnull json) {
//            NSLog(@"main ----   %@",json);
        NSArray *tempArr = [self chooseSearchType:json];
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:tempArr];
        [self.collectionView reloadData];
    } Failure:^(NSError * _Nonnull error) {
        
    }];
}

- (NSArray *)chooseSearchType:(id)json {
    NSArray *tempArr = json[@"list"];
    if (_type == 1) {
        tempArr = [GoodsModel mj_objectArrayWithKeyValuesArray:tempArr];
    }
    else if (_type == 2) {
        tempArr = [MaterialModel mj_objectArrayWithKeyValuesArray:tempArr];
        for (MaterialModel *model in tempArr) {
            model.labelInfoList = [LabelModel mj_objectArrayWithKeyValuesArray:model.labelInfoList];
        }
    }
    else if (_type == 3) {
        tempArr = [DesignerModel mj_objectArrayWithKeyValuesArray:tempArr];
    }
    else if (_type == 4) {
        tempArr = [ShopModel mj_objectArrayWithKeyValuesArray:tempArr];
    }
    return tempArr;
}

//- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
//    return [UIImage imageNamed:@"empty_search"];
//}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"暂无收藏内容";
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName:HEXColor(@"#999999", 1)
                                 };
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return UIColor.whiteColor;
}

//- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
//    return -100;
//}

//1 商品 2 素材 3 设计师 4 店铺
#pragma mark - collectionView delegate
/** 每组几个cell*/
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

//cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_type == 1) {
        CGFloat imageWidth = (SCREEN_WIDTH - 16 * 2 - 10) / 2;
        return CGSizeMake(imageWidth , imageWidth + 96);
    }
    else if (_type == 2) {
        return CGSizeMake(SCREEN_WIDTH , 130);
    }
    else if (_type == 3) {
        return CGSizeMake(SCREEN_WIDTH - 20 , 215);
    }
    else if (_type == 4) {
        return CGSizeMake(SCREEN_WIDTH - 20 , 130);
    }
    return CGSizeZero;
}

//cell行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (_type == 1) {
        return 10;
    }
    else if (_type == 3 || _type == 4) {
        return 8;
    }
    return 0;
}

//cell列间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (_type == 1) {
        return 10;
    }
    return 0;
}

//section四周的边距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (_type == 1) {
        return UIEdgeInsetsMake(8, 16, 10, 16);
    }
    else if (_type == 3 || _type == 4) {
        return UIEdgeInsetsMake(10, 10, 0, 10);
    }
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_type == 1) {
        GoodsDetailsVC *vc = [[GoodsDetailsVC alloc] init];
        GoodsModel *model = self.dataSource[indexPath.row];
        vc.goodsID = model.goodsId;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (_type == 2) {
       MaterialDetailsVC *vc = [[MaterialDetailsVC alloc] init];
       vc.materialId = [self.dataSource[indexPath.row] materialId];
       [self.navigationController pushViewController:vc animated:YES];
    } else if (_type == 3) {

    } else if (_type == 4) {

    }
}

//数据源
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_type == 1) {
        GoodsCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:goodsCVID forIndexPath:indexPath];
        cell.model = self.dataSource[indexPath.row];
        return cell;
    }
    else if (_type == 2) {
        MaterialCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:materialCVID forIndexPath:indexPath];
        cell.model = self.dataSource[indexPath.row];
        return cell;
    }
    else if (_type == 3) {
        DesignerCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:designerCVID forIndexPath:indexPath];
        cell.model = self.dataSource[indexPath.row];
//        DDWeakSelf;
//        cell.clickBlock = ^{
//            DesignerMainPageVC *vc = [[DesignerMainPageVC alloc] init];
//            DesignerModel *model = self.dataSource[indexPath.row];
//            vc.designerId = model.designerId;
//            [weakself.navigationController pushViewController:vc animated:YES];
//        };
        return cell;
    }
    else if (_type == 4) {
        ShopCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:shopCVID forIndexPath:indexPath];
        cell.model = self.dataSource[indexPath.row];
        return cell;
    }
    return [[UICollectionViewCell alloc] init];
}
@end
