//
//  UIImage+Color.h
//  QCY
//
//  Created by i7colors on 2018/9/13.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Color)
+ (UIImage * _Nonnull) imageWithColor:(UIColor * _Nonnull)color size:(CGSize)size;
+ (UIImage * _Nonnull) imageWithColor:(UIColor * _Nonnull)color;

- (UIImage *_Nullable) imageWithTintColor_My:(UIColor *_Nullable)tintColor;

+ (UIImage *_Nullable)imageWithGradientColor:(NSArray *_Nullable)colors andRect:(CGRect)bounds  andGradientType:(int)gradientType;
@end
