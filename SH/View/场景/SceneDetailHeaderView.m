//
//  SceneDetailHeaderView.m
//  SH
//
//  Created by i7colors on 2019/11/20.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "SceneDetailHeaderView.h"
#import "SceneIconCVCell.h"
#import "SceneModel.h"

static NSString *iconCVID = @"SceneIconCVCell";

@interface SceneDetailHeaderView()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation SceneDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HEXColor(@"#F6F6F6", 1);
        _imageView = [[UIImageView alloc] init];
        self.imageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, KFit_W(225));
        [self addSubview:self.imageView];
    }
    return self;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGRect rect = CGRectMake(0, _imageView.bottom, SCREEN_WIDTH, 110);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc]initWithFrame:rect collectionViewLayout:layout];
        _collectionView.backgroundColor = UIColor.whiteColor;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[SceneIconCVCell class] forCellWithReuseIdentifier:iconCVID];
    }
    return _collectionView;
}

- (void)setBannerURL:(NSString *)bannerURL {
    _bannerURL = bannerURL;
    [_imageView sd_setImageWithURL:ImgUrl_SD_OSS(bannerURL, ((int)(SCREEN_WIDTH * 3 / 2))) placeholderImage:PlaceHolder_Banner];
}

- (void)setIconArray:(NSArray *)iconArray {
    _iconArray = iconArray;
    if (iconArray.count > 0) {
        [self addSubview:self.collectionView];
    }
}

#pragma mark - collectionView delegate
/** 每组几个cell*/
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.iconArray.count;
}

//cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(62 , 70);
}

//cell行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 25;
}

//cell列间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

//section四周的边距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 10, 0, 10);
}

//点击
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.clickJumpBlock) {
        SceneModel *model = self.iconArray[indexPath.row];
        self.clickJumpBlock(model.sceneId);
    }
}

//数据源
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SceneIconCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:iconCVID forIndexPath:indexPath];
    cell.model = self.iconArray[indexPath.row];
    return cell;
}

@end
