//
//  ShopArtistListCVCell.m
//  SH
//
//  Created by i7colors on 2020/1/15.
//  Copyright © 2020 surhoo. All rights reserved.
//

#import "ShopArtistListCVCell.h"
#import "ZKCycleScrollView.h"
#import "BannerImageCell.h"
#import "BannerModel.h"

static NSString *bannerID = @"ImageCell";

@interface ShopArtistListCVCell()<ZKCycleScrollViewDelegate, ZKCycleScrollViewDataSource>
@property (nonatomic, strong) ZKCycleScrollView *bannerView;
@end

@implementation ShopArtistListCVCell

- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
        self.backgroundColor = UIColor.whiteColor;
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    _bannerView = [[ZKCycleScrollView alloc] init];
    _bannerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, KFit_W(150));
    _bannerView.delegate = self;
    _bannerView.dataSource = self;
    _bannerView.hidesPageControl = YES;
    _bannerView.itemSpacing = 12.f;
    _bannerView.itemSize = CGSizeMake(SCREEN_WIDTH - KFit_W(80), _bannerView.height);
    [_bannerView registerCellClass:[BannerImageCell class] forCellWithReuseIdentifier:bannerID];
    [self addSubview:_bannerView];
}

- (void)setArtistShopArr:(NSArray<BannerModel *> *)artistShopArr {
    _artistShopArr = artistShopArr;
    [_bannerView reloadData];
}

#pragma mark -- ZKCycleScrollView DataSource
- (NSInteger)numberOfItemsInCycleScrollView:(ZKCycleScrollView *)cycleScrollView {
    return self.artistShopArr.count;
}

- (__kindof ZKCycleScrollViewCell *)cycleScrollView:(ZKCycleScrollView *)cycleScrollView cellForItemAtIndex:(NSInteger)index {
    BannerImageCell *cell = [cycleScrollView dequeueReusableCellWithReuseIdentifier:bannerID forIndex:index];
    cell.imageURL = [NSURL URLWithString:[self.artistShopArr[index] banner]];
    cell.cornerRadius = 5.f;
    return cell;
}

#pragma mark -- ZKCycleScrollView Delegate
- (void)cycleScrollView:(ZKCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    BannerModel *model = self.artistShopArr[index];
    if (self.clickBlock) {
        self.clickBlock(model.shopId);
    }
}

- (void)cycleScrollViewDidScroll:(ZKCycleScrollView *)cycleScrollView progress:(CGFloat)progress {
//    self.pageControl.progress = progress;
}

- (void)cycleScrollView:(ZKCycleScrollView *)cycleScrollView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
//    _pageLab.text = [NSString stringWithFormat:@"%ld/%ld",(long)toIndex + 1,(long)_imageArray.count];
    //    NSLog(@"from %zd to %zd", fromIndex, toIndex);
}

@end
