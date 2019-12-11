//
//  ShopCarSectionHeader.m
//  SH
//
//  Created by i7colors on 2019/9/26.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "ShopCarSectionHeader.h"
#import "ShopCarModel.h"

@interface ShopCarSectionHeader()
@property (nonatomic, strong) UILabel *shopNameLab;
@property (nonatomic, strong) UIButton *selectBtn;
@end

@implementation ShopCarSectionHeader
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = MainBgColor;
        [self setupUI];
    }
    
    return self;
}



- (void)setupUI {
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = UIColor.whiteColor;
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(10);
        make.bottom.mas_equalTo(0);
    }];
    [bgView.superview layoutIfNeeded];
    [HelperTool drawRound:bgView corner:UIRectCornerTopLeft | UIRectCornerTopRight radiu:8.f];
    
    _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_selectBtn setImage:[UIImage imageNamed:@"icon_unSelect"] forState:UIControlStateNormal];
    [_selectBtn setImage:[UIImage imageNamed:@"icon_select"] forState:UIControlStateSelected];
    [_selectBtn addTarget:self action:@selector(selectBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _selectBtn.adjustsImageWhenHighlighted = NO;
    [bgView addSubview:_selectBtn];
    [_selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.width.height.mas_equalTo(30);
        make.centerY.mas_equalTo(bgView);
    }];
    
    _shopNameLab = [[UILabel alloc] init];
    _shopNameLab.textColor = HEXColor(@"#090203", 1);
    _shopNameLab.font = [UIFont systemFontOfSize:13];
    [bgView addSubview:_shopNameLab];
    [_shopNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(40);
        make.right.mas_equalTo(-11);
        make.centerY.mas_equalTo(bgView);
        make.height.mas_equalTo(20);
    }];
}

- (void)setModel:(ShopCarModel *)model {
    _model = model;
    _shopNameLab.text = model.shopName;
    _selectBtn.selected = model.isSelected;
}

- (void)selectBtnClick {
    _model.isSelected = !_model.isSelected;
    for (ShopCarModel *goodsModel in _model.carGoodsList) {
        goodsModel.isSelected = _model.isSelected;
    }
    if (self.selectStoreBlock) {
        self.selectStoreBlock(_indexPath);
    }
}
@end
