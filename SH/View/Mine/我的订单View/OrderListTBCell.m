//
//  OrderListTBCell.m
//  SH
//
//  Created by i7colors on 2019/12/23.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "OrderListTBCell.h"
#import <YYText.h>
#import "OrderModel.h"

@interface OrderListTBCell()
@property (nonatomic, strong) UIImageView *goodsImageView;
@property (nonatomic, strong) UILabel *goodsNameLab;
@property (nonatomic, strong) UILabel *specLab;
@property (nonatomic, strong) YYLabel *priceLab;
@property (nonatomic, strong) UILabel *countLab;
@end

@implementation OrderListTBCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = HEXColor(@"#F6F6F6", 1);
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = UIColor.whiteColor;
    [self.contentView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.bottom.mas_equalTo(0);
    }];
    
    _goodsImageView = [[UIImageView alloc] init];
    _goodsImageView.image = PlaceHolderImg;
    [bgView addSubview:_goodsImageView];
    [_goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(self.contentView);
        make.width.height.mas_equalTo(96);
    }];
    [_goodsImageView.superview layoutIfNeeded];
    [HelperTool drawRound:_goodsImageView radiu:6.f];
    
    _goodsNameLab = [[UILabel alloc] init];
    _goodsNameLab.numberOfLines = 2;
    _goodsNameLab.textColor = HEXColor(@"#343333", 1);
    _goodsNameLab.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:_goodsNameLab];
    [_goodsNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.goodsImageView.mas_right).offset(10);
        make.right.mas_equalTo(-14);
        make.top.mas_equalTo(self.goodsImageView);
    }];
    
    _specLab = [[UILabel alloc] init];
    _specLab.textColor = HEXColor(@"#9B9B9B", 1);
    _specLab.font = [UIFont systemFontOfSize:12];
    [bgView addSubview:_specLab];
    [_specLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.goodsNameLab);
        make.top.mas_equalTo(self.goodsImageView.mas_top).offset(50);
    }];
    
    _priceLab = [[YYLabel alloc] init];
    [bgView addSubview:_priceLab];
    [_priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.goodsNameLab);
        make.bottom.mas_equalTo(self.goodsImageView);
        make.right.mas_lessThanOrEqualTo(-100);
    }];
    
    _countLab = [[UILabel alloc] init];
    _countLab.textColor = HEXColor(@"#4A4A4A", 1);
    _countLab.font = [UIFont systemFontOfSize:14];
    _countLab.textAlignment = NSTextAlignmentRight;
    [bgView addSubview:_countLab];
    [_countLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.goodsNameLab);
        make.bottom.mas_equalTo(self.priceLab);
        make.left.mas_equalTo(self.priceLab.mas_right).offset(10);
    }];
}

- (void)setModel:(OrderGoodsModel *)model {
    _model = model;
    NSArray *imgArr = [model.goodsImg componentsSeparatedByString:@","];
    [_goodsImageView sd_setImageWithURL:ImgUrl_SD_OSS(imgArr[0], 96 * 2) placeholderImage:PlaceHolderImg];
    _goodsNameLab.text = model.goodsName;
    _specLab.text = model.skuName;
    _countLab.text = [NSString stringWithFormat:@"x %@",@(model.goodsNum).stringValue];
    NSString *marketPrice = [NSString stringWithFormat:@"¥%@",model.goodsMarketPrice];
    NSString *salePrice = [NSString stringWithFormat:@"¥%@",model.goodsPrice];
    NSString *text = [NSString stringWithFormat:@"%@ %@",salePrice,marketPrice];
    NSMutableAttributedString *price = [[NSMutableAttributedString alloc] initWithString:text];
    price.yy_color = HEXColor(@"#FF5100", 1);
    price.yy_font = [UIFont systemFontOfSize:16];
    NSRange range = NSMakeRange(salePrice.length + 1, marketPrice.length);
    [price yy_setFont:[UIFont systemFontOfSize:12] range:range];
    [price yy_setColor:HEXColor(@"#9B9B9B", 1) range:range];
    //下划线
    YYTextDecoration *decoration = [YYTextDecoration decorationWithStyle:YYTextLineStyleSingle
                                                                   width:@(1)
                                                                   color:HEXColor(@"#9B9B9B", 1)];
    //删除样式
    [price yy_setTextStrikethrough:decoration range:range];
    _priceLab.attributedText = price;
}


+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"OrderListTBCell";
    OrderListTBCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[OrderListTBCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
@end
