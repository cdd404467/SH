//
//  DesignerMainHeaderView.m
//  SH
//
//  Created by i7colors on 2019/11/28.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "DesignerMainHeaderView.h"
#import "DesignerModel.h"

@interface DesignerMainHeaderView()
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *nickNameLab;
@property (nonatomic, strong) UILabel  *levelLab;
@property (nonatomic, strong) UILabel  *introduceLab;
@end

@implementation DesignerMainHeaderView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    _bgImageView = [[UIImageView alloc] init];
    _bgImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 330);
    [self addSubview:_bgImageView];
    
    UIView *topBgViw = [[UIView alloc] init];
    topBgViw.backgroundColor = UIColor.whiteColor;
    [_bgImageView addSubview:topBgViw];
    [topBgViw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(KFit_W(130));
    }];
    
    _headImageView = [[UIImageView alloc] init];
    _headImageView.backgroundColor = Like_Color;
    _headImageView.layer.cornerRadius = 35;
    _headImageView.clipsToBounds = YES;
    [self addSubview:_headImageView];
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(topBgViw.mas_left).offset(22);
        make.centerY.mas_equalTo(topBgViw.mas_top);
        make.width.height.mas_equalTo(70);
    }];
    
    [topBgViw.superview layoutIfNeeded];
    [HelperTool drawRound:topBgViw corner:UIRectCornerTopLeft | UIRectCornerTopRight radiu:4.f];
    
    _nickNameLab = [[UILabel alloc] init];
    _nickNameLab.textColor = HEXColor(@"#090203", 1);
    _nickNameLab.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    [topBgViw addSubview:_nickNameLab];
    [_nickNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.height.mas_equalTo(24);
        make.top.mas_equalTo(self.headImageView.mas_bottom).offset(12);
        make.right.mas_lessThanOrEqualTo(-60);
    }];
    
    _levelLab = [[UILabel alloc] init];
    _levelLab.backgroundColor = HEXColor(@"#FF5100", 1);
    _levelLab.textAlignment = NSTextAlignmentCenter;
    _levelLab.textColor = UIColor.whiteColor;
    _levelLab.font = [UIFont systemFontOfSize:11 weight:UIFontWeightMedium];;
    [topBgViw addSubview:_levelLab];
    [_levelLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_nickNameLab.mas_right).offset(5);
        make.height.mas_equalTo(16);
        make.width.mas_equalTo(34);
        make.centerY.mas_equalTo(self.nickNameLab);
    }];
    [_levelLab.superview layoutIfNeeded];
    [HelperTool drawRound:_levelLab radiu:8.f];
    
    _introduceLab = [[UILabel alloc] init];
    _introduceLab.textColor = HEXColor(@"#4A4A4A", 1);
    _introduceLab.font = [UIFont systemFontOfSize:13];
    _introduceLab.numberOfLines = 2;
    [topBgViw addSubview:_introduceLab];
    [_introduceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(-7);
    }];
}

- (void)setModel:(DesignerModel *)model {
    _model = model;
    [_bgImageView sd_setImageWithURL:ImgUrl_SD_OSS(model.img, (int)SCREEN_WIDTH * 2)];
    [_headImageView sd_setImageWithURL:ImgUrl_SD_OSS(model.headimgurl, 70 * 2)];
    _nickNameLab.text = model.nickname;
    _levelLab.text = [NSString stringWithFormat:@"lv%ld",(long)model.level];
    _introduceLab.text = model.detail;
}

@end
