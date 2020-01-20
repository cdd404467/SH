//
//  HomePageBannerView.m
//  SH
//
//  Created by i7colors on 2019/12/18.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "HomePageBannerView.h"
#import "ZKCycleScrollView.h"
#import "BannerImageCell.h"
#import "HomePageModel.h"
#import "SH-Swift.h"

static NSString *bannerID = @"ImageCell";
@interface HomePageBannerView()<ZKCycleScrollViewDelegate, ZKCycleScrollViewDataSource>
@property (nonatomic, strong) ZKCycleScrollView *bannerView;
@property (nonatomic, strong) JXPageControlJump *pageControl;
@property (nonatomic, strong) NSMutableArray *imageUrlArray;
@end

@implementation HomePageBannerView

- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
        self.backgroundColor = UIColor.whiteColor;
        [self setupUI];
    }
    
    return self;
}

- (NSMutableArray *)imageUrlArray {
    if (!_imageUrlArray) {
        _imageUrlArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _imageUrlArray;
}


- (void)setupUI {
    UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"banner_Bg"]];
    bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, KFit_W(92));
    [self addSubview:bgView];
    
    _bannerView = [[ZKCycleScrollView alloc] init];
    _bannerView.frame = CGRectMake(10, 10, SCREEN_WIDTH - 20, KFit_W(210));
    _bannerView.delegate = self;
    _bannerView.dataSource = self;
    _bannerView.hidesPageControl = YES;
    [_bannerView registerCellClass:[BannerImageCell class] forCellWithReuseIdentifier:bannerID];
    [self addSubview:_bannerView];
    
    _pageControl = [[JXPageControlJump alloc] init];
    _pageControl.inactiveColor = [UIColor.whiteColor colorWithAlphaComponent:0.4];
    _pageControl.columnSpacing = 7;
    _pageControl.inactiveSize = CGSizeMake(8, 3);
    _pageControl.activeSize = CGSizeMake(8, 3);
    
    _pageControl.activeColor = HEXColor(@"#FF5100", 1);
    [_bannerView addSubview:_pageControl];
    [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(30);
    }];
}

#pragma mark -- ZKCycleScrollView DataSource
- (NSInteger)numberOfItemsInCycleScrollView:(ZKCycleScrollView *)cycleScrollView {
    return self.imageUrlArray.count;
}

- (__kindof ZKCycleScrollViewCell *)cycleScrollView:(ZKCycleScrollView *)cycleScrollView cellForItemAtIndex:(NSInteger)index {
    BannerImageCell *cell = [cycleScrollView dequeueReusableCellWithReuseIdentifier:bannerID forIndex:index];
    cell.imageURL = self.imageUrlArray[index];
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
    for (BannerModel *model in bannerArray) {
        [self.imageUrlArray addObject:model.banner];
    }
    [_bannerView reloadData];
}


@end
