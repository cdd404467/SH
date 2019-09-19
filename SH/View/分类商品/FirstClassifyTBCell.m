//
//  FirstClassifyTBCell.m
//  SH
//
//  Created by i7colors on 2019/9/16.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "FirstClassifyTBCell.h"
#import "ClassifyModel.h"

@interface FirstClassifyTBCell()
@property (nonatomic, strong) UIView *leftMarkView;
@property (nonatomic, strong) UILabel *nameLab;
@end

@implementation FirstClassifyTBCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    _leftMarkView.backgroundColor = selected ? HEXColor(@"#FF5100", 1) : UIColor.clearColor;
    _nameLab.textColor = selected ? HEXColor(@"#090203", 1) : HEXColor(@"#615454", 1);
    self.contentView.backgroundColor = selected ? UIColor.whiteColor : HEXColor(@"#F6F6F6", 1);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    UIView *leftMarkView = [[UIView alloc] init];
    leftMarkView.backgroundColor = UIColor.clearColor;
    [self.contentView addSubview:leftMarkView];
    [leftMarkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(0);
        make.width.mas_equalTo(5);
        make.height.mas_equalTo(17);
        make.centerY.mas_equalTo(self.contentView);
    }];
    _leftMarkView = leftMarkView;
    
    UILabel *nameLab = [[UILabel alloc] init];
    nameLab.font = [UIFont systemFontOfSize:14];
    nameLab.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:nameLab];
    [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(leftMarkView.mas_right).offset(0);
        make.centerY.mas_equalTo(leftMarkView);
        make.right.mas_equalTo(0);
    }];
    _nameLab = nameLab;
}

- (void)setModel:(ClassifyModel *)model {
    _model = model;
    _nameLab.text = model.name;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"FirstClassifyTBCell";
    FirstClassifyTBCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[FirstClassifyTBCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
@end
