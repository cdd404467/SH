//
//  UIView+Border.h
//  SH
//
//  Created by i7colors on 2019/9/10.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSInteger, BorderDirection)
{
    BorderDirectionTop      = 1 << 0,
    BorderDirectionLeft     = 1 << 1,
    BorderDirectionBottom   = 1 << 2,
    BorderDirectionRight    = 1 << 3,
    BorderDirectionAll      = BorderDirectionTop | BorderDirectionLeft | BorderDirectionBottom | BorderDirectionRight
};

@interface UIView (Border)
- (void)addBorder:(UIColor * _Nonnull)color width:(CGFloat)borderWidth direction:(BorderDirection)direction;
@end

NS_ASSUME_NONNULL_END
