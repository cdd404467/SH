//
//  QuickTool.h
//  SH
//
//  Created by i7colors on 2019/9/6.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QuickTool : NSObject
//判断是否是模拟器
+ (BOOL)is_SimuLator;
//判断是否是debug模式
+ (BOOL)is_Debug;
//导航条（NavBar）的高度
+ (CGFloat)navBarHeight;

@end

NS_ASSUME_NONNULL_END
