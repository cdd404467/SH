//
//  OrderStatusView.m
//  SH
//
//  Created by i7colors on 2019/12/21.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "OrderStatusView.h"

@interface OrderStatusView()
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *tipsLab;
@end

@implementation OrderStatusView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.image = [UIImage imageNamed:@"order_status_bg"];
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, KFit_W(80));
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    _iconImage = [[UIImageView alloc] init];
    [self addSubview:_iconImage];
    [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(17);
        make.centerY.mas_equalTo(self.mas_centerY).offset(0);
        make.left.mas_equalTo(20);
    }];
    
    _titleLab = [[UILabel alloc] init];
    _titleLab.textColor = UIColor.whiteColor;
    _titleLab.font = [UIFont systemFontOfSize:14];
    [self addSubview:_titleLab];
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.iconImage);
        make.height.mas_equalTo(20);
        make.left.mas_equalTo(self.iconImage.mas_right).offset(5);
    }];
    
    _tipsLab = [[UILabel alloc] init];
    _tipsLab.hidden = YES;
    _tipsLab.textColor = _titleLab.textColor;
    _tipsLab.font = _titleLab.font;
    [self addSubview:_tipsLab];
    [_tipsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.height.mas_equalTo(20);
        make.centerY.mas_equalTo(self.mas_centerY).offset(KFit_W(5) + 10);
    }];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLab.text = title;
    [_titleLab.superview layoutIfNeeded];
    CGFloat leftGap = (SCREEN_WIDTH - 17 - 5 - _titleLab.width) / 2;
    [_iconImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(leftGap);
    }];
}

- (void)setImageName:(NSString *)imageName {
    _imageName = imageName;
    _iconImage.image = [UIImage imageNamed:imageName];
}

- (void)setTips:(NSString *)tips {
    _tips = tips;
    _tipsLab.hidden = NO;
    _tipsLab.text = tips;
    [_iconImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY).offset(-10 - KFit_W(5));
    }];
}

@end
