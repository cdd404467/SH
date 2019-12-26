//
//  DesignerMaterialListView.m
//  SH
//
//  Created by i7colors on 2019/11/28.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "DesignerMaterialListView.h"
#import "MaterialCVCell.h"
#import "MaterialDetailsVC.h"
#import "MaterialModel.h"
#import <UIScrollView+EmptyDataSet.h>

static NSString *materialCVID = @"MaterialCVCell";
@interface DesignerMaterialListView()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);

@end

@implementation DesignerMaterialListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGRect rect = CGRectMake(0, 0, frame.size.width, frame.size.height);
        _collectionView = [[UICollectionView alloc]initWithFrame:rect collectionViewLayout:layout];
        _collectionView.backgroundColor = HEXColor(@"#F6F6F6", 1);
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.emptyDataSetSource = self;
        _collectionView.emptyDataSetDelegate = self;
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [_collectionView registerClass:[MaterialCVCell class] forCellWithReuseIdentifier:materialCVID];
        [self addSubview:_collectionView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.collectionView.frame = self.bounds;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"empty_works"];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"暂无素材";
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

#pragma mark - collectionView delegate
/** 每组几个cell*/
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

//cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(SCREEN_WIDTH , 130);
}

//cell行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {

    return 0;
}

//cell列间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {

    return 0;
}

//section四周的边距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MaterialDetailsVC *vc = [[MaterialDetailsVC alloc] init];
    MaterialModel *model = self.dataSource[indexPath.row];
    vc.materialId = model.materialId;
    [self.nav pushViewController:vc animated:YES];
}

//数据源
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MaterialCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:materialCVID forIndexPath:indexPath];
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
