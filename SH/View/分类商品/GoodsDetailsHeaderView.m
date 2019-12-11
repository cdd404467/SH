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
#import "YYText.h"
#import "GoodsModel.h"

static NSString *cvID = @"ImageCell";

@interface GoodsDetailsHeaderView()<ZKCycleScrollViewDelegate, ZKCycleScrollViewDataSource>
@property (nonatomic, strong) ZKCycleScrollView *bannerView;
@property (nonatomic, strong) UILabel *pageLab;
@property (nonatomic, strong) UILabel *goodsNameLab;
@property (nonatomic, strong) YYLabel *priceLab;
@property (nonatomic, strong) UILabel *saleCountLab;
@property (nonatomic, strong) UIImageView *selectedGoodsImg;
@property (nonatomic, strong) UILabel *specLab;
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
    _goodsNameLab.numberOfLines = 0;
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
        make.bottom.mas_equalTo(self.priceLab.mas_bottom).offset(-3);
        make.height.mas_equalTo(20);
    }];
    
    UIView *spView = [[UIView alloc] init];
    spView.backgroundColor = HEXColor(@"#f6f6f6", 1);
    [self addSubview:spView];
    [spView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(10);
        make.top.mas_equalTo(SCREEN_WIDTH + 115);
    }];
    
    UIView *selectSpecView = [[UIView alloc] init];
    [HelperTool addTapGesture:selectSpecView withTarget:self andSEL:@selector(selectSpec)];
    selectSpecView.backgroundColor = UIColor.whiteColor;
    [self addSubview:selectSpecView];
    [selectSpecView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(spView.mas_bottom).offset(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(60);
    }];

    _selectedGoodsImg = [[UIImageView alloc] init];
    _selectedGoodsImg.backgroundColor = HEXColor(@"#f6f6f6", 1);
    [selectSpecView addSubview:_selectedGoodsImg];
    [_selectedGoodsImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.width.height.mas_equalTo(40);
        make.centerY.mas_equalTo(selectSpecView);
    }];

    UIImageView *rightArrow = [[UIImageView alloc] init];
    UIImage *image = [UIImage imageNamed:@"right_arrow"];
    rightArrow.image = [image imageWithTintColor_My:HEXColor(@"#989393", 1)];
    [selectSpecView addSubview:rightArrow];
    [rightArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(6);
        make.height.mas_equalTo(12);
        make.centerY.mas_equalTo(selectSpecView);
        make.right.mas_equalTo(-15);
    }];

    _specLab = [[UILabel alloc] init];
    _specLab.textAlignment = NSTextAlignmentRight;
    _specLab.textColor = HEXColor(@"#2F2326", 1);
    _specLab.font = [UIFont systemFontOfSize:14];
    [selectSpecView addSubview:_specLab];
    [_specLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.selectedGoodsImg.mas_right).offset(10);
        make.right.mas_equalTo(rightArrow.mas_left).offset(-10);
        make.centerY.mas_equalTo(rightArrow);
    }];
}

#pragma mark -- ZKCycleScrollView DataSource
- (NSInteger)numberOfItemsInCycleScrollView:(ZKCycleScrollView *)cycleScrollView {
    return self.model.bannerArray.count;
}

- (__kindof ZKCycleScrollViewCell *)cycleScrollView:(ZKCycleScrollView *)cycleScrollView cellForItemAtIndex:(NSInteger)index {
    BannerImageCell *cell = [cycleScrollView dequeueReusableCellWithReuseIdentifier:cvID forIndex:index];
    cell.imageURL = self.model.bannerArray[index];
    return cell;
}

#pragma mark -- ZKCycleScrollView Delegate
- (void)cycleScrollView:(ZKCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
//    NSLog(@"selected index: %zd", index);
}

- (void)cycleScrollViewDidScroll:(ZKCycleScrollView *)cycleScrollView progress:(CGFloat)progress {
    
}

- (void)cycleScrollView:(ZKCycleScrollView *)cycleScrollView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    _pageLab.text = [NSString stringWithFormat:@"%ld/%ld",(long)toIndex + 1,(long)_model.bannerArray.count];
//    NSLog(@"from %zd to %zd", fromIndex, toIndex);
}

- (void)setModel:(GoodsDetailModel *)model {
    _model = model;
    [_bannerView reloadData];
    _pageLab.text = [NSString stringWithFormat:@"1/%ld",(long)model.bannerArray.count];
    _goodsNameLab.text = model.goodsName;
    //price富文本
    NSString *nowPrice = [NSString stringWithFormat:@"¥%@  ",model.goodsPrice];
    NSString *marketPrice = [@"¥" stringByAppendingString:model.goodsMarketPrice];
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
    
    _saleCountLab.text = [@"销量: " stringByAppendingString:model.saleCount];
}

- (void)setSpecValue:(NSMutableDictionary *)specValue {
    _specValue = specValue;
    if ([specValue objectForKey:@"specTxt"]) {
        NSString *txt = [specValue objectForKey:@"specTxt"];
        _specLab.text = txt;
    }
    if ([specValue objectForKey:@"specImg"]) {
        NSString *img = [specValue objectForKey:@"specImg"];
        [_selectedGoodsImg sd_setImageWithURL:ImgUrl_SD_OSS(img, 80)];
    }
}

- (void)selectSpec {
    if (self.selectBlock) {
        self.selectBlock();
    }
}

@end
