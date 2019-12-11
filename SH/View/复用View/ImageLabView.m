//
//  ImageLabView.m
//  SH
//
//  Created by i7colors on 2019/9/24.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "ImageLabView.h"

@interface ImageLabView()

@end

@implementation ImageLabView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    self.image = [UIImage imageNamed:@"sign_bgImg"];
    _textLab = [[UILabel alloc] init];
    _textLab.textAlignment = NSTextAlignmentCenter;
    _textLab.textColor = HEXColor(@"#FF5100", 1);
    _textLab.font = [UIFont systemFontOfSize:12];
    [self addSubview:_textLab];
    [_textLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}

@end
