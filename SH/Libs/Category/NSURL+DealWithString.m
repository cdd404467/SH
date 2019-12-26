//
//  NSURL+DealWithString.m
//  SH
//
//  Created by i7colors on 2019/12/24.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "NSURL+DealWithString.h"
#import <objc/runtime.h>

@implementation NSURL (DealWithString)

//+ (void)load {
//   // 获取URLWithString:方法的地址
//   Method URLWithStringMethod = class_getClassMethod(self, @selector(URLWithString:));
//   // 获取BMW_URLWithString:方法的地址
//   Method BMW_URLWithStringMethod = class_getClassMethod(self, @selector(BMW_URLWithString:));
//   // 交换方法地址
//   method_exchangeImplementations(URLWithStringMethod, BMW_URLWithStringMethod);
//
//}
//+ (NSURL *)BMW_URLWithString:(NSString *)URLString {
//   NSString *newURLString = [self isChinese:URLString];
//   return [NSURL BMW_URLWithString:newURLString];
//}
////处理特殊字符
//+ (NSString *)isChinese:(NSString *)str {
//    NSString *newString = str;
//    
//    for(int i=0; i< [str length];i++){
//        int a = [str characterAtIndex:i];
//        if( a > 0x4e00 && a < 0x9fff)
//        {
//            NSString *oldString = [str substringWithRange:NSMakeRange(i, 1)];
//            NSString *string = [oldString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//            newString = [newString stringByReplacingOccurrencesOfString:oldString withString:string];
//        } else{
//            
//        }
//    }
//    return newString;
//}

@end
