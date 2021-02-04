//
//  SearchResultVC.m
//  SH
//
//  Created by i7colors on 2019/9/18.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "SearchResultVC.h"
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
#import "SelectLabView.h"

#import "GoodsDetailsVC.h"
#import "MaterialDetailsVC.h"
#import "DesignerMainPageVC.h"
#import "ShopHomePageVC.h"
#import "SceneDetailsVC.h"
#import <UIScrollView+EmptyDataSet.h>
#import "ScreenClassView.h"
#import "UIView+Border.h"

static NSString *sceneCVID = @"sceneCell";
static NSString *materialCVID = @"MaterialCVCell";
static NSString *shopCVID = @"ShopCVCell";
static NSString *goodsCVID = @"GoodsCVCell";
static NSString *designerCVID = @"designerCVCell";
@interface SearchResultVC ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, strong) SearchView *searchView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *classifyDataSource;
@property (nonatomic, copy) NSString *labsID;
@property (nonatomic, assign) int goodsSortType;
@end

@implementation SearchResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.labsID = @"";
    self.goodsSortType = 1;
    [self setupUI];
    [self.view addSubview:self.collectionView];
    [self setPageType];
    [self requestData];
}

- (void)setPageType {
    if (_type == 1) {
        self.navBar.title = @"商品列表";
        [self addSelectView];
        self.collectionView.top = self.collectionView.top + 49;
        self.collectionView.height = self.collectionView.height - 49;
    } else if (_type == 2) {
        self.navBar.title = @"场景列表";
    } else if (_type == 3) {
        [self requestClassify];
        self.navBar.title = @"店铺列表";
        [self.navBar.rightBtn setImage:[UIImage imageNamed:@"menu_select"] forState:UIControlStateNormal];
        [self.navBar.rightBtn addTarget:self action:@selector(selectLabs) forControlEvents:UIControlEventTouchUpInside];
    } else if (_type == 4) {
        [self requestClassify];
        self.navBar.title = @"设计师列表";
        [self.navBar.rightBtn setImage:[UIImage imageNamed:@"menu_select"] forState:UIControlStateNormal];
        [self.navBar.rightBtn addTarget:self action:@selector(selectLabs) forControlEvents:UIControlEventTouchUpInside];
    } else if (_type == 5) {
        self.navBar.title = @"素材列表";
    }
}

- (void)selectLabs {
    SelectLabView *view = [[SelectLabView alloc] init];
    view.dataSource = self.classifyDataSource;
    DDWeakSelf;
    view.completeBlock = ^(NSString * _Nonnull labsID) {
        weakself.labsID = labsID;
        [weakself requestData];
    };
    [view show];
}

- (void)setupUI {
    SearchView *searchView = [[SearchView alloc] init];
    searchView.top = NAV_HEIGHT;
    searchView.searchTF.placeholder = self.title;
    searchView.searchTF.text = _keyWords;
    DDWeakSelf;
    searchView.searchBlock = ^{
        [weakself.searchView.searchTF resignFirstResponder];
        [weakself requestData];
    };
    searchView.cancelBlock = ^{
        [weakself.navigationController popToRootViewControllerAnimated:NO];
    };
    [self.view addSubview:searchView];
    _searchView = searchView;
}

//如果是商品结果页面，需要添加
- (void)addSelectView {
    ScreenClassView *topView = [[ScreenClassView alloc] init];
    topView.frame = CGRectMake(0, self.searchView.bottom, SCREEN_WIDTH, 49);
    [topView addBorder:HEXColor(@"#F6F6F6", 1) width:0.7f direction:BorderDirectionBottom | BorderDirectionTop];
    DDWeakSelf;
    topView.btnClickBlock = ^(NSInteger type) {
        weakself.goodsSortType = (int)type;
        [weakself requestData];
    };
    [self.view addSubview:topView];
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
        if (_type == 4) {
            layout.estimatedItemSize = CGSizeMake(SCREEN_WIDTH - 20, 215);
        }
        CGRect rect = CGRectMake(0, self.searchView.bottom, SCREEN_WIDTH, SCREEN_HEIGHT - self.searchView.bottom);
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
        [_collectionView registerClass:[HomeSceneCVCell class] forCellWithReuseIdentifier:sceneCVID];
        [_collectionView registerClass:[MaterialCVCell class] forCellWithReuseIdentifier:materialCVID];
        [_collectionView registerClass:[ShopCVCell class] forCellWithReuseIdentifier:shopCVID];
        [_collectionView registerClass:[GoodsCVCell class] forCellWithReuseIdentifier:goodsCVID];
        [_collectionView registerClass:[DesignerCVCell class] forCellWithReuseIdentifier:designerCVID];
    }
    
    return _collectionView;
}

