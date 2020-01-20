//
//  OrderListSectionFooter.m
//  SH
//
//  Created by i7colors on 2019/12/23.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "OrderListSectionFooter.h"
#import "OrderModel.h"

@interface OrderListSectionFooter()
@property (nonatomic, strong) UILabel *totalMoneyLab;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@end

@implementation OrderListSectionFooter
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = HEXColor(@"#F6F6F6", 1);
        [HelperTool addTapGesture:self withTarget:self andSEL:@selector(detailClick)];
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = UIColor.whiteColor;
    bgView.frame = CGRectMake(10, 0, SCREEN_WIDTH - 20, 40);
    [self.contentView addSubview:bgView];
    [HelperTool drawRound:bgView corner:UIRectCornerBottomLeft | UIRectCornerBottomRight radiu:6.f];
    
    _totalMoneyLab = [[UILabel alloc] init];
    _totalMoneyLab = [[UILabel alloc] init];
    _totalMoneyLab.font = [UIFont systemFontOfSize:13];
    _totalMoneyLab.textColor = HEXColor(@"#9B9B9B", 1);
    [bgView addSubview:_totalMoneyLab];
    [_totalMoneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.height.mas_equalTo(30);
        make.right.mas_lessThanOrEqualTo(-170);
        make.centerY.mas_equalTo(bgView);
    }];
    [bgView addSubview:_totalMoneyLab];
    
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightBtn setTitleColor:HEXColor(@"#FF5100", 1) forState:UIControlStateNormal];
    _rightBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_rightBtn addTarget:self action:@selector(clickRightBtn) forControlEvents:UIControlEventTouchUpInside];
    _rightBtn.layer.cornerRadius = 14.f;
    _rightBtn.layer.borderColor = HEXColor(@"#FF5100", 1).CGColor;
    _rightBtn.layer.borderWidth = 0.5f;
    [bgView addSubview:_rightBtn];
    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(28);
        make.centerY.mas_equalTo(self.totalMoneyLab);
        make.width.mas_equalTo(72);
    }];
    
    _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_leftBtn setTitleColor:HEXColor(@"#4A4A4A", 1) forState:UIControlStateNormal];
    [_leftBtn addTarget:self action:@selector(clickLeftBtn) forControlEvents:UIControlEventTouchUpInside];
    _leftBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    _leftBtn.layer.cornerRadius = 14.f;
    _leftBtn.layer.borderColor = HEXColor(@"#4A4A4A", 1).CGColor;
    _leftBtn.layer.borderWidth = 0.5f;
    [bgView addSubview:_leftBtn];
    [_leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-92);
        make.height.centerY.width.mas_equalTo(self.rightBtn);
    }];
    
}

- (void)setModel:(OrderModel *)model {
    _model = model;
    _totalMoneyLab.text = [NSString stringWithFormat:@"总计: ¥%@",[HelperTool dealStrFormoney:model.orderAmount.stringValue]];
    [self setBtnStateWithStatus:model.orderStatus];
}


- (void)setBtnStateWithStatus:(NSInteger)status {
    //右边按钮显示
    if (status == 1 || status == 4 || status == 6) {
        _rightBtn.hidden = NO;
    } else {
        _rightBtn.hidden = YES;
    }
    //左边按钮显示
    if (status == 1 || status == 3 || status == 4 || status == 7 || status == 8) {
        _leftBtn.hidden = NO;
    } else {
        _leftBtn.hidden = YES;
    }
    //更新按钮布局
    if (_rightBtn.hidden && !_leftBtn.hidden) {
        [_leftBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
        }];
    } else {
        [_leftBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-92);
        }];
    }
    //设置按钮文字
    switch (status) {
        case 1: //待付款
        {
            [_leftBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            [_rightBtn setTitle:@"立即付款" forState:UIControlStateNormal];
        }
            break;
        case 2: //待发货
        case 5: //待使用
            break;
        case 3: //已取消
        case 7: //已完成
        case 8: //已关闭
        {
            [_leftBtn setTitle:@"删除订单" forState:UIControlStateNormal];
        }
            break;
        case 4: //待收货
        {
            [_leftBtn setTitle:@"查看物流" forState:UIControlStateNormal];
            [_rightBtn setTitle:@"确认收货" forState:UIControlStateNormal];
        }
            break;
        case 6: //待评价
        {
            [_rightBtn setTitle:@"立即评价" forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
}

- (void)clickLeftBtn {
    if (self.leftBtnClickBlock) {
        self.leftBtnClickBlock(_model.orderStatus, _section);
    }
}

- (void)clickRightBtn {
    if (self.rightBtnClickBlock) {
        self.rightBtnClickBlock(_model.orderStatus, _section);
    }
}

- (void)detailClick {
    if (self.detailClickBlock) {
        self.detailClickBlock(_section);
    }
}

+ (instancetype)footerWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"OrderListSectionFooter";
    // 1.缓存中取
    OrderListSectionFooter *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    // 2.创建
    if (header == nil) {
        header = [[OrderListSectionFooter alloc] initWithReuseIdentifier:identifier];
    }
    
    return header;
}
@end
