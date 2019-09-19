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
#import <YYText.h>

static NSString *cvID = @"ImageCell";

@interface GoodsDetailsHeaderView()<ZKCycleScrollViewDelegate, ZKCycleScrollViewDataSource>
@property (nonatomic, strong) ZKCycleScrollView *bannerView;
@property (nonatomic, strong) UILabel *pageLab;
@property (nonatomic, strong) UILabel *goodsNameLab;
@property (nonatomic, strong) YYLabel *priceLab;
@property (nonatomic, strong) UILabel *saleCountLab;
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
    _bannerView = [[ZKCycleScrollView alloc] init];
    _bannerView.delegate = self;
    _bannerView.dataSource = self;
    _bannerView.hidesPageControl = YES;
    _bannerView.autoScroll = NO;
    [_bannerView registerCellClass:[BannerImageCell class] forCellWithReuseIdentifier:cvID];
    [self addSubview:_bannerView];
    [_bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(SCREEN_WIDTH);
    }];
    
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
    
    //商品名字
    _goodsNameLab = [[UILabel alloc] init];
    _goodsNameLab.text = @"商品名称商品名称商品名称称商品名称商品";
    _goodsNameLab.textColor = HEXColor(@"#090203", 1);
    _goodsNameLab.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    [self addSubview:_goodsNameLab];
    [_goodsNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bannerView.mas_bottom).offset(10);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(50);
    }];
    
    //价格
    _priceLab = [[YYLabel alloc] init];
    [self addSubview:_priceLab];
    [_priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.goodsNameLab);
        make.height.mas_equalTo(37);
        make.top.mas_equalTo(self.goodsNameLab.mas_bottom).offset(12);
    }];
    
    //销量
    _saleCountLab = [[UILabel alloc] init];
    _saleCountLab.textColor = HEXColor(@"#9B9B9B", 1);
    _saleCountLab.textAlignment = NSTextAlignmentRight;
    _saleCountLab.font = [UIFont systemFontOfSize:12];
    [self addSubview:_saleCountLab];
    [_saleCountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.goodsNameLab);
        make.bottom.mas_equalTo(self.priceLab);
        make.height.mas_equalTo(20);
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
    
    //price富文本
    NSString *nowPrice = @"¥500  ";
    NSString *marketPrice = @"¥789";
    NSString *price = [NSString stringWithFormat:@"%@%@",nowPrice,marketPrice];
    NSMutableAttributedString *mtext = [[NSMutableAttributedString alloc] initWithString:price];
    [mtext yy_setFont:[UIFont systemFontOfSize:26 weight:UIFontWeightMedium] range:NSMakeRange(0, nowPrice.length)];
    [mtext yy_setColor:HEXColor(@"#FF5100", 1) range:NSMakeRange(0, nowPrice.length)];

    [mtext yy_setFont:[UIFont systemFontOfSize:16 weight:UIFontWeightMedium] range:NSMakeRange(nowPrice.length, marketPrice.length)];
    [mtext yy_setColor:HEXColor(@"#9B9B9B", 1) range:NSMakeRange(nowPrice.length, marketPrice.length)];
    
    NSRange range = [[mtext string] rangeOfString:marketPrice options:NSCaseInsensitiveSearch];
    YYTextDecoration *decoration = [YYTextDecoration decorationWithStyle:YYTextLineStyleSingle
                                                                   width:@(0.8)
                                                                   color:HEXColor(@"#9B9B9B", 1)];
    //删除样式
    [mtext yy_setTextStrikethrough:decoration range:range];
    _priceLab.attributedText = mtext;
    
    _saleCountLab.text = @"销量: 2000";
}

@end
