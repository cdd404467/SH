//
//  GoodsModel.m
//  SH
//
//  Created by i7colors on 2019/9/10.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "GoodsModel.h"

@implementation GoodsModel

@end

@implementation GoodsDetailModel
//转换,前边的是你想用的key，后边的是返回的key
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"goodsId" : @"id",
             };
}

- (NSArray *)bannerArray {
    if (!_bannerArray) {
        _bannerArray = [self.banner componentsSeparatedByString:@","];
    }
    return _bannerArray;
}

- (CGFloat)cellHeight {
    if (!_cellHeight) {
        _cellHeight = 0.0f;
    }
    return _cellHeight;
}

@end

@implementation SpecListModel

@end

@implementation GoodsSkuSpecValsModel
- (BOOL)isSelected {
    if (!_isSelected) {
        _isSelected = NO;
    }
    return _isSelected;
}

@end

@implementation SkuListModel
//转换,前边的是你想用的key，后边的是返回的key
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"skuId" : @"id",
             };
}

- (NSArray *)skuNameArr {
    if (!_skuNameArr) {
        _skuNameArr = [self.goodsSkuName componentsSeparatedByString:@"_"];
    }
    return _skuNameArr;
}

@end
