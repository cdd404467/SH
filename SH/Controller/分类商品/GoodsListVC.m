//
//  GoodsListVC.m
//  SH
//
//  Created by i7colors on 2019/9/10.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "GoodsListVC.h"
#import "GoodsCVCell.h"
#import "NetTool.h"
#import "UIView+Border.h"
#import "GoodsModel.h"
#import "GoodsDetailsVC.h"
#import "ScreenClassView.h"


static NSString *cvID = @"HotGoodsCVCell";

@interface GoodsListVC ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation GoodsListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBar.title = @"商品列表";
    [self setupUI];
    [self requestDataWithType:1];
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
        CGFloat imageWidth = (SCREEN_WIDTH - 16 * 2 - 10) / 2;
        layout.itemSize = CGSizeMake(imageWidth , imageWidth + 96);
        layout.minimumInteritemSpacing = 10;
        layout.minimumLineSpacing = 10;
        layout.sectionInset = UIEdgeInsetsMake(10, 16, 10, 16);
        CGRect rect = CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT);
        _collectionView = [[UICollectionView alloc]initWithFrame:rect collectionViewLayout:layout];
        _collectionView.backgroundColor = UIColor.whiteColor;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _collectionView.contentInset = UIEdgeInsetsMake(49, 0, 0, 0);
        _collectionView.scrollIndicatorInsets = _collectionView.contentInset;
        [_collectionView registerClass:[GoodsCVCell class] forCellWithReuseIdentifier:cvID];
    }
    return _collectionView;
}

- (void)setupUI {
    [self.view addSubview:self.collectionView];
    
    ScreenClassView *topView = [[ScreenClassView alloc] init];
    topView.frame = CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, 49);
    [topView addBorder:HEXColor(@"#F6F6F6", 1) width:0.7f direction:BorderDirectionBottom];
    DDWeakSelf;
    topView.btnClickBlock = ^(NSInteger type) {
        [weakself requestDataWithType:type];
    };
    [self.view addSubview:topView];

}

#pragma mark 请求数据
- (void)requestDataWithType:(NSInteger)type {
    NSString *urlString = [NSString stringWithFormat:URLGet_Goods_ClassifyList,_classifyId,(int)type,PageCount,self.pageNumber];
    [NetTool getRequest:urlString Params:nil Success:^(id  _Nonnull json) {
//                NSLog(@"----   %@",json);
        if (self.pageNumber == 1)
            [self.dataSource removeAllObjects];
        NSArray *tempArr = [GoodsModel mj_objectArrayWithKeyValuesArray:json[@"list"]];
        [self.dataSource addObjectsFromArray:tempArr];
        [self.collectionView reloadData];
        
    } Failure:^(NSError * _Nonnull error) {
//        NSLog(@"----   %@",error);
    }];
}


#pragma mark - collectionView delegate
/** 每组几个cell*/
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    GoodsDetailsVC *vc= [[GoodsDetailsVC alloc] init];
    GoodsModel *model = self.dataSource[indexPath.row];
    vc.goodsID = model.goodsId;
    [self.navigationController pushViewController:vc animated:YES];
}

//数据源
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GoodsCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cvID forIndexPath:indexPath];
    cell.model = self.dataSource[indexPath.row];
    return cell;
}
@end
