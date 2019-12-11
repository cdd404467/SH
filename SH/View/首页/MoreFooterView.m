//
//  MoreFooterView.m
//  SH
//
//  Created by i7colors on 2019/9/25.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "MoreFooterView.h"
#import "HomePageModel.h"

@interface MoreFooterView()
@property (nonatomic, strong) UIButton *moreBtn;
@end

@implementation MoreFooterView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.whiteColor;
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreBtn addTarget:self action:@selector(pullUPOrDown) forControlEvents:UIControlEventTouchUpInside];
    [moreBtn setImage:[UIImage imageNamed:@"pull_down_more"] forState:UIControlStateNormal];
    moreBtn.adjustsImageWhenHighlighted = NO;
    [self addSubview:moreBtn];
    [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(30);
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(0);
    }];
    _moreBtn = moreBtn;
}

- (void)pullUPOrDown {
    if (self.pullBlock) {
        _model.isPullDown = !_model.isPullDown;
        self.moreBtn.transform = _model.isPullDown ? CGAffineTransformMakeRotation(M_PI) : CGAffineTransformMakeRotation(0.0);
        self.pullBlock();
    }
}

@end
