//
//  SpecialImageView.m
//  SH
//
//  Created by i7colors on 2019/11/29.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "SpecialImageView.h"

@interface SpecialImageView()

@end

@implementation SpecialImageView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.margins = 8.f;
        self.backgroundColor = UIColor.whiteColor;
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    _imageView = [[UIImageView alloc] init];
    [self addSubview:_imageView];
}

- (void)layoutSubviews {
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(self.margins);
        make.right.bottom.mas_equalTo(-self.margins);
    }];
}

@end
