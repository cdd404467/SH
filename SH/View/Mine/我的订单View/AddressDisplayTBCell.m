//
//  AddressDisplayTBCell.m
//  SH
//
//  Created by i7colors on 2019/12/30.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "AddressDisplayTBCell.h"
#import "OrderModel.h"

@interface AddressDisplayTBCell()
@property (nonatomic, strong) UILabel *receiverLab;
@property (nonatomic, strong) UILabel *phoneLab;
@property (nonatomic, strong) UILabel *addressLab;
@end

@implementation AddressDisplayTBCell

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
    _receiverLab = [[UILabel alloc] init];
    _receiverLab.font = [UIFont systemFontOfSize:14];
    _receiverLab.textColor = HEXColor(@"#4A4A4A", 1);
    [self.contentView addSubview:_receiverLab];
    [_receiverLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(40);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(20);
        make.right.mas_lessThanOrEqualTo(130);
    }];

    _phoneLab = [[UILabel alloc] init];
    _phoneLab.textAlignment = NSTextAlignmentRight;
    _phoneLab.font = _receiverLab.font;
    _phoneLab.textColor = _receiverLab.textColor;
    [self.contentView addSubview:_phoneLab];
    [_phoneLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.centerY.mas_equalTo(self.receiverLab);
        make.height.mas_equalTo(self.receiverLab);
        make.left.mas_equalTo(self.receiverLab.mas_right).offset(5);
    }];
    
    
    UIImageView *localImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"location_icon"]];
    [self.contentView addSubview:localImg];
    [localImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(15);
        make.top.mas_equalTo(self.receiverLab.mas_bottom).offset(6);
        make.height.mas_equalTo(17);
    }];
    
    _addressLab = [[UILabel alloc] init];
    _addressLab.font = _receiverLab.font;
    _addressLab.numberOfLines = 0;
    _addressLab.textColor = _receiverLab.textColor;
    [self.contentView addSubview:_addressLab];
    [_addressLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.receiverLab);
        make.right.mas_equalTo(self.phoneLab);
        make.top.mas_equalTo(self.receiverLab.mas_bottom).offset(5);
    }];
    
}

- (void)setModel:(OrderDetailModel *)model {
    _model = model;
    _receiverLab.text = [NSString stringWithFormat:@"收货人: %@",model.receiptPerson];
    _phoneLab.text = model.receiptPhone;
    _addressLab.text = [NSString stringWithFormat:@"收货地址: %@%@%@%@",model.receiptProvince,model.receiptCity,model.receiptArea,model.receiptAddr];
    [_addressLab.superview layoutIfNeeded];
    _model.addrCellHeight = _addressLab.bottom + 10;
}


+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"AddressDisplayTBCell";
    AddressDisplayTBCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[AddressDisplayTBCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
@end
