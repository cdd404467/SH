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
+ (void)alertSystemOne:(NSString *)title okBtn:(NSString *)okTitle OKCallBack:(void(^)(void))OK;
+ (void)alertSystemOne:(NSString *)title okBtn:(NSString *)okTitle  msg:(NSString *)msg  OKCallBack:(void(^)(void))OK;
+ (void)alertSystemTwo:(NSString *)title cancelBtn:(NSString *)cancelTitle okBtn:(NSString *)okTitle OKCallBack:(void(^)(void))OK;
+ (void)alertSystemTwo:(NSString *)title cancelBtn:(NSString *)cancelTitle okBtn:(NSString *)okTitle cancelCallBack:(void(^)(void))cancel OKCallBack:(void(^)(void))OK;
@end

NS_ASSUME_NONNULL_END
