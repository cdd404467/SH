//
//  SearchResultSecHeader.m
//  SH
//
//  Created by i7colors on 2019/12/25.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "SearchResultSecHeader.h"
#import "UIButton+Extension.h"

@interface SearchResultSecHeader()
@property (nonatomic, strong) UILabel *titleLab;
@end


@implementation SearchResultSecHeader
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.whiteColor;
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    UIView *gapView = [[UIView alloc] init];
    gapView.backgroundColor = HEXColor(@"#F6F6F6", 1);
    [self addSubview:gapView];
    [gapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(8);
    }];
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = UIColor.whiteColor;
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(gapView.mas_bottom);
        make.height.mas_equalTo(40);
    }];
    
    _titleLab = [[UILabel alloc] init];
    _titleLab.font = [UIFont systemFontOfSize:14];
    _titleLab.textColor = HEXColor(@"#090203", 1);
    [bgView addSubview:_titleLab];
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(30);
        make.centerY.mas_equalTo(bgView);
    }];
    
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreBtn setTitle:@"更多" forState:UIControlStateNormal];
    moreBtn.adjustsImageWhenHighlighted = NO;
    [moreBtn setImage:[UIImage imageNamed:@"right_arrow"] forState:UIControlStateNormal];
    [moreBtn setTitleColor:HEXColor(@"#4A4A4A", 1) forState:UIControlStateNormal];
    moreBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [moreBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:moreBtn];
    [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(bgView);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(44);
    }];
    [moreBtn layoutWithEdgeInsetsStyle:ButtonEdgeInsetsStyleRight imageTitleSpace:4];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = Line_Color;
    [bgView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLab.text = title;
}

- (void)btnClick {
    if (self.moreBtnClick) {
        self.moreBtnClick();
    }
}

@end
