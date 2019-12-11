//
//  SceneView.m
//  SH
//
//  Created by i7colors on 2019/9/9.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "SceneView.h"
#import "SceneModel.h"

@interface SceneView()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *explainLab;
@end

@implementation SceneView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.whiteColor;
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = PlaceHolderImg;
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(KFit_W(200));
    }];
    _imageView = imageView;
    
    UILabel *explainLab = [[UILabel alloc] init];
    explainLab.font = [UIFont systemFontOfSize:14];
    explainLab.textColor = HEXColor(@"#4A4A4A", 1);
    [self addSubview:explainLab];
    [explainLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(imageView);
        make.top.mas_equalTo(imageView.mas_bottom).offset(10);
        make.height.mas_equalTo(20);
    }];
    _explainLab = explainLab;
}

- (void)setModel:(SceneModel *)model {
    _model = model;
    int width = (SCREEN_WIDTH - 40) * 2;
    [self.imageView sd_setImageWithURL:ImgUrl_SD_OSS(model.logo, width) placeholderImage:PlaceHolderImg];
    self.explainLab.text = model.detail;
}

@end
