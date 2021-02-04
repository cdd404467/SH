//
//  EvaluateTBCell.m
//  SH
//
//  Created by i7colors on 2020/2/23.
//  Copyright © 2020 surhoo. All rights reserved.
//

#import "EvaluateTBCell.h"
#import "UIView+Border.h"
#import "StarView.h"
#import "EvaluateStarsModel.h"


@interface EvaluateTBCell()<CWStarRateViewDelegate>
@property (nonatomic, strong) UIImageView *goodsImageView;
@property (nonatomic, strong) StarView *starView;
@end

@implementation EvaluateTBCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = HEXColor(@"#F6F6F6", 1);
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UIView *starBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    starBgView.backgroundColor = UIColor.whiteColor;
    [starBgView addBorder:Line_Color width:0.6f direction:BorderDirectionBottom];
    [self.contentView addSubview:starBgView];
    
    UIImageView *goodsImageView = [[UIImageView alloc] init];
    goodsImageView.backgroundColor = UIColor.grayColor;
    goodsImageView.frame = CGRectMake(15, 10, 40, 40);
    [starBgView addSubview:goodsImageView];
    _goodsImageView = goodsImageView;
    
    UILabel *desTxtLab = [[UILabel alloc] init];
    desTxtLab.text = @"描述相符: ";
    desTxtLab.font = [UIFont systemFontOfSize:13];
    desTxtLab.textColor = HEXColor(@"#343333", 1);
    [starBgView addSubview:desTxtLab];
    [desTxtLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(goodsImageView.mas_right).offset(10);
        make.centerY.mas_equalTo(goodsImageView);
        make.height.mas_equalTo(18);
    }];
    [desTxtLab.superview layoutIfNeeded];
    
    
    CGRect rect = CGRectMake(desTxtLab.right + 2, 20, 20 * 5 + 15 * 4, 20);
    StarView *starView = [[StarView alloc] initWithFrame:rect numberOfStars:5];
    starView.allowIncompleteStar = NO;
    starView.delegate = self;
    starView.hasAnimation = NO;
    [starBgView addSubview:starView];
    _starView = starView;

}

- (void)setModel:(EvaluateStarsModel *)model {
    _model = model;
    _starView.scorePercent = (float)model.stars / (float)5;
    
}

- (void)starRateView:(StarView *)starRateView scroePercentDidChange:(CGFloat)newScorePercent {
    float stars = newScorePercent * (float)5;
    _model.stars = (NSInteger)stars;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"EvaluateTBCell";
    EvaluateTBCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[EvaluateTBCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
@end
