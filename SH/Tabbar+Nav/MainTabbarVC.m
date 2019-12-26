//
//  MainTabbarVC.m
//  SH
//
//  Created by i7colors on 2019/9/2.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "MainTabbarVC.h"
#import "HomePageVC.h"
#import "MineVC.h"
#import "TabbarPlusButton.h"


@interface MainTabbarVC ()<UITabBarDelegate, UITabBarControllerDelegate>

@end

@implementation MainTabbarVC


- (instancetype)init {
    if (!(self = [super init])) {
        return nil;
    }
    
    CYLTabBarController *tabBarController = [CYLTabBarController tabBarControllerWithViewControllers:[self viewControllers] tabBarItemsAttributes:[self tabBarItemsAttributesForController] imageInsets:UIEdgeInsetsZero titlePositionAdjustment:UIOffsetZero context:@""];
    self.delegate = self;
    [self customizeTabBarAppearance];
//    self.navigationController.navigationBar.hidden = YES;
    return (self = (MainTabbarVC *)tabBarController);
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.barTintColor = UIColor.redColor;
    //去掉半透明
    self.tabBar.translucent = NO;
    self.delegate = self;
    //去掉tabbar的黑线
//    [self.tabBar setBackgroundImage:[UIImage new]];
//    [self.tabBar setShadowImage:[UIImage new]];
    //添加 + 号
//    [TabbarPlusButton registerPlusButton];
//    [self initTabbar];
    
}


- (void)customizeTabBarAppearance {
    // 普通状态下的文字属性
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSForegroundColorAttributeName] = HEXColor(@"333333", 1);
    
    // 选中状态下的文字属性
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = MainColor;
    
    // 设置文字属性
    UITabBarItem *tabBar = [UITabBarItem appearance];
    [tabBar setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    [tabBar setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    
    [UITabBar appearance].translucent = NO;
    [UITabBar appearance].barTintColor = UIColor.whiteColor;
    [[UITabBar appearance] setBackgroundColor:UIColor.whiteColor];
    [[UITabBar appearance] setBackgroundImage:[UIImage new]];
    [[UITabBar appearance] setShadowImage:[UIImage new]];
    //添加阴影
//    [UITabBar appearance].layer.shadowColor = [UIColor redColor].CGColor;
//    [UITabBar appearance].layer.shadowRadius = 15.0;
//    [UITabBar appearance].layer.shadowOpacity = 1.0;
//    [UITabBar appearance].layer.shadowOffset = CGSizeMake(0, -5);
//    self.tabBar.layer.masksToBounds = NO;
//    self.tabBar.clipsToBounds = NO;
}


//初始化tabbar
//- (void)initTabbar {
//
//    HomePageVC *vc_1 = [[HomePageVC alloc] init];
//
//    [self addChildViewController:vc_1 tabTitle:@"首页" normalImage:@"home_normal" selectedImage:@"home_selected"];
//
//    MineVC *vc_2 = [[MineVC alloc] init];
//    [self addChildViewController:vc_2 tabTitle:@"我的" normalImage:@"mine_normal" selectedImage:@"mine_selected"];
//
//
//}

////添加childViewController
//- (void)addChildViewController:(UIViewController *)vc tabTitle:(NSString *)tabTitle normalImage:(NSString *)normalImage selectedImage:(NSString *)selectedImage {
//
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
//    //    nav.navigationBar.translucent = NO;
//    nav.tabBarItem.title = tabTitle;
//    vc.navigationItem.title = tabTitle;
//    //调整每个bar title的位置
//    [nav.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -2)];
//    //调整bar icon的位置
//    nav.tabBarItem.imageInsets = UIEdgeInsetsMake(0, 0, 0, 0);
////    NSDictionary *titleColor = [NSDictionary dictionaryWithObject:RGBA(0, 0, 0, 0.7) forKey:NSForegroundColorAttributeName];
////    NSDictionary *selectedTitleColor = [NSDictionary dictionaryWithObject:MainColor forKey:NSForegroundColorAttributeName];
////    [nav.tabBarItem setTitleTextAttributes:titleColor forState:UIControlStateNormal];
////    [nav.tabBarItem setTitleTextAttributes:selectedTitleColor forState:UIControlStateSelected];
//    //未选中图片
//    UIImage *normal_image = [UIImage imageNamed:normalImage];
//    normal_image = [normal_image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    nav.tabBarItem.image = normal_image;
//    //选中后图片
//    UIImage *selected_image = [UIImage imageNamed:selectedImage];
//    selected_image = [selected_image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//
//    nav.tabBarItem.selectedImage = selected_image;
//    [self addChildViewController:nav];
//}

- (NSArray *)viewControllers {
    
    NSArray *titleArr = @[@"首页",@"我的"];
    
    HomePageVC *firstViewController = [[HomePageVC alloc] init];
    BaseNavigationController *nav_1 = [[BaseNavigationController alloc]
                                                   initWithRootViewController:firstViewController];
    
    nav_1.tabBarItem.title = titleArr[0];
    nav_1.navigationItem.title = titleArr[0];
    //调整每个bar title的位置
    [nav_1.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -2)];
    
    
    MineVC *secondViewController = [[MineVC alloc] init];
    BaseNavigationController *nav_2 = [[BaseNavigationController alloc]
                                                    initWithRootViewController:secondViewController];
    nav_2.tabBarItem.title = titleArr[1];
    nav_2.navigationItem.title = titleArr[1];
    //调整每个bar title的位置
    [nav_2.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -2)];
    
    NSArray *viewControllers = @[
                                 nav_1,
                                 nav_2,
                                 ];
    return viewControllers;
}

- (NSArray *)tabBarItemsAttributesForController {
    NSDictionary *firstTabBarItemsAttributes = @{
                                                 CYLTabBarItemTitle : @"首页",
                                                 CYLTabBarItemImage : @"home_normal",
                                                 CYLTabBarItemSelectedImage : @"home_selected",
                                                 };
    NSDictionary *secondTabBarItemsAttributes = @{
                                                  CYLTabBarItemTitle : @"我的",
                                                  CYLTabBarItemImage : @"mine_normal",
                                                  CYLTabBarItemSelectedImage : @"mine_selected",
                                                  };


    NSArray *tabBarItemsAttributes = @[
                                       firstTabBarItemsAttributes,
                                       secondTabBarItemsAttributes,
                                       ];
    return tabBarItemsAttributes;
}

@end
