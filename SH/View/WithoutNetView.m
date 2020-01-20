//
//  WithoutNetView.m
//  SH
//
//  Created by i7colors on 2020/1/6.
//  Copyright © 2020 surhoo. All rights reserved.
//

#import "WithoutNetView.h"

@implementation WithoutNetView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 100);
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = RGBA(153, 153, 153, 1);
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.text = @"无法连接到网络";
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(@0);
        make.height.mas_equalTo(30);
    }];
    
    
    UIButton *refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [refreshBtn setTitle:@"刷新试试" forState:UIControlStateNormal];
    refreshBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [refreshBtn setTitleColor:RGBA(84, 204, 84, 1) forState:UIControlStateNormal];
    [self addSubview:refreshBtn];
    [refreshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLabel.mas_bottom).with.offset(20);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.width.mas_equalTo(@(100));
        make.height.mas_equalTo(@40);
    }];
    _refreshBtn = refreshBtn;
    
}

@end
