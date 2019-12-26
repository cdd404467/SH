//
//  ConfirmOrderModel.m
//  SH
//
//  Created by i7colors on 2019/12/21.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "ConfirmOrderModel.h"

@implementation ConfirmOrderModel

@end

@implementation ConfirmOrderGoodsModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"goodsId" : @"id",
             };
}

@end
