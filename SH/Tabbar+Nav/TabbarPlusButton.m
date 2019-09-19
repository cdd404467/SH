//
//  TabbarPlusButton.m
//  SH
//
//  Created by i7colors on 2019/9/3.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "TabbarPlusButton.h"

@implementation TabbarPlusButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.adjustsImageWhenHighlighted = NO;
    }
    return self;
}

+ (id)plusButton {
    TabbarPlusButton *button = [[TabbarPlusButton alloc] init];
    UIImage *normalButtonImage = [UIImage imageNamed:@"plus_button"];
//    UIImage *hlightButtonImage = [UIImage imageNamed:@"post_highlight"];
    [button setImage:normalButtonImage forState:UIControlStateNormal];
    [button setTitle:@"DIY" forState:UIControlStateNormal];
//    [button setImage:hlightButtonImage forState:UIControlStateHighlighted];
//    [button setImage:hlightButtonImage forState:UIControlStateSelected];
    //    UIImage *normalButtonBackImage = [UIImage imageNamed:@"videoback"];
    //    [button setBackgroundImage:normalButtonBackImage forState:UIControlStateNormal];
    //    [button setBackgroundImage:normalButtonBackImage forState:UIControlStateSelected];
//    button.imageEdgeInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    button.titleLabel.font = [UIFont systemFontOfSize:9.5];
    [button sizeToFit]; // or set frame in this way `button.frame = CGRectMake(0.0, 0.0, 250, 100);`
    button.frame = CGRectMake(0.0, 0.0, 58, 58);
    
    // if you use `+plusChildViewController` , do not addTarget to plusButton.
//    [button addTarget:button action:@selector(clickPublish) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

//按钮垂直偏移 - 小于0.5表示 PlusButton 偏上，大于0.5则表示偏下
+ (CGFloat)multiplierOfTabBarHeight:(CGFloat)tabBarHeight {
    return  0;
}
@end
