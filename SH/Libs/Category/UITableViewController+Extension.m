//
//  UITableViewController+Extension.m
//  SH
//
//  Created by i7colors on 2019/9/3.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "UITableViewController+Extension.h"

@implementation UITableViewController (Extension)

- (BaseNavigationController *)mainNavController {
    BaseNavigationController *nav = nil;
    if ([self isKindOfClass:[UINavigationController class]]) {
        nav = (id)self;
    } else {
        if ([self isKindOfClass:[UITabBarController class]]) {
//            nav = ((UITabBarController*)self).selectedViewController.mainNavController;
            nav = ((UITableViewController*)self).mainNavController;
        }
        else {
            nav = (BaseNavigationController *)self.navigationController;
        }
    }
    
    return nav;
}

@end
