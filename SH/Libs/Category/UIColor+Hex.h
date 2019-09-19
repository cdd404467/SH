//
//  UIColor+Hex.h
//  QCY
//
//  Created by zz on 2018/9/3.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)
+ (UIColor * _Nonnull) colorWithHexString:(NSString * _Nonnull) stringToConvert;

/**
 十二进制颜色
 @param stringToConvert 十二进制
 @param alpha 透明度
 @return 颜色
 */
+ (UIColor * _Nonnull) colorWithHexString: (NSString * _Nonnull) stringToConvert andAlpha:(CGFloat)alpha;

@end
