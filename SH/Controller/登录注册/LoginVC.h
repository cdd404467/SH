//
//  LoginVC.h
//  SH
//
//  Created by i7colors on 2019/9/4.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "BaseSystemPresentVC.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^LoginCompleteBlock)(void);
@interface LoginVC : BaseSystemPresentVC
//登陆成功后的回调
@property (nonatomic, copy , nullable) LoginCompleteBlock loginCompleteBlock;
@end

NS_ASSUME_NONNULL_END
