//
//  OrderGoodsTBCell.m
//  SH
//
//  Created by i7colors on 2019/12/13.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "OrderGoodsTBCell.h"
#import <YYText.h>
#import "OrderModel.h"

@interface OrderGoodsTBCell()
@property (nonatomic, strong) UIImageView *goodsImageView;
@property (nonatomic, strong) UILabel *goodsNameLab;
@property (nonatomic, strong) UILabel *specLab;
@property (nonatomic, strong) YYLabel *priceLab;
@property (nonatomic, strong) UILabel *countLab;
@end

@implementation OrderGoodsTBCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = UIColor.whiteColor;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    _goodsImageView = [[UIImageView alloc] init];
    _goodsImageView.image = PlaceHolderImg;
    [self.contentView addSubview:_goodsImageView];
    [_goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
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
        make.right.mas_equalTo(-14);
        make.top.mas_equalTo(self.goodsImageView);
    }];
    
    _specLab = [[UILabel alloc] init];
    _specLab.textColor = HEXColor(@"#9B9B9B", 1);
    _specLab.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_specLab];
    [_specLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.goodsNameLab);
        make.top.mas_equalTo(self.goodsImageView.mas_top).offset(50);
    }];
    
    _priceLab = [[YYLabel alloc] init];
    [self.contentView addSubview:_priceLab];
    [_priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.goodsNameLab);
        make.bottom.mas_equalTo(self.goodsImageView);
        make.right.mas_lessThanOrEqualTo(-100);
    }];
    
    _countLab = [[UILabel alloc] init];
    _countLab.textColor = HEXColor(@"#4A4A4A", 1);
    _countLab.font = [UIFont systemFontOfSize:14];
    _countLab.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_countLab];
    [_countLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.goodsNameLab);
        make.bottom.mas_equalTo(self.priceLab);
        make.left.mas_equalTo(self.priceLab.mas_right).offset(10);
    }];
}

- (void)setModel:(OrderGoodsModel *)model {
    _model = model;
    NSString *img = [NSString string];
    img = self.type == 0 ? model.goodsImg : model.logo;
    [_goodsImageView sd_setImageWithURL:ImgUrl_SD_OSS(img, 96 * 2) placeholderImage:PlaceHolderImg];
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
    static NSString *identifier = @"OrderGoodsTBCell";
    OrderGoodsTBCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[OrderGoodsTBCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
