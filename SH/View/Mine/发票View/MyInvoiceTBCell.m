//
//  MyInvoiceTBCell.m
//  SH
//
//  Created by i7colors on 2019/12/15.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "MyInvoiceTBCell.h"
#import "InvoiceModel.h"

@interface MyInvoiceTBCell()
@property (nonatomic, strong) UILabel *typeLab;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *contentLab;
@property (nonatomic, strong) UILabel *isDefaultLab;
@end

@implementation MyInvoiceTBCell

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
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [editBtn setImage:[UIImage imageNamed:@"edit_icon"] forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(editClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:editBtn];
    [editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-14);
        make.width.height.mas_equalTo(16);
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    _typeLab = [[UILabel alloc] init];
    _typeLab.textColor = HEXColor(@"#4A4A4A", 2);
    _typeLab.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_typeLab];
    [_typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(17);
    }];
    
    _isDefaultLab = [[UILabel alloc] init];
    _isDefaultLab.text = @"默认";
    _isDefaultLab.textAlignment = NSTextAlignmentCenter;
    _isDefaultLab.font = [UIFont systemFontOfSize:11];
    _isDefaultLab.backgroundColor = HEXColor(@"#F7F3F1", 1);
    _isDefaultLab.textColor = HEXColor(@"#FF5100", 1);
    _isDefaultLab.layer.cornerRadius = 2.f;
    _isDefaultLab.hidden = YES;
    [self.contentView addSubview:_isDefaultLab];
    [_isDefaultLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.typeLab.mas_right).offset(8);
        make.width.mas_equalTo(33);
        make.height.mas_equalTo(15);
        make.centerY.mas_equalTo(self.typeLab);
    }];
    
    _titleLab = [[UILabel alloc] init];
    _titleLab.font = _typeLab.font;
    _titleLab.textColor = _typeLab.textColor;
    [self.contentView addSubview:_titleLab];
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.right.mas_equalTo(self.typeLab);
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    _contentLab = [[UILabel alloc] init];
    _contentLab.font = _typeLab.font;
    _contentLab.textColor = _typeLab.textColor;
    [self.contentView addSubview:_contentLab];
    [_contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.mas_equalTo(self.typeLab);
        make.right.mas_equalTo(editBtn);
        make.top.mas_equalTo(self.titleLab.mas_bottom).offset(12);
    }];
}

- (void)editClick {
    if (self.editBlock) {
        self.editBlock(_index);
    }
}

- (void)setModel:(InvoiceModel *)model {
    _model = model;
    NSString *type = [NSString string];
    if (model.invoiceType == 1) {
        type = @"发票类型: 电子普通发票";
    } else if (model.invoiceType == 2) {
        type = @"发票类型: 增值税专用发票";
    } else {
        type = @"未知";
    }
    _typeLab.text = type;
    _isDefaultLab.hidden = model.defaultStatus == 1 ? NO : YES;
    _titleLab.text = [NSString stringWithFormat:@"发票抬头: %@",model.title];
    _contentLab.text = [NSString stringWithFormat:@"发票内容: %@",model.content];
}


+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"MyInvoiceTBCell";
    MyInvoiceTBCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MyInvoiceTBCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
@end
