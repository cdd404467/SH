//
//  AppDelegate.m
//  SH
//
//  Created by i7colors on 2019/8/29.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+Init.h"
#import "WXApiManager.h"
#import "VCJump.h"

@interface AppDelegate ()
@property (nonatomic, strong)UITabBarController *tabbarController;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self initAll];
    
    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}

//回到前台
- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationName_ApplicationDidBecomeActive object:nil userInfo:nil];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//打开app处理URL
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    NSString *urlString = url.absoluteString;
    if (url && [urlString containsString:@"surhoo"]) {
        BaseNavigationController *nav = self.tabbarController.viewControllers[self.tabbarController.selectedIndex];
        [VCJump openShareURLWithHost:url.host query:url.query nav:nav];
        
        return YES;
    }

    if (url && urlString.length > 2 && [[urlString substringToIndex:2] isEqualToString:@"wx"]) {
        return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }
    return YES;
}

- (UITabBarController *)tabbarController {
    _tabbarController = (UITabBarController *)_window.rootViewController;
    return _tabbarController;
}

@end
