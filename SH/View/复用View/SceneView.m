//
//  SceneView.m
//  SH
//
//  Created by i7colors on 2019/9/9.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "SceneView.h"
#import "SceneModel.h"
#import <UIImageView+WebCache.h>

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
    imageView.frame = CGRectMake(20, 0, SCREEN_WIDTH - 40, KFit_W(200));
    imageView.image = TestImage;
    [self addSubview:imageView];
    _imageView = imageView;
    
    UILabel *explainLab = [[UILabel alloc] init];
    explainLab.frame = CGRectMake(imageView.left, imageView.bottom + 10, imageView.width, 20);
    explainLab.font = [UIFont systemFontOfSize:14];
    explainLab.textColor = HEXColor(@"#4A4A4A", 1);
    [self addSubview:explainLab];
    _explainLab = explainLab;
}

- (void)setModel:(SceneModel *)model {
    _model = model;
    [self.imageView sd_setImageWithURL:ImgUrl_SD(model.logo) placeholderImage:TestImage];
    self.explainLab.text = model.detail;
}

@end
