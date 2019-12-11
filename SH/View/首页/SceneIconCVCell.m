//
//  SceneIconCVCell.m
//  SH
//
//  Created by i7colors on 2019/11/21.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "SceneIconCVCell.h"
#import "SceneModel.h"

@interface SceneIconCVCell()
@property (nonatomic, strong) UIImageView *iconImgView;
@property (nonatomic, strong) UILabel *nameLab;
@end

@implementation SceneIconCVCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        self.contentView.backgroundColor = UIColor.whiteColor;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    _iconImgView = [[UIImageView alloc] init];
    [self.contentView addSubview:_iconImgView];
    [_iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(44);
        make.centerX.mas_equalTo(self.contentView);
        make.top.mas_equalTo(0);
    }];
    [_iconImgView.superview layoutIfNeeded];
    [HelperTool drawRound:_iconImgView];
    
    _nameLab = [[UILabel alloc] init];
    _nameLab.textColor = HEXColor(@"#333333", 1);
    _nameLab.font = [UIFont systemFontOfSize:12];
    _nameLab.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_nameLab];
    [_nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(17);
    }];
    
}

- (void)setModel:(SceneModel *)model {
    _model = model;
    
    [_iconImgView sd_setImageWithURL:ImgUrl_SD_OSS(model.icon, 88) placeholderImage:PlaceHolderImg];
    _nameLab.text = model.name;
}


@end
