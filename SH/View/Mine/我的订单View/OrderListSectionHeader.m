//
//  OrderListSectionHeader.m
//  SH
//
//  Created by i7colors on 2019/12/23.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "OrderListSectionHeader.h"
#import "OrderModel.h"

@interface OrderListSectionHeader()
@property (nonatomic, strong) UILabel *shopNameTimeLab;
@property (nonatomic, strong) UILabel *statusLab;
@end


@implementation OrderListSectionHeader
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = HEXColor(@"#F6F6F6", 1);
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = UIColor.whiteColor;
    bgView.frame = CGRectMake(10, 10, SCREEN_WIDTH - 20, 40);
    [self.contentView addSubview:bgView];
    [HelperTool drawRound:bgView corner:UIRectCornerTopLeft | UIRectCornerTopRight radiu:6.f];
    
    _shopNameTimeLab = [[UILabel alloc] init];
    _shopNameTimeLab.font = [UIFont systemFontOfSize:13];
    _shopNameTimeLab.textColor = HEXColor(@"#9B9B9B", 1);
    [bgView addSubview:_shopNameTimeLab];
    [_shopNameTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.height.mas_equalTo(30);
        make.right.mas_lessThanOrEqualTo(-70);
        make.centerY.mas_equalTo(bgView);
    }];
    
    _statusLab = [[UILabel alloc] init];
    _statusLab.font = _shopNameTimeLab.font;
    _statusLab.textColor = HEXColor(@"#FF5100", 1);
    _statusLab.textAlignment = NSTextAlignmentRight;
    [bgView addSubview:_statusLab];
    [_statusLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.height.centerY.mas_equalTo(self.shopNameTimeLab);
    }];
}

- (void)setModel:(OrderModel *)model {
    _model = model;
    _shopNameTimeLab.text = [NSString stringWithFormat:@"%@ %@",model.shopName,model.orderTime];
    NSString *status = [NSString string];
    if (model.orderStatus == 1) {
        status = @"待付款";
    } else if (model.orderStatus == 2) {
        status = @"待发货";
    } else if (model.orderStatus == 3) {
        status = @"已取消";
    } else if (model.orderStatus == 4) {
        status = @"待收货";
    } else if (model.orderStatus == 5) {
        status = @"待使用";
    } else if (model.orderStatus == 6) {
        status = @"待评价";
    } else if (model.orderStatus == 7) {
        status = @"已完成";
    } else if (model.orderStatus == 8) {
        status = @"已关闭";
    } else {
        status = @"--";
    }
    
    _statusLab.text = status;
}

+ (instancetype)headerWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"OrderListSectionHeader";
    // 1.缓存中取
    OrderListSectionHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    // 2.创建
    if (header == nil) {
        header = [[OrderListSectionHeader alloc] initWithReuseIdentifier:identifier];
    }
    
    return header;
}
@end
