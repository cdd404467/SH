//
//  ShopCVCell.m
//  SH
//
//  Created by i7colors on 2019/9/23.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "ShopCVCell.h"
#import <YYText.h>
#import "ShopModel.h"

@interface ShopCVCell()
@property (nonatomic, strong) UIImageView *shopImageView;
@property (nonatomic, strong) UILabel *shopNameLab;
@property (nonatomic, strong) UIImageView *signImg;
@property (nonatomic, strong) UILabel *signLab;
@property (nonatomic, strong) YYLabel *hotLab;
@end


@implementation ShopCVCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = HEXColor(@"#F6F6F6", 1);
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = UIColor.whiteColor;
    bgView.layer.cornerRadius = 6.f;
    [self.contentView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    _shopImageView = [[UIImageView alloc] init];
    [bgView addSubview:_shopImageView];
    [_shopImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.width.height.mas_equalTo(110);
        make.centerY.mas_equalTo(bgView);
    }];
    [_shopImageView.superview layoutIfNeeded];
    [HelperTool drawRound:_shopImageView radiu:8.f];
    

    _shopNameLab = [[UILabel alloc] init];
    _shopNameLab.numberOfLines = 2;
    _shopNameLab.textColor = HEXColor(@"#090203", 1);
    _shopNameLab.font = [UIFont systemFontOfSize:16];
    [bgView addSubview:_shopNameLab];
    [_shopNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.shopImageView.mas_right).offset(10);
        make.top.mas_equalTo(self.shopImageView);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(44);
    }];

    _signImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sign_bgImg"]];
    [bgView addSubview:_signImg];
    [_signImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.shopNameLab);
        make.top.mas_equalTo(self.shopNameLab.mas_bottom).offset(8);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(17);
    }];

    _signLab = [[UILabel alloc] init];
    _signLab.text = @"动漫";
    _signLab.textAlignment = NSTextAlignmentCenter;
    [_signImg addSubview:_signLab];
    [_signLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];

    //商家热度
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hot_icon"]];
    [bgView addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.shopNameLab);
        make.width.mas_equalTo(10);
        make.height.mas_equalTo(12);
        make.bottom.mas_equalTo(self.shopImageView);
    }];

    //redu
    _hotLab = [[YYLabel alloc] init];
    [bgView addSubview:_hotLab];
    [_hotLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(icon.mas_right).offset(3);
        make.bottom.mas_equalTo(icon);
        make.height.mas_equalTo(17);
    }];
}

- (void)setModel:(ShopModel *)model {
    _model = model;
    
    [_shopImageView sd_setImageWithURL:ImgUrl_SD_OSS(model.logo, 120) placeholderImage:PlaceHolderImg];
    _shopNameLab.text = model.name;
    
    NSString *str = @"商家热度: ";
    NSString *hot = model.viewNum;
    NSString *text = [str stringByAppendingString:hot];
    NSMutableAttributedString *mtext = [[NSMutableAttributedString alloc] initWithString:text];
    mtext.yy_color = HEXColor(@"FF5100", 1);
    mtext.yy_font = [UIFont systemFontOfSize:12];
    [mtext yy_setFont:[UIFont systemFontOfSize:18 weight:UIFontWeightMedium] range:NSMakeRange(str.length, hot.length)];
    _hotLab.attributedText = mtext;
}

@end
