//
//  HomeDesignerSectionCell.m
//  SH
//
//  Created by i7colors on 2019/9/9.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "HomeDesignerSectionCell.h"
#import "DesignerModel.h"
#import <UIImageView+WebCache.h>

@interface HomeDesignerSectionCell()
@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, strong) UIImageView *headerView;
@property (nonatomic, strong) UIImageView *rankImage;
@property (nonatomic, strong) UILabel *designerName;
@property (nonatomic, strong) UILabel *designerLevel;
@end

@implementation HomeDesignerSectionCell
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = UIColor.whiteColor;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UIImageView *bgView = [[UIImageView alloc] init];
    [self.contentView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    _bgView = bgView;
    //头像
    UIImageView *headerView = [[UIImageView alloc] init];
    [bgView addSubview:headerView];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(60);
        make.top.mas_equalTo(36);
        make.centerX.mas_equalTo(bgView);
    }];
    [headerView.superview layoutIfNeeded];
    [HelperTool drawRound:headerView];
    _headerView = headerView;
    
    //排名皇冠
    UIImageView *rankImage = [[UIImageView alloc] init];
    [bgView addSubview:rankImage];
    [rankImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(29);
        make.height.mas_equalTo(24);
        make.centerX.mas_equalTo(headerView);
        make.bottom.mas_equalTo(headerView.mas_top).offset(2);
    }];
    _rankImage = rankImage;
    
    //设计师等级
    UILabel *designerLevel = [[UILabel alloc] init];
    designerLevel.backgroundColor = HEXColor(@"#FF5100", 1);
    designerLevel.textColor = UIColor.whiteColor;
    designerLevel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightMedium];
    designerLevel.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:designerLevel];
    [designerLevel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(32);
        make.height.mas_equalTo(16);
        make.centerX.mas_equalTo(bgView);
        make.top.mas_equalTo(headerView.mas_bottom).offset(-5);
    }];
    [designerLevel.superview layoutIfNeeded];
    [HelperTool drawRound:designerLevel radiu:10.f];
    _designerLevel = designerLevel;
    
    //设计师昵称
    UILabel *designerName = [[UILabel alloc] init];
    designerName.textColor = HEXColor(@"#4A4A4A", 1);
    designerName.font = [UIFont systemFontOfSize:14];
    designerName.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:designerName];
    [designerName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-12);
        make.height.mas_equalTo(20);
    }];
    _designerName = designerName;
}

- (void)setModel:(DesignerModel *)model {
    _model = model;
    //设置背景
    if (_rank == 1) {
        _bgView.image = [UIImage imageNamed:@"designer_bg_NO1"];
    } else {
        _bgView.image = [UIImage imageNamed:@"designer_bg_other"];
    }
    
    [_headerView sd_setImageWithURL:ImgUrl_SD(model.headimgurl) placeholderImage:TestImage];
    _rankImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"ranking_NO%ld",(long)_rank + 1]];
    _designerLevel.text = [NSString stringWithFormat:@"lv%ld",(long)model.level];
    

    _designerName.text = model.designerName;
}

@end
