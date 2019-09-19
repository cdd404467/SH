//
//  HotGoodsCVCell.m
//  SH
//
//  Created by i7colors on 2019/9/9.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "HotGoodsCVCell.h"
#import "GoodsModel.h"
#import <UIImageView+WebCache.h>

@interface HotGoodsCVCell()
//商品图片
@property (nonatomic, strong) UIImageView *goodsImage;
//商品名字
@property (nonatomic, strong) UILabel *goodsNameLab;
//商品价格
@property (nonatomic, strong) UILabel *goodsPriceLab;
//销量
@property (nonatomic, strong) UILabel *saleCountLab;
@end

@implementation HotGoodsCVCell
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    CGFloat imageWidth = (SCREEN_WIDTH - 16 * 2 - 10) / 2;
    UIView *bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake(0, 0, imageWidth, imageWidth + 96);
    bgView.layer.cornerRadius = 6.f;
    bgView.layer.borderWidth = 1.f;
    bgView.layer.borderColor = HEXColor(@"#E8EAEB", 1).CGColor;
    [self.contentView addSubview:bgView];
    
    
    UIImageView *goodsImage = [[UIImageView alloc] init];
    goodsImage.frame = CGRectMake(0, 0, imageWidth, imageWidth);
    [bgView addSubview:goodsImage];
    _goodsImage = goodsImage;
    [HelperTool drawRound:goodsImage corner:UIRectCornerTopLeft | UIRectCornerTopRight radiu:bgView.layer.cornerRadius];

    UILabel *goodsNameLab = [[UILabel alloc] init];
    goodsNameLab.numberOfLines = 2;
    goodsNameLab.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    [bgView addSubview:goodsNameLab];
    [goodsNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(10);
        make.right.mas_offset(-10);
        make.top.mas_equalTo(goodsImage.mas_bottom).offset(11);
        make.height.mas_equalTo(40);
    }];
    _goodsNameLab = goodsNameLab;
    
    UILabel *goodsPriceLab = [[UILabel alloc] init];
    goodsPriceLab.textColor = HEXColor(@"#FF5100", 1);
    goodsPriceLab.font = [UIFont systemFontOfSize:19 weight:UIFontWeightMedium];
    [bgView addSubview:goodsPriceLab];
    [goodsPriceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(goodsNameLab);
        make.bottom.mas_equalTo(-12);
        make.height.mas_equalTo(26);
    }];
    _goodsPriceLab = goodsPriceLab;

    UILabel *saleCountLab = [[UILabel alloc] init];
    saleCountLab.textColor = HEXColor(@"#9B9B9B", 1);
    saleCountLab.textAlignment = NSTextAlignmentRight;
    saleCountLab.font = [UIFont systemFontOfSize:11 weight:UIFontWeightRegular];
    [bgView addSubview:saleCountLab];
    [saleCountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(goodsNameLab);
        make.height.top.mas_equalTo(goodsPriceLab);
    }];
    _saleCountLab = saleCountLab;
}

- (void)setModel:(GoodsModel *)model {
    _model = model;
    [_goodsImage sd_setImageWithURL:ImgUrl_SD(model.logo) placeholderImage:TestImage];
    
    _goodsNameLab.text = model.goodsName;
    
    _goodsPriceLab.text = [NSString stringWithFormat:@"¥%@",model.goodsPrice];
    
    _saleCountLab.text = [NSString stringWithFormat:@"销量: %ld",(long)model.saleCount];
}

@end
