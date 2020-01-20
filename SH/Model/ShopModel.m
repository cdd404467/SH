//
//  ShopModel.m
//  SH
//
//  Created by i7colors on 2019/9/23.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "ShopModel.h"

@implementation ShopModel
- (NSArray *)labelArray {
    if (!_labelArray) {
        _labelArray = [self.labelNames componentsSeparatedByString:@","];
    }
    return _labelArray;
}
@end


@implementation ShopHomePageModel


@end


@implementation ClassifyListModel


@end
