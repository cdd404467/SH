//
//  HelperTool.h
//  SH
//
//  Created by i7colors on 2019/9/4.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HelperTool : NSObject
//画uiview绘画圆角
+ (void)drawRound:(UIView * _Nonnull)view;
+ (void)drawRound:(UIView * _Nonnull)view radiu:(CGFloat)radius;
+ (void)drawRound:(UIView * _Nonnull)view corner:(UIRectCorner)corner radiu:(CGFloat)radius;
+ (void)drawRound:(UIView * _Nonnull)view borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;
+ (void)drawRound:(UIView * _Nonnull)view radiu:(CGFloat)radius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;
+ (void)drawRound:(UIView * _Nonnull)view corner:(UIRectCorner)corner radiu:(CGFloat)radius borderWidth:(CGFloat)borderWidth borderColor:(UIColor * _Nullable)borderColor;

// 添加点击手势
+ (void)addTapGesture:(UIView *)view withTarget:(id)target andSEL:(SEL)sel;

//水平渐变
+ (void)addLayerHorizontal:(UIView *)view startColor:(UIColor *)sColor endColor:(UIColor *)eColor;

//image画画圆角
+ (UIImage*)originImage:(UIImage *)image scaleToSize:(CGSize)size;

+ (NSString*)dictionaryToJson:(NSDictionary *)dic;

+ (UIImage *)globalGradientColor:(CGRect)rect;

//获取IP地址
+ (NSString *)getIPaddress;

// 获取当前显示的控制器
+ (UIViewController *)getCurrentVC;

// 处理小数精度问题
+ (NSString *)dealStrFormoney:(NSString *)string;

//分享
+ (void)shareSomething:(NSMutableArray<NSString *> *)imageArray urlStr:(NSString *)urlStr title:(NSString * _Nullable)title text:(NSString * _Nullable)text;
+ (void)shareSomething:(NSMutableArray<NSString *> *)imageArray urlStr:(NSString *)urlStr title:(NSString * _Nullable)title text:(NSString * _Nullable)text customItem:(NSArray * _Nullable)items;
@end

NS_ASSUME_NONNULL_END
