//
//  ClassifyModel.m
//  SH
//
//  Created by i7colors on 2019/9/16.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "ClassifyModel.h"

@implementation ClassifyModel
//转换,前边的是你想用的key，后边的是返回的key
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"classifyID" : @"id",
             };
}
@end
