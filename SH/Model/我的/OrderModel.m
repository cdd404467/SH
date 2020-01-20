//
//  OrderModel.m
//  SH
//
//  Created by i7colors on 2019/12/23.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "OrderModel.h"

@implementation OrderModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"orderID" : @"id"
             };
}
@end

@implementation OrderGoodsModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"gId" : @"id",
             };
}

@end

@implementation OrderDetailModel



@end
