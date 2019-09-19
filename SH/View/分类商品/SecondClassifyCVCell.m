//
//  SecondClassifyCVCell.m
//  SH
//
//  Created by i7colors on 2019/9/16.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "SecondClassifyCVCell.h"
#import <UIImageView+WebCache.h>
#import "ClassifyModel.h"

@interface SecondClassifyCVCell()
@property (nonatomic, strong) UIImageView *goodsImageView;
@property (nonatomic, strong) UILabel *nameLab;
@end

@implementation SecondClassifyCVCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = UIColor.whiteColor;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UIImageView *goodsImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:goodsImageView];
    [goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-30);
    }];
    _goodsImageView = goodsImageView;
    
    UILabel *nameLab = [[UILabel alloc] init];
    nameLab.textColor = HEXColor(@"#615454", 1);
    nameLab.textAlignment = NSTextAlignmentCenter;
    nameLab.font = [UIFont systemFontOfSize:11];
    [self.contentView addSubview:nameLab];
    [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(goodsImageView.mas_bottom);
    }];
    _nameLab = nameLab;
}

- (void)setModel:(ClassifyModel *)model {
    _model = model;
    
    [_goodsImageView sd_setImageWithURL:ImgUrl_SD(model.img) placeholderImage:TestImage];
    _nameLab.text = model.name;
}

@end
