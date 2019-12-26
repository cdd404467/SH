//
//  InvoiceModel.m
//  SH
//
//  Created by i7colors on 2019/12/15.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "InvoiceModel.h"

@implementation InvoiceModel
//转换,前边的是你想用的key，后边的是返回的key
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"invoiceID" : @"id",
             };
}
@end