- (void)requestData {
    NSString *keyWord = _searchView.searchTF.text;
//    NSString *keyWord = @"";
    NSString *urlString = [NSString stringWithFormat:URLGet_Index_SearchAppoint,(int)_type,keyWord,self.goodsSortType,_labsID,PageCount,self.pageNumber];
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [NetTool getRequest:urlString Params:nil Success:^(id _Nonnull json) {
//        NSLog(@"----   %@",json);
        NSArray *tempArr = [self chooseSearchType:json];
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:tempArr];
        [self.collectionView reloadData];
        [self.collectionView  scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    } Failure:^(NSError * _Nonnull error) {
        
    }];
}

//设计师的素材分类
- (void)requestClassify {
    NSString *urlString = [NSString string];
    if (_type == 3) {
        urlString = URLGet_Shop_Labs;
    } else if (_type == 4) {
        urlString = URLGet_Material_Labs;
    }
    
    [NetTool getRequest:urlString Params:nil Success:^(id  _Nonnull json) {
//        NSLog(@"----   %@",json);
        NSArray *tempArr = json;
        self.classifyDataSource = [LabelSelectModel mj_objectArrayWithKeyValuesArray:tempArr];
        self.navBar.rightBtn.hidden = NO;
    } Failure:^(NSError * _Nonnull error) {
        
    }];
}

- (NSArray *)chooseSearchType:(id)json {
    NSArray *tempArr = json[@"list"];
    if (_type == 1) {
        tempArr = [GoodsModel mj_objectArrayWithKeyValuesArray:tempArr];
    }
    else if (_type == 2) {
        tempArr = [SceneModel mj_objectArrayWithKeyValuesArray:tempArr];
    }
    else if (_type == 3) {
        tempArr = [ShopModel mj_objectArrayWithKeyValuesArray:tempArr];
    }
    else if (_type == 4) {
        tempArr = [DesignerModel mj_objectArrayWithKeyValuesArray:tempArr];
    }
    else if (_type == 5) {
        tempArr = [MaterialModel mj_objectArrayWithKeyValuesArray:tempArr];
        for (MaterialModel *model in tempArr) {
            model.labelInfoList = [LabelModel mj_objectArrayWithKeyValuesArray:model.labelInfoList];
        }
    }
    return tempArr;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"empty_search"];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"抱歉,没有找到相关内容";
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName:HEXColor(@"#999999", 1)
                                 };
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return UIColor.whiteColor;
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -100;
}

//1 商品 2 场景 3 店铺 4 设计师 5 素材
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
        return CGSizeMake(SCREEN_WIDTH , KFit_W(200) + 50);
    }
    else if (_type == 3) {
        return CGSizeMake(SCREEN_WIDTH - 20 , 130);
    }
    else if (_type == 4) {
        return CGSizeMake(SCREEN_WIDTH - 20 , 215);
    }
    else if (_type == 5 ) {
        return CGSizeMake(SCREEN_WIDTH , 130);
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
        SceneDetailsVC *vc = [[SceneDetailsVC alloc] init];
        SceneModel *model = self.dataSource[indexPath.row];
        vc.sceneId = model.sceneId.intValue;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (_type == 3) {
        ShopHomePageVC *vc = [[ShopHomePageVC alloc] init];
        ShopModel *model = self.dataSource[indexPath.row];
        vc.shopID = model.shopId;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (_type == 4) {
        
    } else if (_type == 5) {
        MaterialDetailsVC *vc = [[MaterialDetailsVC alloc] init];
        vc.materialId = [self.dataSource[indexPath.row] materialId];
        [self.navigationController pushViewController:vc animated:YES];
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
        HomeSceneCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:sceneCVID forIndexPath:indexPath];
        cell.model = self.dataSource[indexPath.row];
        return cell;
    }
    else if (_type == 3) {
        ShopCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:shopCVID forIndexPath:indexPath];
        cell.model = self.dataSource[indexPath.row];
        return cell;
    }
    else if (_type == 4) {
        DesignerCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:designerCVID forIndexPath:indexPath];
        cell.model = self.dataSource[indexPath.row];
        DDWeakSelf;
        cell.clickBlock = ^{
            if (Get_User_Token) {
                DesignerMainPageVC *vc = [[DesignerMainPageVC alloc] init];
                DesignerModel *model = self.dataSource[indexPath.row];
                vc.designerId = model.designerId;
                [weakself.navigationController pushViewController:vc animated:YES];
            } else {
                [weakself jumpToLoginWithComplete:nil];
            }
        };
        return cell;
    }
    else if (_type == 5) {
        MaterialCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:materialCVID forIndexPath:indexPath];
        cell.model = self.dataSource[indexPath.row];
        return cell;
    }
    return [[UICollectionViewCell alloc] init];
}

@end
