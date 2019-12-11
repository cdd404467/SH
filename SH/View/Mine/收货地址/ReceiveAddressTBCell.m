//
//  ReceiveAddressTBCell.m
//  SH
//
//  Created by i7colors on 2019/12/11.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "ReceiveAddressTBCell.h"
#import "AddressModel.h"

@interface ReceiveAddressTBCell()
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UILabel *phoneNumLab;
@property (nonatomic, strong) UILabel *addressLab;
@property (nonatomic, strong) UILabel *isDefaultLab;
@end

@implementation ReceiveAddressTBCell

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
    _nameLab = [[UILabel alloc] init];
    _nameLab.font = [UIFont systemFontOfSize:13];
    _nameLab.textColor = HEXColor(@"#4A4A4A", 1);
    [self.contentView addSubview:_nameLab];
    [_nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(12);
        make.height.mas_equalTo(18);
        make.right.mas_lessThanOrEqualTo(-170);
    }];
    
    _phoneNumLab = [[UILabel alloc] init];
    _phoneNumLab.font = [UIFont systemFontOfSize:13];
    _phoneNumLab.textColor = HEXColor(@"#9B9B9B", 1);
    [self.contentView addSubview:_phoneNumLab];
    [_phoneNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLab.mas_right).offset(30);
        make.top.height.mas_equalTo(self.nameLab);
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
        make.left.mas_equalTo(self.phoneNumLab.mas_right).offset(8);
        make.width.mas_equalTo(33);
        make.height.mas_equalTo(15);
        make.centerY.mas_equalTo(self.phoneNumLab);
    }];
    
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [editBtn setImage:[UIImage imageNamed:@"edit_icon"] forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(editClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:editBtn];
    [editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-14);
        make.width.height.mas_equalTo(16);
        make.top.mas_equalTo(43);
    }];
    
    _addressLab = [[UILabel alloc] init];
    _addressLab.font = [UIFont systemFontOfSize:14];
    _addressLab.textColor = HEXColor(@"#090203", 1);
    _addressLab.numberOfLines = 3;
    [self.contentView addSubview:_addressLab];
    [_addressLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLab);
        make.top.mas_equalTo(self.nameLab.mas_bottom).offset(8);
        make.right.mas_equalTo(editBtn.mas_left).offset(-12);
    }];
}

- (void)editClick {
    if (self.editBlock) {
        self.editBlock(_index);
    }
}

- (void)setModel:(AddressModel *)model {
    _model = model;
    _nameLab.text = model.name;
    _phoneNumLab.text = model.phone;
    _addressLab.text = model.address;
    _isDefaultLab.hidden = model.defaultStatus == 1 ? NO : YES;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"ReceiveAddressTBCell";
    ReceiveAddressTBCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[ReceiveAddressTBCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
