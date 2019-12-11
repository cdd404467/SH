//
//  LabelModel.m
//  SH
//
//  Created by i7colors on 2019/11/27.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "LabelModel.h"

@implementation LabelModel

@end

@implementation LabelSelectModel
//转换,前边的是你想用的key，后边的是返回的key
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"labelId" : @"id",
             };
}

- (BOOL)isSelected {
    if (!_isSelected) {
        _isSelected = NO;
    }
    return _isSelected;
}

@end
