//
//  CheckTheExpressVC.h
//  SH
//
//  Created by i7colors on 2020/1/3.
//  Copyright © 2020 surhoo. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CheckTheExpressVC : BaseViewController
//快递单号
@property (nonatomic, copy) NSString *expressNumber;
//快递编号
@property (nonatomic, copy) NSString *expressCode;
@end

NS_ASSUME_NONNULL_END
