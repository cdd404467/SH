//
//  OrderDetailInfoTBCell.m
//  SH
//
//  Created by i7colors on 2019/12/31.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "OrderDetailInfoTBCell.h"

@interface OrderDetailInfoTBCell()

@end

@implementation OrderDetailInfoTBCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = UIColor.whiteColor;
        [self setupUI];
        self.disType = 0;
    }
    return self;
}

- (void)setupUI {
    _LeftLab = [[UILabel alloc] init];
    _LeftLab.textColor = HEXColor(@"#4A4A4A", 1);
    _LeftLab.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_LeftLab];
    [_LeftLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.height.mas_equalTo(self.contentView);
    }];
    
    _rightLab = [[UILabel alloc] init];
    _rightLab.textColor = HEXColor(@"#9B9B9B", 1);
    _rightLab.textAlignment = NSTextAlignmentRight;
    _rightLab.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_rightLab];
    [_rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.height.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.LeftLab.mas_right).offset(5);
    }];
    
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightBtn.layer.cornerRadius = 13;
    _rightBtn.hidden = YES;
    _rightBtn.layer.borderColor = HEXColor(@"#4A4A4A", 1).CGColor;
    _rightBtn.layer.borderWidth = 0.5f;
    _rightBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_rightBtn setTitleColor:HEXColor(@"#4A4A4A", 1) forState:UIControlStateNormal];
    [self.contentView addSubview:_rightBtn];
    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(26);
        make.centerY.mas_equalTo(self.contentView);
        make.width.mas_equalTo(72);
    }];
}

- (void)setDisType:(NSInteger)disType {
    _disType = disType;
    _rightBtn.hidden = disType == 0 ? YES : NO;
    _rightLab.hidden = !_rightBtn.hidden;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *)identifier {
    OrderDetailInfoTBCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[OrderDetailInfoTBCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
@end
