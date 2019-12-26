//
//  ReceiverInfoView.m
//  SH
//
//  Created by i7colors on 2019/12/21.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "ReceiverInfoView.h"
#import "AddressModel.h"

@interface ReceiverInfoView()
@property (nonatomic, strong) UILabel *receiverLab;
@property (nonatomic, strong) UILabel *phoneLab;
@property (nonatomic, strong) UILabel *addressLab;
@end

@implementation ReceiverInfoView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    _receiverLab = [[UILabel alloc] init];
    _receiverLab.font = [UIFont systemFontOfSize:14];
    _receiverLab.textColor = HEXColor(@"#4A4A4A", 1);
    [self addSubview:_receiverLab];
    [_receiverLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(40);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(20);
        make.right.mas_lessThanOrEqualTo(130);
    }];
    
    _phoneLab = [[UILabel alloc] init];
    _phoneLab.textAlignment = NSTextAlignmentRight;
    _phoneLab.font = _receiverLab.font;
    _phoneLab.textColor = _receiverLab.textColor;
    [self addSubview:_phoneLab];
    [_phoneLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-24);
        make.centerY.mas_equalTo(self.receiverLab);
        make.height.mas_equalTo(self.receiverLab);
        make.left.mas_equalTo(self.receiverLab.mas_right).offset(5);
    }];
    
    UIImageView *localImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"location_icon"]];
    [self addSubview:localImg];
    [localImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(15);
        make.top.mas_equalTo(self.receiverLab.mas_bottom).offset(6);
        make.height.mas_equalTo(17);
    }];
    
    _addressLab = [[UILabel alloc] init];
    _addressLab.font = _receiverLab.font;
    _addressLab.numberOfLines = 0;
    _addressLab.textColor = _receiverLab.textColor;
    [self addSubview:_addressLab];
    [_addressLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.receiverLab);
        make.right.mas_equalTo(self.phoneLab);
        make.centerY.mas_equalTo(localImg);
    }];
}

- (void)setModel:(AddressModel *)model {
    _model = model;
    _receiverLab.text = [NSString stringWithFormat:@"收货人: %@",model.name];
    _phoneLab.text = model.phone;
    _addressLab.text = [NSString stringWithFormat:@"收货地址: %@%@%@%@",model.provinceName,model.cityName,model.districtName,model.address];
    [_addressLab.superview layoutIfNeeded];
}

@end
