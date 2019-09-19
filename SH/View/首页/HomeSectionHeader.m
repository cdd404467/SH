//
//  HomeSectionHeader.m
//  SH
//
//  Created by i7colors on 2019/9/9.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "HomeSectionHeader.h"

@interface HomeSectionHeader()
@property (nonatomic, strong) UILabel *titleName;
@property (nonatomic, strong) UIButton *moreBtn;
@end

@implementation HomeSectionHeader

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.whiteColor;
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    UIView *bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 65);
    bgView.backgroundColor = UIColor.whiteColor;
    [self addSubview:bgView];
    
    //红色view
    UIView *leftView = [[UIView alloc] init];
    leftView.backgroundColor = HEXColor(@"#FF5100", 1);
    [bgView addSubview:leftView];
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.centerY.mas_equalTo(bgView);
        make.width.mas_equalTo(6);
        make.height.mas_equalTo(20);
    }];
    
    //标题
    UILabel *titleName = [[UILabel alloc] init];
    titleName.font = [UIFont systemFontOfSize:18 weight:UIFontWeightSemibold];
    titleName.textColor = HEXColor(@"#090203", 1);
    [bgView addSubview:titleName];
    [titleName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(leftView.mas_right).offset(11);
        make.centerY.mas_equalTo(leftView);
        make.right.mas_equalTo(bgView.mas_centerX);
        make.height.mas_equalTo(25);
    }];
    _titleName = titleName;
    
    //更多按钮
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreBtn setTitle:@"更多" forState:UIControlStateNormal];
    [moreBtn setTitleColor:HEXColor(@"#090203", 1) forState:UIControlStateNormal];
    moreBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    moreBtn.adjustsImageWhenHighlighted = NO;
    [moreBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:moreBtn];
    [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(45);
        make.height.mas_equalTo(35);
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(titleName);
    }];
    _moreBtn = moreBtn;
}

- (void)btnClick {
    if (self.clickMoreBlock) {
        self.clickMoreBlock();
    }
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleName.text = title;
}

- (void)setShowMoreBtn:(BOOL)showMoreBtn {
    _moreBtn.hidden = !showMoreBtn;
}

@end
