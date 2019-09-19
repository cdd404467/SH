//
//  ShopTBCell.m
//  SH
//
//  Created by i7colors on 2019/9/19.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "ShopTBCell.h"
#import <YYText.h>

@interface ShopTBCell()
@property (nonatomic, strong) UIImageView *shopImageView;
@property (nonatomic, strong) UILabel *shopNameLab;
@property (nonatomic, strong) UIImageView *signImg;
@property (nonatomic, strong) UILabel *signLab;
@property (nonatomic, strong) YYLabel *hotLab;
@end

@implementation ShopTBCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    _shopImageView = [[UIImageView alloc] init];
    _shopImageView.frame = CGRectMake(15, 10, 110, 110);
    _shopImageView.image = TestImage;
    [self.contentView addSubview:_shopImageView];
    [HelperTool drawRound:_shopImageView radiu:8.f];
    
    _shopNameLab = [[UILabel alloc] init];
    _shopNameLab.text = @"商家名称商家名称商家名称商 家名称商家名";
    _shopNameLab.numberOfLines = 2;
    _shopNameLab.textColor = HEXColor(@"#090203", 1);
    _shopNameLab.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:_shopNameLab];
    [_shopNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.shopImageView.mas_right).offset(10);
        make.top.mas_equalTo(self.shopImageView);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(44);
    }];
    
    _signImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sign_bgImg"]];
    [self.contentView addSubview:_signImg];
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
    [self.contentView addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.shopNameLab);
        make.width.mas_equalTo(10);
        make.height.mas_equalTo(12);
        make.bottom.mas_equalTo(self.shopImageView);
    }];
    
    //redu
    _hotLab = [[YYLabel alloc] init];
    [self.contentView addSubview:_hotLab];
    [_hotLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(icon.mas_right).offset(3);
        make.bottom.mas_equalTo(icon);
        make.height.mas_equalTo(17);
    }];
    
    NSString *str = @"商家热度: ";
    NSString *hot = @"500";
    NSString *text = [str stringByAppendingString:hot];
    NSMutableAttributedString *mtext = [[NSMutableAttributedString alloc] initWithString:text];
    mtext.yy_color = HEXColor(@"FF5100", 1);
    mtext.yy_font = [UIFont systemFontOfSize:12];
    [mtext yy_setFont:[UIFont systemFontOfSize:18 weight:UIFontWeightMedium] range:NSMakeRange(str.length, hot.length)];
    _hotLab.attributedText = mtext;
}


+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"EvaluationTBCell";
    ShopTBCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[ShopTBCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
@end
