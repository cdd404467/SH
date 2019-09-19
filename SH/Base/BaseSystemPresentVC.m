//
//  BaseSystemPresentVC.m
//  QCY
//
//  Created by i7colors on 2019/4/1.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "BaseSystemPresentVC.h"


@interface BaseSystemPresentVC ()
@property (nonatomic, assign)BOOL isTextMode;
@end

@implementation BaseSystemPresentVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isTextMode = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self vhl_setNavBarBackgroundColor:UIColor.whiteColor];
    [self vhl_setNavBarShadowImageHidden:YES];
    [self setCompleteDBtn];
    [self setCancelBtn];
}

- (void)setCancelBtn {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
    view.backgroundColor = [UIColor clearColor];
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [leftBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    leftBtn.frame = CGRectMake(5, 0, 45, 44);
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:leftBtn];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    if (_isTextMode == YES) {
        [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    } else {
        [leftBtn setImage:[UIImage imageNamed:@"close_back"] forState:UIControlStateNormal];
        leftBtn.left = self.backBtn.left + 2;
        leftBtn.width = 38;
        _rightNavBtn.hidden = YES;
    }
}

- (void)useImgMode {
    _isTextMode = NO;
}

- (void)hideRightBtn {
    _rightNavBtn.hidden = YES;
}

- (void)displayRightbtn {
    _rightNavBtn.hidden = NO;
}

- (void)setCompleteDBtn {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 66, 44)];
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.backgroundColor = HEXColor(@"#ef3673", 1);
    rightBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [rightBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    rightBtn.frame = CGRectMake(0, 0, 56, 30);
    [rightBtn setTitle:@"完成" forState:UIControlStateNormal];
    rightBtn.layer.cornerRadius = 3.f;
    rightBtn.centerY = view.centerY;
    [rightBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:rightBtn];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    _rightNavBtn = rightBtn;
}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
