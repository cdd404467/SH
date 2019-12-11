//
//  HelperTool.m
//  SH
//
//  Created by i7colors on 2019/9/4.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "HelperTool.h"

@implementation HelperTool
#pragma mark - 画圆角和边框
+ (void)drawRound:(UIView * _Nonnull)view corner:(UIRectCorner)corner radiu:(CGFloat)radius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor {
    [view.superview layoutIfNeeded];
    //画圆角
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
    
    if (borderWidth == 0.0)
        return;
    
    //画边框
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    borderLayer.frame = view.bounds;
    borderLayer.path = maskPath.CGPath;
    borderLayer.lineWidth = borderWidth;
    borderLayer.strokeColor = borderColor.CGColor;
    [view.layer addSublayer:borderLayer];
}

//只要圆角
+ (void)drawRound:(UIView * _Nonnull)view corner:(UIRectCorner)corner radiu:(CGFloat)radius {
    [self drawRound:view corner:corner radiu:radius borderWidth:0.0 borderColor:nil];
}

+ (void)drawRound:(UIView * _Nonnull)view radiu:(CGFloat)radius {
    [self drawRound:view corner:UIRectCornerAllCorners radiu:radius];
}

+ (void)drawRound:(UIView * _Nonnull)view {
    
    [self drawRound:view radiu:view.width / 2];
}


//同时要圆角和border
+ (void)drawRound:(UIView * _Nonnull)view radiu:(CGFloat)radius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor {
    [self drawRound:view corner:UIRectCornerAllCorners radiu:radius borderWidth:borderWidth borderColor:borderColor];
}

+ (void)drawRound:(UIView * _Nonnull)view borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor {
    [self drawRound:view radiu:view.width / 2 borderWidth:borderWidth borderColor:borderColor];
}

#pragma mark - 添加点击手势
+ (void)addTapGesture:(UIView *)view withTarget:(id)target andSEL:(SEL)sel {
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:sel];
    view.userInteractionEnabled = YES;
    [view addGestureRecognizer:tap];
}

#pragma mark - 添加渐变
//添加水平渐变
+ (void)addLayerHorizontal:(UIView *)view startColor:(UIColor *)sColor endColor:(UIColor *)eColor {
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)sColor.CGColor, (__bridge id)eColor.CGColor];
    gradientLayer.locations = @[@0.0, @1.0];
    gradientLayer.startPoint = CGPointMake(0.0, 0.0);
    gradientLayer.endPoint = CGPointMake(1.0,0.0);
    gradientLayer.frame = view.bounds;
    [view.layer insertSublayer:gradientLayer atIndex:0];
}

//image 画圆角
+ (UIImage*)originImage:(UIImage *)image scaleToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

+ (NSString*)dictionaryToJson:(NSDictionary *)dic {
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];

    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

+ (UIImage *)globalGradientColor:(CGRect)rect {
    NSArray *colors= @[HEXColor(@"#FE7900", 1),HEXColor(@"#FF5100", 1)];
    UIImage *image = [UIImage imageWithGradientColor:colors andRect:rect andGradientType:1];
    return image;
}

@end
