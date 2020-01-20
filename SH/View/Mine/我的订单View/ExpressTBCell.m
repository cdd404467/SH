//
//  ExpressTBCell.m
//  SH
//
//  Created by i7colors on 2020/1/3.
//  Copyright © 2020 surhoo. All rights reserved.
//

#import "ExpressTBCell.h"
#import "ExpressModel.h"

@interface ExpressTBCell()
//大圆圈
@property (nonatomic, strong) UIView *bigCircleView;
//小圆圈
@property (nonatomic, strong) UIView *smallCircleView;
//时间
@property (nonatomic, strong) UILabel *timeLab;
//物流信息
@property (nonatomic, strong) UILabel *infoLab;
@property (nonatomic, strong) UIView *leftTopLine;
@property (nonatomic, strong) UIView *leftBottomLine;
@end

@implementation ExpressTBCell

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
    _timeLab = [[UILabel alloc] init];
    _timeLab.frame = CGRectMake(34, 0, SCREEN_WIDTH - 34 * 2, 17);
    _timeLab.font = [UIFont systemFontOfSize:12];
    _timeLab.textColor = HEXColor(@"#9E9E9E", 1);
    [self.contentView addSubview:_timeLab];
    
    _infoLab = [[UILabel alloc] init];
    _infoLab.frame = CGRectMake(_timeLab.left, _timeLab.bottom + 5, _timeLab.width, 0);
    _infoLab.numberOfLines = 0;
    _infoLab.font = [UIFont systemFontOfSize:12];
    _infoLab.textColor = HEXColor(@"#4A4A4A", 1);
    [self.contentView addSubview:_infoLab];
    
    _bigCircleView = [[UIView alloc] init];
    _bigCircleView.layer.cornerRadius = 10 / 2;
    [self.contentView addSubview:_bigCircleView];
    [_bigCircleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(10);
        make.centerY.mas_equalTo(self.timeLab);
        make.left.mas_equalTo(15);
    }];
    
    _smallCircleView = [[UIView alloc] init];
    _smallCircleView.layer.cornerRadius = 6 / 2;
    [_bigCircleView addSubview:_smallCircleView];
    [_smallCircleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(6);
        make.center.mas_equalTo(self.bigCircleView);
    }];

    UIView *leftTopLine = [[UIView alloc] init];
    leftTopLine.backgroundColor = HEXColor(@"#EBEBEB", 1);
    [self.contentView addSubview:leftTopLine];
    [leftTopLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.bigCircleView);
        make.width.mas_equalTo(0.9);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(self.bigCircleView.mas_top);
    }];
    _leftTopLine = leftTopLine;
    
    UIView *leftBottomLine = [[UIView alloc] init];
    leftBottomLine.backgroundColor = HEXColor(@"#EBEBEB", 1);
    [self.contentView addSubview:leftBottomLine];
    [leftBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.bigCircleView);
        make.width.mas_equalTo(leftTopLine);
        make.top.mas_equalTo(self.bigCircleView.mas_bottom);
        make.bottom.mas_equalTo(0);
    }];
    _leftBottomLine = leftBottomLine;
}

- (void)setModel:(ExpressModel *)model {
    _model = model;
    if (_index == 0) {
        _leftTopLine.hidden = YES;
        _bigCircleView.backgroundColor = HEXColor(@"#FF8B62", 1);
        _smallCircleView.backgroundColor = HEXColor(@"#F01420", 1);
    } else {
        _leftTopLine.hidden = NO;
        _bigCircleView.backgroundColor = HEXColor(@"#EBEBEB", 1);
        _smallCircleView.backgroundColor = HEXColor(@"#C4C4C4", 1);
    }
    
    _leftBottomLine.hidden = _isLineHidden;
    _timeLab.text = model.AcceptTime;
    _infoLab.text = model.AcceptStation;
    CGSize size = [_infoLab sizeThatFits:CGSizeMake(_infoLab.width, CGFLOAT_MAX)];
    _infoLab.height = size.height;
    model.cellHeight = _infoLab.bottom + 20;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"ExpressTBCell";
    ExpressTBCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[ExpressTBCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
