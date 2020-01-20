//
//  GoodsListView.m
//  SH
//
//  Created by i7colors on 2020/1/14.
//  Copyright © 2020 surhoo. All rights reserved.
//

#import "GoodsListView.h"
#import "SuspendFlowLayout.h"
#import "GoodsDetailsVC.h"
#import "ScreenClassView.h"
#import "GoodsCVCell.h"
#import "GoodsModel.h"
#import "NetTool.h"

static NSString *goodsCVID = @"GoodsCVCell";
static NSString *headerID = @"ScreenClassView";
@interface GoodsListView()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
@end

@implementation GoodsListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        SuspendFlowLayout *layout = [[SuspendFlowLayout alloc] init];
        CGRect rect = CGRectMake(0, 0, frame.size.width, frame.size.height);
        _collectionView = [[UICollectionView alloc]initWithFrame:rect collectionViewLayout:layout];
        _collectionView.backgroundColor = HEXColor(@"#F6F6F6", 1);
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [_collectionView registerClass:[GoodsCVCell class] forCellWithReuseIdentifier:goodsCVID];
        
        [_collectionView registerClass:[ScreenClassView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerID];
        [self addSubview:_collectionView];
    }
    return self;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSource;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.collectionView.frame = self.bounds;
}


- (void)requestGoodsListWithtype:(NSInteger)type {
    NSString *urlString = [NSString stringWithFormat:URLGet_ShopHomePage_GoodsList,_classifyID,(int)type];
    [NetTool getRequest:urlString Params:nil Success:^(id _Nonnull json) {
        NSLog(@"json----   %@",json);
        NSArray *tempArr = [GoodsModel mj_objectArrayWithKeyValuesArray:json[@"list"]];
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:tempArr];
        [self.collectionView reloadData];
    } Failure:^(NSError * _Nonnull error) {
        
    }];
}



#pragma mark - collectionView delegate
/** 每组几个cell*/
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

//cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat imageWidth = (SCREEN_WIDTH - 16 * 2 - 10) / 2;
    return CGSizeMake(imageWidth , imageWidth + 96);
}

//cell行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

//cell列间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

//section四周的边距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 16, 10, 16);
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
    GoodsDetailsVC *vc = [[GoodsDetailsVC alloc] init];
    GoodsModel *model = self.dataSource[indexPath.row];
    vc.goodsID = model.goodsId;
    [self.nav pushViewController:vc animated:YES];
}


//设置头部
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *view = [UICollectionReusableView new];
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        ScreenClassView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerID forIndexPath:indexPath];
        DDWeakSelf;
        header.btnClickBlock = ^(NSInteger type) {
            [weakself requestGoodsListWithtype:type];
        };
        view = header;
    }
    return view;
}

//数据源
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GoodsCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:goodsCVID forIndexPath:indexPath];
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.scrollCallback ?: self.scrollCallback(scrollView);
}


#pragma mark - JXPagingViewListViewDelegate

- (UIView *)listView {
    return self;
}

- (UIScrollView *)listScrollView {
    return self.collectionView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

- (void)listDidAppear {
//    NSLog(@"listDidAppear");
}

- (void)listDidDisappear {
//    NSLog(@"listDidDisappear");
}
@end