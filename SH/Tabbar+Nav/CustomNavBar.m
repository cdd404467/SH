//
//  CustomNavBar.m
//  SH
//
//  Created by i7colors on 2019/10/30.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "CustomNavBar.h"


static CGFloat navBar_Height = 44.f;

@interface CustomNavBar()


@end

@implementation CustomNavBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, NAV_HEIGHT);
        self.userInteractionEnabled = YES;
        [self setUI];
    }
    
    return self;
}

- (void)setUI {
    UIView *navBarView = [[UIView alloc] init];
    navBarView.backgroundColor = UIColor.clearColor;
    [self addSubview:navBarView];
    [navBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(navBar_Height);
    }];
    _navBarView = navBarView;
    
    //左边返回按钮
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    leftBtn.hidden = YES;
//    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 5);
    [leftBtn setImage:[UIImage imageNamed:@"popBack"] forState:UIControlStateNormal];
    [navBarView addSubview:leftBtn];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(4);
        make.height.mas_equalTo(42);
        make.width.mas_equalTo(42);
        make.centerY.mas_equalTo(navBarView);
    }];
    _leftBtn = leftBtn;
    
    //右边按钮
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.hidden = YES;
    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    rightBtn.adjustsImageWhenHighlighted = NO;
    [navBarView addSubview:rightBtn];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-4);
        make.height.width.centerY.mas_equalTo(leftBtn);
    }];
    _rightBtn = rightBtn;
    
    //标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navBarView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(navBarView);
        make.height.mas_equalTo(42);
        make.width.mas_equalTo(SCREEN_WIDTH - 56 * 2);
//        make.left.mas_equalTo(leftBtn.mas_right).offset(5);
//        make.right.mas_equalTo(rightBtn.mas_left).offset(-5);
    }];
    _titleLabel = titleLabel;
    
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.hidden = YES;
    bottomLine.backgroundColor = Like_Color;
    [self addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    _bottomLine = bottomLine;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = title;
}

- (void)setNavBarView:(UIView *)navBarView {
    if (navBarView.width > (SCREEN_WIDTH - 59 * 2)) {
        [_navBarView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [_navBarView removeFromSuperview];
        _navBarView = navBarView;
        [self insertSubview:navBarView belowSubview:self.bottomLine];
        [navBarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(navBar_Height);
        }];
    } else {
        [self.titleLabel removeFromSuperview];
        [_navBarView addSubview:navBarView];
        [navBarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.mas_equalTo(self.navBarView);
            make.height.mas_equalTo(42);
            make.width.mas_equalTo(navBarView.width);
            make.height.mas_equalTo(navBarView.height);
        }];
    }
}

- (void)setBackMode:(NSInteger)backMode {
    _backMode = backMode;
    _leftBtn.hidden = NO;
    NSString *imageName = [NSString string];
    if (backMode == 0) {
        imageName = @"popBack";
    } else if (backMode == 1) {
        imageName = @"close_back";
    }
    UIImage *image = [UIImage imageNamed:imageName];
    [_leftBtn setImage:image forState:UIControlStateNormal];
}

- (void)setBackBtnTintColor:(UIColor *)backBtnTintColor {
    _backBtnTintColor = backBtnTintColor;
    _leftBtn.hidden = NO;
    NSString *imageName = [NSString string];
    if (_backMode == 0) {
        imageName = @"popBack";
    } else if (_backMode == 1) {
        imageName = @"close_back";
    }
    UIImage *image = [UIImage imageNamed:imageName];
    [_leftBtn setImage:[image imageWithTintColor_My:backBtnTintColor] forState:UIControlStateNormal];
    _leftBtn.tintColor = backBtnTintColor;
}

@end
