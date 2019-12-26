//
//  DynamicStateTBCell.m
//  SH
//
//  Created by i7colors on 2019/11/29.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "DynamicStateTBCell.h"
#import "DynamicStateImgView.h"
#import "DesignerModel.h"

@interface DynamicStateTBCell()
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) DynamicStateImgView *imgsView;
@end

@implementation DynamicStateTBCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    _timeLab = [[UILabel alloc] init];
    _timeLab.font = [UIFont systemFontOfSize:14];
    _timeLab.textColor = HEXColor(@"#090203", 1);
    _timeLab.frame = CGRectMake(32, 40, SCREEN_WIDTH - 100, 15);
    [self.contentView addSubview:_timeLab];
    
    UIView *leftLine = [[UIView alloc] init];
    leftLine.backgroundColor = HEXColor(@"#F6F6F6", 1);
    [self.contentView addSubview:leftLine];
    [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(2);
        make.left.mas_equalTo(15);
        make.top.bottom.mas_equalTo(0);
    }];

    UIView *bigCircle = [[UIView alloc] init];
    bigCircle.backgroundColor = HEXColor(@"#FFE6DA", 1);
    bigCircle.layer.cornerRadius = 6.f;
    [self.contentView addSubview:bigCircle];
    [bigCircle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.width.height.mas_equalTo(12);
        make.centerY.mas_equalTo(self.timeLab);
    }];
    
    UIView *smallCircle = [[UIView alloc] init];
    smallCircle.backgroundColor = HEXColor(@"#FF5100", 1);
    smallCircle.layer.cornerRadius = 3.f;
    [bigCircle addSubview:smallCircle];
    [smallCircle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(bigCircle);
        make.width.height.mas_equalTo(6);
    }];
    
    _imgsView = [[DynamicStateImgView alloc] initWithFrame:CGRectMake(_timeLab.left, _timeLab.bottom + 20, SCREEN_WIDTH - 60, 0)];
    DDWeakSelf;
    _imgsView.clickBlock = ^(NSString * _Nonnull materialId) {
        if (weakself.clickBlock) {
            weakself.clickBlock(materialId);
        }
    };
    [self.contentView addSubview:_imgsView];
}

- (void)setModel:(DynamicStateModel *)model {
    _model = model;
    _timeLab.text = model.strDate;
    _imgsView.dataSource = model.trendsList;
    model.cellHeight = _imgsView.bottom;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"DynamicStateTBCell";
    DynamicStateTBCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[DynamicStateTBCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
@end
