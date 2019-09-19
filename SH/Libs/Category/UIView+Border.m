//
//  UIView+Border.m
//  SH
//
//  Created by i7colors on 2019/9/10.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "UIView+Border.h"

@implementation UIView (Border)

- (void)addBorder:(UIColor * _Nonnull)color width:(CGFloat)borderWidth direction:(BorderDirection)direction {
    if (direction & BorderDirectionTop) {
        [self addBorderViewTop:color andWidth:borderWidth];
    }
    if (direction & BorderDirectionLeft) {
        [self addBorderViewLeft:color andWidth:borderWidth];
    }
    if (direction & BorderDirectionBottom) {
        [self addBorderViewBottom:color andWidth:borderWidth];
    }
    if (direction & BorderDirectionRight) {
        [self addBorderViewRight:color andWidth:borderWidth];
    }
}

- (void)addBorderViewTop:(UIColor *)color andWidth:(CGFloat) borderWidth {
    UIView *border = [[UIView alloc] init];
    border.backgroundColor = color;
    [self addSubview:border];
    [border mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(borderWidth);
    }];
}

- (void)addBorderViewLeft:(UIColor *)color andWidth:(CGFloat) borderWidth {
    UIView *border = [[UIView alloc] init];
    border.backgroundColor = color;
    [self addSubview:border];
    [border mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.mas_equalTo(0);
        make.width.mas_equalTo(borderWidth);
    }];
}

- (void)addBorderViewBottom:(UIColor *)color andWidth:(CGFloat) borderWidth {
    UIView *border = [[UIView alloc] init];
    border.backgroundColor = color;
    [self addSubview:border];
    [border mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(borderWidth);
    }];
}

- (void)addBorderViewRight:(UIColor *)color andWidth:(CGFloat) borderWidth {
    UIView *border = [[UIView alloc] init];
    border.backgroundColor = color;
    [self addSubview:border];
    [border mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_equalTo(0);
        make.width.mas_equalTo(borderWidth);
    }];
}

@end
