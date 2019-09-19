//
//  QuickTool.m
//  SH
//
//  Created by i7colors on 2019/9/6.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "QuickTool.h"

@implementation QuickTool
+ (BOOL)is_SimuLator {
    if (TARGET_IPHONE_SIMULATOR == 1 && TARGET_OS_IPHONE == 1) {
        //模拟器
        return YES;
    } else {
        //真机
        return NO;
    }
}

+ (BOOL)is_Debug {
#ifdef DEBUG
    return YES;
#else
    return NO;
#endif
}

+ (CGFloat)navBarHeight {
    UITabBarController *tab = (UITabBarController *)UIApplication.sharedApplication.keyWindow.rootViewController;
    UINavigationController *nav = tab.viewControllers[0];
    return nav.navigationBar.height;
}


@end
