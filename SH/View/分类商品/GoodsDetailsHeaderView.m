//
//  GoodsDetailsHeaderView.m
//  SH
//
//  Created by i7colors on 2019/9/18.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "GoodsDetailsHeaderView.h"
#import "ZKCycleScrollView.h"
#import "BannerImageCell.h"

static NSString *cvID = @"ImageCell";

@interface GoodsDetailsHeaderView()<ZKCycleScrollViewDelegate, ZKCycleScrollViewDataSource>
@property (nonatomic, strong) ZKCycleScrollView *bannerView;
@property (nonatomic, strong) UILabel *pageLab;
@end

@implementation GoodsDetailsHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.whiteColor;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    _bannerView = [[ZKCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH)];
    _bannerView.delegate = self;
    _bannerView.dataSource = self;
    _bannerView.hidesPageControl = YES;
    _bannerView.autoScroll = NO;
    [_bannerView registerCellClass:[BannerImageCell class] forCellWithReuseIdentifier:cvID];
    [self addSubview:_bannerView];
    
    //页码
    _pageLab = [[UILabel alloc] init];
    _pageLab.textColor = UIColor.whiteColor;
    _pageLab.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    _pageLab.textAlignment = NSTextAlignmentCenter;
    _pageLab.layer.cornerRadius = 11.f;
    _pageLab.clipsToBounds = YES;
    _pageLab.backgroundColor = HEXColor(@"#000000", 0.2);
    [_bannerView addSubview:_pageLab];
    [_pageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(22);
        make.right.bottom.mas_equalTo(-10);
    }];
}

#pragma mark -- ZKCycleScrollView DataSource
- (NSInteger)numberOfItemsInCycleScrollView:(ZKCycleScrollView *)cycleScrollView {
    return 2;
}

- (__kindof ZKCycleScrollViewCell *)cycleScrollView:(ZKCycleScrollView *)cycleScrollView cellForItemAtIndex:(NSInteger)index {
    BannerImageCell *cell = [cycleScrollView dequeueReusableCellWithReuseIdentifier:cvID forIndex:index];
    cell.imageURL = self.imageArray[index];
    return cell;
}

#pragma mark -- ZKCycleScrollView Delegate
- (void)cycleScrollView:(ZKCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
//    NSLog(@"selected index: %zd", index);
}

- (void)cycleScrollViewDidScroll:(ZKCycleScrollView *)cycleScrollView progress:(CGFloat)progress {
    
}

- (void)cycleScrollView:(ZKCycleScrollView *)cycleScrollView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    _pageLab.text = [NSString stringWithFormat:@"%ld/%ld",(long)toIndex + 1,(long)_imageArray.count];
//    NSLog(@"from %zd to %zd", fromIndex, toIndex);
}

- (void)setImageArray:(NSArray *)imageArray {
    _imageArray = imageArray;
    [_bannerView reloadData];
    _pageLab.text = [NSString stringWithFormat:@"1/%ld",(long)imageArray.count];
}

@end
