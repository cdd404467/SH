//
//  ZTNavigationViewController.h
//  ZTNavigationItem
//
//  Created by ZT on 2017/10/31.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (BarButton)

- (void)addLeftBarButtonWithImage:(UIImage *)image action:(SEL)action;

- (void)addRightBarButtonWithFirstImage:(UIImage *)firstImage action:(SEL)action;
- (void)addRightBarButtonItemWithTitle:(NSString *)itemTitle action:(SEL)action;
- (void)addRightBarButtonItemWithTitle:(NSString *)itemTitle titleColor:(UIColor *)color action:(SEL)action;
- (void)addLeftBarButtonItemWithTitle:(NSString *)itemTitle action:(SEL)action;



- (UIButton *)addPresentBarButtonRightTitle:(NSString *)itemTitle action:(SEL)action;
- (void)addPresentBarButtonleftTitle:(NSString *)itemTitle action:(SEL)action;
@end
