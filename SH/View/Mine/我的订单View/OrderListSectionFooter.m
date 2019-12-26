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
@end

@implementation OrderListSectionFooter
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
}

- (void)setModel:(OrderModel *)model {
    _model = model;
    _totalMoneyLab.text = [NSString stringWithFormat:@"总计: ¥%@",model.orderAmount];
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
