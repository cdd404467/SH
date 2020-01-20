//
//  InvoiceDetailTBCell.m
//  SH
//
//  Created by i7colors on 2020/1/2.
//  Copyright © 2020 surhoo. All rights reserved.
//

#import "InvoiceDetailTBCell.h"

@interface InvoiceDetailTBCell()

@end

@implementation InvoiceDetailTBCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = UIColor.whiteColor;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    _leftLab = [[UILabel alloc] init];
    _leftLab.textColor = HEXColor(@"#4A4A4A", 1);
    _leftLab.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_leftLab];
    [_leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.height.mas_equalTo(self.contentView);
        make.width.mas_lessThanOrEqualTo(120);
    }];

    _rightLab = [[UILabel alloc] init];
    _rightLab.textColor = HEXColor(@"#9B9B9B", 1);
    _rightLab.textAlignment = NSTextAlignmentRight;
    _rightLab.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_rightLab];
    [_rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.height.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.leftLab.mas_right).offset(5);
    }];
}



+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"InvoiceDetailTBCell";
    InvoiceDetailTBCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[InvoiceDetailTBCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
