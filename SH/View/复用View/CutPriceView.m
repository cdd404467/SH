//
//  CutPriceView.m
//  SH
//
//  Created by i7colors on 2019/9/9.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "CutPriceView.h"

@interface CutPriceView()
//商品图片
@property (nonatomic, strong) UIImageView *goodsImage;
//商品名字
@property (nonatomic, strong) UILabel *goodsNameLab;
//活动名字
@property (nonatomic, strong) UILabel *activityName;

@end

@implementation CutPriceView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.whiteColor;
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    UIImageView *goodsImage = [[UIImageView alloc] init];
    goodsImage.frame = CGRectMake(15, 0, 140, 140);
    [self addSubview:goodsImage];
    _goodsImage = goodsImage;
    
    UILabel *goodsNameLab = [[UILabel alloc] init];
    goodsNameLab.numberOfLines = 2;
    goodsNameLab.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    [self addSubview:goodsNameLab];
    [goodsNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(44);
        make.top.mas_equalTo(goodsImage.mas_top).offset(4);
    }];
    _goodsNameLab = goodsNameLab;
    
    UILabel *activityName = [[UILabel alloc] init];
    activityName.text = @"砍价";
    activityName.backgroundColor = HEXColor(@"#C44347", 1);
    activityName.textColor = UIColor.whiteColor;
    activityName.textAlignment = NSTextAlignmentCenter;
    activityName.font = [UIFont systemFontOfSize:11];
    [self addSubview:activityName];
    [activityName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(goodsNameLab);
        make.height.mas_equalTo(16);
        make.width.mas_equalTo(30);
        make.top.mas_equalTo(goodsNameLab.mas_bottom).offset(6);
    }];
    [activityName.superview layoutIfNeeded];
    [HelperTool drawRound:activityName radiu:2.f];
    _activityName = activityName;
}



@end
