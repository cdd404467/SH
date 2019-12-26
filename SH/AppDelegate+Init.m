//
//  AppDelegate+Init.m
//  SH
//
//  Created by i7colors on 2019/9/3.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "AppDelegate+Init.h"
#import "MainTabbarVC.h"
#import "IQKeyboardManager.h"
#import "WXApi.h"

@implementation AppDelegate (Init)

- (void)initAll {
    //初始化试图
    [self initWindow];
    //初始化第三方
    [self initThirdParty];
}

- (void)initWindow {
    //初始化window
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    if(@available(iOS 13.0,*)) {
        self.window.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    }
    //加载根视图视图
    MainTabbarVC *rootVC = [[MainTabbarVC alloc] init];
//    rootVC.selectedIndex = 0;
    self.window.rootViewController = rootVC;
    [self.window makeKeyAndVisible];
}


- (void)initThirdParty {
    /*** IQKeyBoard ***/
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = 10.0f;    // 输入框距离键盘的距离
    
    /*** 注册微信 - 官方SDK ***/
//    [WXApi registerApp:@"wx63410989373f8975" enableMTA:YES];
    [WXApi registerApp:@"wxa9974a0f587be201" universalLink:@"https://www.shanghusm.com/"];
}

@end
