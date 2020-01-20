//
//  Alert.h
//  SH
//
//  Created by i7colors on 2019/12/12.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Alert : NSObject
//一个按钮
+ (void)alertSystemOne:(NSString * _Nullable)title msg:(NSString * _Nullable)msg okBtn:(NSString *)okTitle OKCallBack:(void(^ __nullable)(void))OK;

+ (void)alertSystemOne:(NSString * _Nullable)title msg:(NSString * _Nullable)msg okBtn:(NSString *)okTitle;
//两个按钮
+ (void)alertSystemTwo:(NSString * _Nullable)title msg:(NSString * _Nullable)msg cancelBtn:(NSString *)cancelTitle okBtn:(NSString *)okTitle cancelCallBack:(void(^ __nullable)(void))cancel OKCallBack:(void(^)(void))OK;

+ (void)alertSystemTwo:(NSString * _Nullable)title msg:(NSString * _Nullable)msg cancelBtn:(NSString *)cancelTitle okBtn:(NSString *)okTitle OKCallBack:(void(^)(void))OK;
@end

NS_ASSUME_NONNULL_END
