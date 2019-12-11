//
//  BaseViewController.m
//  SH
//
//  Created by i7colors on 2019/9/2.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "BaseViewController.h"
#import "LoginVC.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _pageNumber = 1;
        _backMode = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    if (@available(iOS 11.0, *)) {

    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.hidden = YES;
    _navBar = [[CustomNavBar alloc] init];
    [self.view addSubview:_navBar];
//    [self.view insertSubview:_navBar atIndex:1001];
    _backBtn = _navBar.leftBtn;
    if (self.navigationController.viewControllers.count > 1) {
        _navBar.leftBtn.hidden = NO;
        [_navBar.leftBtn addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    
    _backBtn = self.mainNavController.backBtn;
    
}

- (void)setBackBtnTintColor:(UIColor *)backBtnTintColor {
    _backBtnTintColor = backBtnTintColor;
    
    NSString *imageName = [NSString string];
    if (_backMode == 0) {
        imageName = @"popBack";
    } else if (_backMode == 1) {
        imageName = @"close_back";
    }
    UIImage *image = [UIImage imageNamed:imageName];
    [_backBtn setImage:[image imageWithTintColor_My:backBtnTintColor] forState:UIControlStateNormal];
    _backBtn.tintColor = backBtnTintColor;
}

- (void)setBackMode:(NSInteger)backMode {
    _backMode = backMode;
    NSString *imageName = [NSString string];
    if (backMode == 0) {
        imageName = @"popBack";
    } else if (backMode == 1) {
        imageName = @"close_back";
    }
    UIImage *image = [UIImage imageNamed:imageName];
    [_backBtn setImage:image forState:UIControlStateNormal];
    self.backBtn.left = self.backBtn.left + 2;
}

- (void)setBackBtnBgColor:(UIColor *)backBtnBgColor {
    _backBtnBgColor = backBtnBgColor;
    _backBtn.backgroundColor = backBtnBgColor;
}

- (void)jumpToLoginWithComplete:(void (^ __nullable)(void))handler {
    LoginVC *vc = [[LoginVC alloc] init];
//    vc.isJump = NO;
    vc.loginCompleteBlock = ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (handler) {
                handler();
            }
        });
    };
    BaseNavigationController *navVC = [[BaseNavigationController alloc] initWithRootViewController:vc];
    navVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:navVC animated:YES completion:nil];
}


- (void)popViewController {
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
