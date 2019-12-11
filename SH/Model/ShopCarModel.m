//
//  ShopCarModel.m
//  SH
//
//  Created by i7colors on 2019/9/25.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "ShopCarModel.h"

@implementation ShopCarModel
- (BOOL)isSelected {
    if (!_isSelected) {
        _isSelected = NO;
    }
    return _isSelected;
}
@end


@implementation ShopGoodsModel
//转换,前边的是你想用的key，后边的是返回的key
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"shopCarID" : @"id",
             };
}

- (BOOL)isSelected {
    if (!_isSelected) {
        _isSelected = NO;
    }
    return _isSelected;
}

@end
