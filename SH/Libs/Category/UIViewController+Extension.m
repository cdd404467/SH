//
//  UIViewController+Extension.m
//  QCY
//
//  Created by i7colors on 2019/3/18.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "UIViewController+Extension.h"

@implementation UIViewController (Extension)

- (BaseNavigationController *)mainNavController {
    BaseNavigationController *nav = nil;
    if ([self isKindOfClass:[UINavigationController class]]) {
        nav = (id)self;
    } else {
        if ([self isKindOfClass:[UITabBarController class]]) {
            nav = ((UITabBarController*)self).selectedViewController.mainNavController;
        }
        else {
            nav = (BaseNavigationController *)self.navigationController;
        }
    }
    return nav;
}

@end
