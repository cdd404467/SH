//
//  EvaluationTBCell.m
//  SH
//
//  Created by i7colors on 2019/9/19.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "EvaluationTBCell.h"
#import "EvaluateModel.h"

@interface EvaluationTBCell()
@property (nonatomic, strong) UIImageView *headImageview;
@property (nonatomic, strong) UILabel *nickNameLab;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UILabel *specLab;
@property (nonatomic, strong) UILabel *contentLab;
@end

@implementation EvaluationTBCell

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
    _headImageview = [[UIImageView alloc] init];
    _headImageview.frame = CGRectMake(15, 15, 40, 40);
    _headImageview.contentMode = UIViewContentModeScaleAspectFill;
    _headImageview.image = PlaceHolderImg;
    [self.contentView addSubview:_headImageview];
    [HelperTool drawRound:_headImageview];
    
    _nickNameLab = [[UILabel alloc] init];
    _nickNameLab.textColor = HEXColor(@"#090203", 1);
    _nickNameLab.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_nickNameLab];
    [_nickNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headImageview.mas_right).offset(10);
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(self.headImageview);
        make.height.mas_equalTo(17);
    }];
    
    _timeLab = [[UILabel alloc] init];
    _timeLab.textColor = HEXColor(@"#9B9B9B", 1);
    _timeLab.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_timeLab];
    [_timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headImageview);
        make.top.mas_equalTo(self.headImageview.mas_bottom).offset(8);
        make.height.mas_equalTo(17);
    }];

    _specLab = [[UILabel alloc] init];
    _specLab.textColor = _timeLab.textColor;
    _specLab.font = _timeLab.font;
    [self.contentView addSubview:_specLab];
    [_specLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.timeLab.mas_right).offset(15);
        make.centerY.mas_equalTo(self.timeLab);
        make.height.mas_equalTo(17);
        make.right.mas_lessThanOrEqualTo(-15);
    }];
    
    _contentLab = [[UILabel alloc] init];
//    _contentLab.numberOfLines = 2;
    _contentLab.textColor = HEXColor(@"#090203", 1);
    _contentLab.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_contentLab];
    [_contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headImageview);
        make.right.mas_equalTo(self.nickNameLab);
        make.top.mas_equalTo(self.timeLab.mas_bottom).offset(10);
        make.height.mas_equalTo(20);
    }];
    
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = Line_Color;
    [self.contentView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
}

- (void)setModel:(EvaluateModel *)model {
    _model = model;
    [_headImageview sd_setImageWithURL:ImgUrl_SD_OSS(model.headimgurl, 80) placeholderImage:PlaceHolderImg];
    _nickNameLab.text = model.userName;
    _timeLab.text = model.gmtCreate;
    _specLab.text = model.skuName;
    _contentLab.text = model.evaluateName;
}



+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"EvaluationTBCell";
    EvaluationTBCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[EvaluationTBCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
@end
