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
#import "HotGoodsCVCell.h"
#import "ColorfulFlowLayout.h"
#import "AllClassifyVC.h"
#import "SearchAllKindsVC.h"
#import "GoodsDetailsVC.h"


static NSString *section_One = @"sceneCell";
static NSString *section_Two = @"HomeDesignerListCVCell";
static NSString *section_Four = @"HotGoodsCVCell";
static NSString *section_Header = @"section_Header";
@interface HomePageVC ()<UICollectionViewDelegate, UICollectionViewDataSource, ColorfulDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
//数据源
@property (nonatomic, strong) HomePageModel *dataSource;
@end

@implementation HomePageVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"首页";
    [self vhl_setNavBarTitleColor:UIColor.whiteColor];
    [self vhl_setNavBarBackgroundColor:HEXColor(@"#333434", 1)];
    
    [self setNavBar];
    [self.view addSubview:self.collectionView];
    [self requestData];
    
    
    
//    CGRect statusRect1 = UIApplication.sharedApplication.statusBarFrame;
//
//    UITabBarController *tab = (UITabBarController *)UIApplication.sharedApplication.keyWindow.rootViewController;
//    UINavigationController *nav = tab.viewControllers[0];
//    CGRect navRect1 = nav.navigationBar.frame;
}

- (void)setNavBar {
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
    [searchBtn setTitle:@"搜索商品、场景、店铺、设计师、素材" forState:UIControlStateNormal];
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
    
    self.navigationItem.titleView = titleView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        ColorfulFlowLayout *layout = [[ColorfulFlowLayout alloc] init];
        CGRect rect = SCREEN_BOUNDS;
        _collectionView = [[UICollectionView alloc]initWithFrame:rect collectionViewLayout:layout];
        _collectionView.backgroundColor = HEXColor(@"#F6F6F6", 1);
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } 
//        [_collectionView addSubview:[self addHeaderView]];
        //设置滚动范围偏移200
        //        _collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(NAV_HEIGHT + 106 + 35, 0, 0, 0);
        //设置内容范围偏移200
        _collectionView.contentInset = UIEdgeInsetsMake(NAV_HEIGHT, 0, TABBAR_HEIGHT, 0);
        [_collectionView registerClass:[HomeSceneCVCell class] forCellWithReuseIdentifier:section_One];
        [_collectionView registerClass:[HomeDesignerListCVCell class] forCellWithReuseIdentifier:section_Two];
        
        [_collectionView registerClass:[HotGoodsCVCell class] forCellWithReuseIdentifier:section_Four];
        
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"test"];
        [_collectionView registerClass:[HomeSectionHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:section_Header];
    }

    return _collectionView;
}




#pragma mark 请求数据
- (void)requestData {
    [NetTool getRequest:URLGet_Index_Data Params:nil Success:^(id  _Nonnull json) {
//        NSLog(@"----   %@",json);
        self.dataSource = [HomePageModel mj_objectWithKeyValues:json];
        self.dataSource.SCENE = [SceneModel mj_objectArrayWithKeyValuesArray:self.dataSource.SCENE];
        self.dataSource.DESIGNER = [DesignerModel mj_objectArrayWithKeyValuesArray:self.dataSource.DESIGNER];
        self.dataSource.GOODS = [GoodsModel mj_objectArrayWithKeyValuesArray:self.dataSource.GOODS];
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
    [self.navigationController pushViewController:vc animated:YES];
}



#pragma mark - collectionView delegate
/** 总共多少组*/
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 4;
}

/** 每组几个cell*/
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return self.dataSource.SCENE.count;
    } else if (section == 1) {
        return 1;
    } else if (section == 3) {
        return self.dataSource.GOODS.count;
    } else {
        return 2;
    }
    
}

//cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return CGSizeMake(SCREEN_WIDTH , KFit_W(200) + 50);
    } else if (indexPath.section == 1) {
        return CGSizeMake(SCREEN_WIDTH , 170);
    } else if (indexPath.section == 3) {
        CGFloat imageWidth = (SCREEN_WIDTH - 16 * 2 - 10) / 2;
        return CGSizeMake(imageWidth , imageWidth + 96);
    } else {
        return CGSizeMake(60 , 60);
    }
}

//cell行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (section == 3) {
        return 10;
    } else {
        return 0;
    }
}

//cell列间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (section == 3) {
        return 10;
    } else {
        return 0;
    }
}

//section四周的边距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 3) {
        return UIEdgeInsetsMake(0, 16, 10, 16);
    } else {
        return UIEdgeInsetsMake(0, 0, 10, 0);
    }
}

//设置header尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeMake(SCREEN_WIDTH, 65);
}

- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    //解决滚动条遮挡问题
    view.layer.zPosition = 0.0;
}


//设置头部
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        NSArray *titleArr = @[@"热门场景",@"设计师榜",@"砍价活动",@"热门商品"];
        HomeSectionHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:section_Header forIndexPath:indexPath];
        header.title = titleArr[indexPath.section];
        if (indexPath.section == 0) {
            header.showMoreBtn = NO;
        } else {
            
        }
        return header;
    }
    return nil;
}

//点击cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 3) {
        GoodsDetailsVC *vc= [[GoodsDetailsVC alloc] init];
        GoodsModel *model = self.dataSource.GOODS[indexPath.row];
        vc.goodsID = model.goodsId;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//数据源
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        HomeSceneCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:section_One forIndexPath:indexPath];
        cell.model = self.dataSource.SCENE[indexPath.row];
        return cell;
    } else if (indexPath.section == 1) {
        HomeDesignerListCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:section_Two forIndexPath:indexPath];
        cell.designerArr = self.dataSource.DESIGNER;
        return cell;
    } else if (indexPath.section == 3) {
        HotGoodsCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:section_Four forIndexPath:indexPath];
        cell.model = self.dataSource.GOODS[indexPath.row];
        return cell;
    } else {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"test" forIndexPath:indexPath];
        return cell;
    }
    return nil;
}

//设置分区不同的背景色
- (UIColor *)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout backgroundColorForSection:(NSInteger)section
{
    return [@[_collectionView.backgroundColor,
              _collectionView.backgroundColor,
              _collectionView.backgroundColor,
              UIColor.whiteColor
              ] objectAtIndex:section];
}

//修改statesBar 颜色
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;  //白色，默认的值是黑色的
}
@end
