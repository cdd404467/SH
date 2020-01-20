//
//  ShopHeaderView.m
//  SH
//
//  Created by i7colors on 2020/1/14.
//  Copyright © 2020 surhoo. All rights reserved.
//

#import "ShopHeaderView.h"
#import "ZKCycleScrollView.h"
#import "BannerImageCell.h"
#import "SH-Swift.h"

static NSString *bannerID = @"ImageCell";
@interface ShopHeaderView()<ZKCycleScrollViewDelegate, ZKCycleScrollViewDataSource>
@property (nonatomic, strong) ZKCycleScrollView *bannerView;
@property (nonatomic, strong) JXPageControlJump *pageControl;
@end

@implementation ShopHeaderView

- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.frame = CGRectMake(0, -KFit_W(220), SCREEN_WIDTH, 0);
        self.backgroundColor = UIColor.whiteColor;
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = HEXColor(@"#333434", 1);
    bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, KFit_W(140));
    [self addSubview:bgView];
    
    CGFloat width = KFit_W(26);
    _shopLogo = [[UIImageView alloc] init];
    _shopLogo.frame = CGRectMake(13, (50 - width) / 2, width, width);
    _shopLogo.layer.cornerRadius = width / 2;
    _shopLogo.clipsToBounds = YES;
    [bgView addSubview:_shopLogo];
    
    _shopNameLab = [[UILabel alloc] init];
    _shopNameLab.textColor = UIColor.whiteColor;
    _shopNameLab.numberOfLines = 2;
    _shopNameLab.font = [UIFont systemFontOfSize:14];
    [bgView addSubview:_shopNameLab];
    [_shopNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.shopLogo.mas_right).offset(8);
        make.right.mas_equalTo(-13);
        make.height.mas_equalTo(KFit_W(50));
        make.centerY.mas_equalTo(self.shopLogo);
    }];
    
    _bannerView = [[ZKCycleScrollView alloc] init];
    _bannerView.frame = CGRectMake(10, KFit_W(50), SCREEN_WIDTH - 20, KFit_W(210));
    _bannerView.delegate = self;
    _bannerView.dataSource = self;
    _bannerView.hidesPageControl = YES;
    [_bannerView registerCellClass:[BannerImageCell class] forCellWithReuseIdentifier:bannerID];
    [self addSubview:_bannerView];
    
    _pageControl.activeColor = HEXColor(@"#FF5100", 1);
    [_bannerView addSubview:_pageControl];
    [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(30);
    }];
}



#pragma mark -- ZKCycleScrollView DataSource
- (NSInteger)numberOfItemsInCycleScrollView:(ZKCycleScrollView *)cycleScrollView {
    return self.bannerArray.count;
}

- (__kindof ZKCycleScrollViewCell *)cycleScrollView:(ZKCycleScrollView *)cycleScrollView cellForItemAtIndex:(NSInteger)index {
    BannerImageCell *cell = [cycleScrollView dequeueReusableCellWithReuseIdentifier:bannerID forIndex:index];
    cell.imageURL = self.bannerArray[index];
    return cell;
}

#pragma mark -- ZKCycleScrollView Delegate
- (void)cycleScrollView:(ZKCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    //    NSLog(@"selected index: %zd", index);
}

- (void)cycleScrollViewDidScroll:(ZKCycleScrollView *)cycleScrollView progress:(CGFloat)progress {
    self.pageControl.progress = progress;
}

- (void)cycleScrollView:(ZKCycleScrollView *)cycleScrollView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
//    _pageLab.text = [NSString stringWithFormat:@"%ld/%ld",(long)toIndex + 1,(long)_imageArray.count];
    //    NSLog(@"from %zd to %zd", fromIndex, toIndex);
}

- (void)setBannerArray:(NSArray *)bannerArray {
    _bannerArray = bannerArray;
    _pageControl.numberOfPages = bannerArray.count;
    [_bannerView reloadData];
}

@end
