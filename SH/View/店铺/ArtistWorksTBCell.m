//
//  ArtistWorksTBCell.m
//  SH
//
//  Created by i7colors on 2020/1/16.
//  Copyright © 2020 surhoo. All rights reserved.
//

#import "ArtistWorksTBCell.h"
#import "ArtistWorksModel.h"

@interface ArtistWorksTBCell()
@property (nonatomic, strong) UIImageView *mainImageView;
@property (nonatomic, strong) UILabel *styleLab;
@property (nonatomic, strong) UILabel *sizeLab;
@property (nonatomic, strong) UILabel *dateLab;
@property (nonatomic, strong) UILabel *priceLab;
@end

@implementation ArtistWorksTBCell

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
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = UIColor.whiteColor;
    bgView.layer.borderColor = HEXColor(@"#E8EAEB", 1).CGColor;
    bgView.layer.borderWidth = 0.8f;
    [self.contentView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(-16);
    }];
    
    _mainImageView = [[UIImageView alloc] init];
    [bgView addSubview:_mainImageView];
    [_mainImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(KFit_W(220));
    }];
    
    _styleLab = [[UILabel alloc] init];
    _styleLab.textAlignment = NSTextAlignmentRight;
    _styleLab.font = [UIFont systemFontOfSize:11];
    _styleLab.textColor = HEXColor(@"#666666", 1);
    [bgView addSubview:_styleLab];
    [_styleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(self.mainImageView.mas_bottom).offset(14);
        make.height.mas_equalTo(12);
    }];
    
    _sizeLab = [[UILabel alloc] init];
    _sizeLab.textAlignment = NSTextAlignmentRight;
    _sizeLab.font = _styleLab.font;
    _sizeLab.textColor = _styleLab.textColor;
    [bgView addSubview:_sizeLab];
    [_sizeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(self.styleLab);
        make.top.mas_equalTo(self.styleLab.mas_bottom).offset(6);
    }];
    
    _dateLab = [[UILabel alloc] init];
    _dateLab.textAlignment = NSTextAlignmentRight;
    _dateLab.font = _styleLab.font;
    _dateLab.textColor = _styleLab.textColor;
    [bgView addSubview:_dateLab];
    [_dateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.height.mas_equalTo(self.styleLab);
        make.top.mas_equalTo(self.sizeLab.mas_bottom).offset(6);
    }];
    
    _priceLab = [[UILabel alloc] init];
    _priceLab.font = _styleLab.font;
    _priceLab.textColor = _styleLab.textColor;
    [bgView addSubview:_priceLab];
    [_priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.mas_equalTo(self.styleLab);
        make.centerY.mas_equalTo(self.dateLab);
        make.right.mas_equalTo(self.dateLab.mas_left).offset(-5);
    }];
    
}

- (void)setModel:(ArtistWorksModel *)model {
    _model = model;
    [_mainImageView sd_setImageWithURL:ImgUrl_SD_OSS(model.originalUrl, (int)(1.5 * (SCREEN_WIDTH - 30))) placeholderImage:PlaceHolder_Banner];
    _styleLab.text = model.originalName;
    _sizeLab.text = model.specs;
    NSString *year = [NSString string];
    if (model.gmtCreate.length >= 10) {
        year = [model.gmtCreate substringToIndex:10];
        year = [year stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    }
    _dateLab.text = [NSString stringWithFormat:@"创作日期: %@",year];
    _priceLab.text = model.priceShow;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"ArtistWorksTBCell";
    ArtistWorksTBCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[ArtistWorksTBCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
@end
