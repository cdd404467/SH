//
//  ShopCarCVCell.m
//  SH
//
//  Created by i7colors on 2019/9/25.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "ShopCarCVCell.h"
#import "ShopCarModel.h"
#import "ImageLabView.h"

@interface ShopCarCVCell()
@property (nonatomic, strong) UIImageView *goodsImageView;
@property (nonatomic, strong) UILabel *goodsNameLab;
@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, strong) UILabel *specLab;
@property (nonatomic, strong) UILabel *priceLab;
@property (nonatomic, strong) ImageLabView *countLab;
@end

@implementation ShopCarCVCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = UIColor.whiteColor;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    _goodsImageView = [[UIImageView alloc] init];
    _goodsImageView.image = PlaceHolderImg;
    [self.contentView addSubview:_goodsImageView];
    [_goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(40);
        make.centerY.mas_equalTo(self.contentView);
        make.width.height.mas_equalTo(96);
    }];
    [_goodsImageView.superview layoutIfNeeded];
    [HelperTool drawRound:_goodsImageView radiu:6.f];
    
    _goodsNameLab = [[UILabel alloc] init];
    _goodsNameLab.numberOfLines = 2;
    _goodsNameLab.textColor = HEXColor(@"#343333", 1);
    _goodsNameLab.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:_goodsNameLab];
    [_goodsNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.goodsImageView.mas_right).offset(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(self.goodsImageView);
    }];
    
    _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_selectBtn setImage:[UIImage imageNamed:@"icon_unSelect"] forState:UIControlStateNormal];
    [_selectBtn setImage:[UIImage imageNamed:@"icon_select"] forState:UIControlStateSelected];
    [_selectBtn addTarget:self action:@selector(selectBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _selectBtn.adjustsImageWhenHighlighted = NO;
    [self.contentView addSubview:_selectBtn];
    [_selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.width.height.mas_equalTo(30);
        make.centerY.mas_equalTo(self.goodsImageView);
    }];
    
    _specLab = [[UILabel alloc] init];
    _specLab.textColor = HEXColor(@"#9B9B9B", 1);
    _specLab.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_specLab];
    [_specLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.goodsNameLab);
        make.top.mas_equalTo(self.goodsImageView.mas_top).offset(50);
    }];
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.tag = 100;
    [addBtn setImage:[UIImage imageNamed:@"add_icon"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(changeCount:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:addBtn];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(32);
        make.height.mas_equalTo(24);
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(self.goodsImageView);
    }];
    
    _countLab = [[ImageLabView alloc] init];
    _countLab.textLab.textAlignment = NSTextAlignmentCenter;
    _countLab.textLab.font = [UIFont systemFontOfSize:14];
    _countLab.textLab.textColor = HEXColor(@"#343333", 1);
    _countLab.image = [UIImage imageNamed:@"count_display_bg"];
    [self.contentView addSubview:_countLab];
    [_countLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(addBtn.mas_left).offset(-1);
        make.height.centerY.mas_equalTo(addBtn);
        make.width.mas_equalTo(38);
    }];
    
    UIButton *minusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    minusBtn.tag = 101;
    [minusBtn setImage:[UIImage imageNamed:@"minus_icon"] forState:UIControlStateNormal];
    [minusBtn addTarget:self action:@selector(changeCount:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:minusBtn];
    [minusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(addBtn);
        make.right.mas_equalTo(self.countLab.mas_left).offset(-1);
        make.centerY.mas_equalTo(self.countLab);
    }];
    
    _priceLab = [[UILabel alloc] init];
    _priceLab.textColor = HEXColor(@"#FF5100", 1);
    _priceLab.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:_priceLab];
    [_priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.goodsNameLab);
        make.centerY.mas_equalTo(addBtn);
        make.right.mas_equalTo(minusBtn.mas_left).offset(-1);
    }];
    
}

- (void)setModel:(ShopGoodsModel *)model {
    _model = model;
    _selectBtn.selected = model.isSelected;
    [_goodsImageView sd_setImageWithURL:ImgUrl_SD_OSS(model.goodsImg, 96 * 2) placeholderImage:PlaceHolderImg];
    _goodsNameLab.text = model.goodsName;
    _specLab.text = model.skuName;
    _priceLab.text = [NSString stringWithFormat:@"¥%@",model.goodsPrice];
    _countLab.textLab.text = @(model.goodsNum).stringValue;
}

- (void)selectBtnClick {
    _model.isSelected = !_model.isSelected;
    if (self.selectGoodsBlock) {
        self.selectGoodsBlock(_indexPath);
    }
}

- (void)changeCount:(UIButton *)sender {
    //执行加操作
    if (sender.tag == 100) {
        if (_model.goodsNum < 99999) {
            _model.goodsNum = ++_model.goodsNum;
            if (self.changeCountBlock) {
                self.changeCountBlock(_indexPath, _model.goodsNum);
            }
        }
        else {
            if (self.changeCountErrorBlock) {
                self.changeCountErrorBlock(@"没有那么多库存了哦");
            }
        }
    }
    //减操作
    else if (sender.tag == 101) {
        if (_model.goodsNum > 1) {
            _model.goodsNum = --_model.goodsNum;
            if (self.changeCountBlock) {
                self.changeCountBlock(_indexPath, _model.goodsNum);
            }
        }
        else {
            if (self.changeCountErrorBlock) {
                self.changeCountErrorBlock(@"不能再少了哦");
            }
        }
    }
}


@end
