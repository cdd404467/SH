//
//  PayTheOrderVC.h
//  SH
//
//  Created by i7colors on 2019/12/26.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "BaseViewController.h"
@class PayModel;

NS_ASSUME_NONNULL_BEGIN
typedef void(^OrderChangeBlock)(void);
@interface PayTheOrderVC : BaseViewController
@property (nonatomic, strong) PayModel *payInfo;
@property (nonatomic, copy) NSString *totalMoney;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, copy) OrderChangeBlock orderChangeBlock;
@end

NS_ASSUME_NONNULL_END
